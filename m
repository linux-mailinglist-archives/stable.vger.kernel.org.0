Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2E5054BC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbiDRNMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241707AbiDRNI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:08:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DB42BB2E;
        Mon, 18 Apr 2022 05:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 859EE6101A;
        Mon, 18 Apr 2022 12:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0C9C385B9;
        Mon, 18 Apr 2022 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286079;
        bh=amW2hFM92tvyuVZjGN5xY5lUXYySeaJjV+QHyK7Jlms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVEofAvA+qZkSKSP2Htd93gIBImNVH4YDB0x+GJCOjsBFZR4G4vwww0GWo1aU3Pe3
         /ArckrUazXFwjqQbC3AuB+7yUAFp2FAbgXXBiCbYBnEw0wHcfPxcM8gr6+v/V49nFN
         d5tb+QE8ZieY5+S6S2bbKOjtqtZbkfXtoUFzPqco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and del_timer_sync()
Date:   Mon, 18 Apr 2022 14:10:03 +0200
Message-Id: <20220418121211.327937970@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit 3848e96edf4788f772d83990022fa7023a233d83 upstream.

xprt_destory() claims XPRT_LOCKED and then calls del_timer_sync().
Both xprt_unlock_connect() and xprt_release() call
 ->release_xprt()
which drops XPRT_LOCKED and *then* xprt_schedule_autodisconnect()
which calls mod_timer().

This may result in mod_timer() being called *after* del_timer_sync().
When this happens, the timer may fire long after the xprt has been freed,
and run_timer_softirq() will probably crash.

The pairing of ->release_xprt() and xprt_schedule_autodisconnect() is
always called under ->transport_lock.  So if we take ->transport_lock to
call del_timer_sync(), we can be sure that mod_timer() will run first
(if it runs at all).

Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprt.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1520,7 +1520,14 @@ static void xprt_destroy(struct rpc_xprt
 	 */
 	wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_UNINTERRUPTIBLE);
 
+	/*
+	 * xprt_schedule_autodisconnect() can run after XPRT_LOCKED
+	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
+	 * can only run *before* del_time_sync(), never after.
+	 */
+	spin_lock(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
+	spin_unlock(&xprt->transport_lock);
 
 	/*
 	 * Destroy sockets etc from the system workqueue so they can



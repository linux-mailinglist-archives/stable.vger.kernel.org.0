Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A04F3A78
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381438AbiDELpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354669AbiDEKPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:15:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB32E6C480;
        Tue,  5 Apr 2022 03:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83571B81C99;
        Tue,  5 Apr 2022 10:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D310CC385A1;
        Tue,  5 Apr 2022 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152941;
        bh=kqaUHqM6O4hl0lTDnmR2y1n4YeTkZq5aA0IYcX8trSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEVQwqHod0tOyQAXp3QMYA80CKNqqQJi555gfKK4X3cD2xtTEQtaaAebKt5aDKm5F
         KkGF4gyZdIToAJK9n8Fypq6x9gz5LaBQKcAhohlh0ByCrDZhEWbLt+O8W0vgk5VMM/
         scJQuG0dPTwAvvmCEW1v1UEF4f3ZJNNeJ0PTkiSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 045/599] SUNRPC: avoid race between mod_timer() and del_timer_sync()
Date:   Tue,  5 Apr 2022 09:25:39 +0200
Message-Id: <20220405070300.168786032@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -2037,7 +2037,14 @@ static void xprt_destroy(struct rpc_xprt
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



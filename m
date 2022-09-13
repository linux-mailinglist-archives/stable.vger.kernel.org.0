Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988A25B73FE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiIMPO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbiIMPOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:14:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034B45C9D8;
        Tue, 13 Sep 2022 07:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8C7614F6;
        Tue, 13 Sep 2022 14:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34043C433C1;
        Tue, 13 Sep 2022 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079595;
        bh=VNkiXlupSnUv/zFQJS9XA2oRdoEVAlkzh7X/DSkhBZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5PYit+6t/80U6/FCiVgULOJ5nMvT7QssOxikvoBA3qcfJj3jCmJ8Sa9h9L8ZNpm5
         UwA65welr4zU1jOQ/lSIbVide8WMHjPQf/GS3mxPJqj4tCdljGcoFV5ZP1vniA3cTF
         fnwnWrDjEka2l4Tvb6mHczYLlgx628Q6qdCvB/r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH 4.19 79/79] SUNRPC: use _bh spinlocking on ->transport_lock
Date:   Tue, 13 Sep 2022 16:07:37 +0200
Message-Id: <20220913140352.684003075@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: "NeilBrown" <neilb@suse.de>

Prior to Linux 5.3, ->transport_lock in sunrpc required the _bh style
spinlocks (when not called from a bottom-half handler).

When upstream 3848e96edf4788f772d83990022fa7023a233d83 was backported to
stable kernels, the spin_lock/unlock calls should have been changed to
the _bh version, but this wasn't noted in the patch and didn't happen.

So convert these lock/unlock calls to the _bh versions.

This patch is required for any stable kernel prior to 5.3 to which the
above mentioned patch was backported.  Namely 4.9.y, 4.14.y, 4.19.y.

Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
 net/sunrpc/xprt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1550,9 +1550,9 @@ static void xprt_destroy(struct rpc_xprt
 	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
 	 * can only run *before* del_time_sync(), never after.
 	 */
-	spin_lock(&xprt->transport_lock);
+	spin_lock_bh(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
-	spin_unlock(&xprt->transport_lock);
+	spin_unlock_bh(&xprt->transport_lock);
 
 	/*
 	 * Destroy sockets etc from the system workqueue so they can



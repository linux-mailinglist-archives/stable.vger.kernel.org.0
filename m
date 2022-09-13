Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABF95B74F7
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiIMP3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbiIMP3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:29:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB7012AE6;
        Tue, 13 Sep 2022 07:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD3FDB80FB3;
        Tue, 13 Sep 2022 14:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273ECC433D6;
        Tue, 13 Sep 2022 14:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079864;
        bh=Zz20S2iYhS1C8p2637bUqpeyAzUowHY50lpZhR3aER8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/lcnBYcHAGp0tPR30/l75KCVrx1RDc1KqwndTcySYa9YCnNuzIT2+B6j/U49hQ+g
         L8ClIcXqwpeFcwQZX11Gc+6DOw0+4jlqq2Xqb4JLZfDns1fc82tS5VfeenloqJibjj
         ls81ILG3Gdnp9Z2e+Cy95z6/1EVOdBak6mRqD264=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH 4.9 42/42] SUNRPC: use _bh spinlocking on ->transport_lock
Date:   Tue, 13 Sep 2022 16:08:13 +0200
Message-Id: <20220913140344.525654708@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
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
@@ -1451,9 +1451,9 @@ static void xprt_destroy(struct rpc_xprt
 	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
 	 * can only run *before* del_time_sync(), never after.
 	 */
-	spin_lock(&xprt->transport_lock);
+	spin_lock_bh(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
-	spin_unlock(&xprt->transport_lock);
+	spin_unlock_bh(&xprt->transport_lock);
 
 	rpc_xprt_debugfs_unregister(xprt);
 	rpc_destroy_wait_queue(&xprt->binding);



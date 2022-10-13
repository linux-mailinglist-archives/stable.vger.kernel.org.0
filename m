Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322F25FE03B
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiJMSFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiJMSFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:05:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A068E252B2;
        Thu, 13 Oct 2022 11:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B587DB82040;
        Thu, 13 Oct 2022 18:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2738C433D6;
        Thu, 13 Oct 2022 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684005;
        bh=cLMk1ar/nQON1mZgjjsdpVy1arXfNUVtd1FNGe7wHxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4N34Obj/cCMaRlvCk4UglUmq2EQLafJRZsO6al4oqeu+ig9g8pV6y0FnyximbHAA
         0dXhQj+zS/81O1UM5/MzJcQGt86mcQLb4+wmki2kP922rz4FrN0WKYjONAVhn0dg2C
         m3lH/E2ASiDoEfMAY56PI/QCHxqg/U2CXFnZrYXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 29/33] mctp: prevent double key removal and unref
Date:   Thu, 13 Oct 2022 19:53:01 +0200
Message-Id: <20221013175146.233632264@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
References: <20221013175145.236739253@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

commit 3a732b46736cd8a29092e4b0b1a9ba83e672bf89 upstream.

Currently, we have a bug where a simultaneous DROPTAG ioctl and socket
close may race, as we attempt to remove a key from lists twice, and
perform an unref for each removal operation. This may result in a uaf
when we attempt the second unref.

This change fixes the race by making __mctp_key_remove tolerant to being
called on a key that has already been removed from the socket/net lists,
and only performs the unref when we do the actual remove. We also need
to hold the list lock on the ioctl cleanup path.

This fix is based on a bug report and comprehensive analysis from
butt3rflyh4ck <butterflyhuangxx@gmail.com>, found via syzkaller.

Cc: stable@vger.kernel.org
Fixes: 63ed1aab3d40 ("mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls for tag control")
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |   23 ++++++++++++++++-------
 net/mctp/route.c   |   10 +++++-----
 2 files changed, 21 insertions(+), 12 deletions(-)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -295,11 +295,12 @@ __must_hold(&net->mctp.keys_lock)
 	mctp_dev_release_key(key->dev, key);
 	spin_unlock_irqrestore(&key->lock, flags);
 
-	hlist_del(&key->hlist);
-	hlist_del(&key->sklist);
-
-	/* unref for the lists */
-	mctp_key_unref(key);
+	if (!hlist_unhashed(&key->hlist)) {
+		hlist_del_init(&key->hlist);
+		hlist_del_init(&key->sklist);
+		/* unref for the lists */
+		mctp_key_unref(key);
+	}
 
 	kfree_skb(skb);
 }
@@ -373,9 +374,17 @@ static int mctp_ioctl_alloctag(struct mc
 
 	ctl.tag = tag | MCTP_TAG_OWNER | MCTP_TAG_PREALLOC;
 	if (copy_to_user((void __user *)arg, &ctl, sizeof(ctl))) {
-		spin_lock_irqsave(&key->lock, flags);
-		__mctp_key_remove(key, net, flags, MCTP_TRACE_KEY_DROPPED);
+		unsigned long fl2;
+		/* Unwind our key allocation: the keys list lock needs to be
+		 * taken before the individual key locks, and we need a valid
+		 * flags value (fl2) to pass to __mctp_key_remove, hence the
+		 * second spin_lock_irqsave() rather than a plain spin_lock().
+		 */
+		spin_lock_irqsave(&net->mctp.keys_lock, flags);
+		spin_lock_irqsave(&key->lock, fl2);
+		__mctp_key_remove(key, net, fl2, MCTP_TRACE_KEY_DROPPED);
 		mctp_key_unref(key);
+		spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 		return -EFAULT;
 	}
 
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -228,12 +228,12 @@ __releases(&key->lock)
 
 	if (!key->manual_alloc) {
 		spin_lock_irqsave(&net->mctp.keys_lock, flags);
-		hlist_del(&key->hlist);
-		hlist_del(&key->sklist);
+		if (!hlist_unhashed(&key->hlist)) {
+			hlist_del_init(&key->hlist);
+			hlist_del_init(&key->sklist);
+			mctp_key_unref(key);
+		}
 		spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
-
-		/* unref for the lists */
-		mctp_key_unref(key);
 	}
 
 	/* and one for the local reference */



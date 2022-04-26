Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FC550F430
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344875AbiDZIfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345593AbiDZIep (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E497A98C;
        Tue, 26 Apr 2022 01:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C2E61840;
        Tue, 26 Apr 2022 08:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6BDC385B1;
        Tue, 26 Apr 2022 08:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961672;
        bh=zSzyP9isGGW3GILgAaLFikoePjvqtVOrW5nxqHwccMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDjZJiLheOjUagtetC/g6U/gd50Ef3pTbtvB2t05dNlXrpkNRag8s5jrFU27ha6P7
         sGm1c81Ga0AVQDZsZpvm75z5U8Cxwfrpp6XJx+cQxu0jMP9o4EyFKVygdET3Y5jzLr
         ZE/rN35HlWeZXw//kHBsdMiUXkbyYgDITIbYSe0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 46/53] ax25: fix reference count leaks of ax25_dev
Date:   Tue, 26 Apr 2022 10:21:26 +0200
Message-Id: <20220426081737.000610387@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 87563a043cef044fed5db7967a75741cc16ad2b1 upstream.

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev
to avoid UAF bugs") introduces refcount into ax25_dev, but there
are reference leak paths in ax25_ctl_ioctl(), ax25_fwd_ioctl(),
ax25_rt_add(), ax25_rt_del() and ax25_rt_opt().

This patch uses ax25_dev_put() and adjusts the position of
ax25_addr_ax25dev() to fix reference cout leaks of ax25_dev.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220203150811.42256-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OP: backport to 4.19: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ax25.h    |    8 +++++---
 net/ax25/af_ax25.c    |   12 ++++++++----
 net/ax25/ax25_dev.c   |   24 +++++++++++++++++-------
 net/ax25/ax25_route.c |   16 +++++++++++-----
 4 files changed, 41 insertions(+), 19 deletions(-)

--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -291,10 +291,12 @@ static __inline__ void ax25_cb_put(ax25_
 	}
 }
 
-#define ax25_dev_hold(__ax25_dev) \
-	refcount_inc(&((__ax25_dev)->refcount))
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
 
-static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
 {
 	if (refcount_dec_and_test(&ax25_dev->refcount)) {
 		kfree(ax25_dev);
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -369,21 +369,25 @@ static int ax25_ctl_ioctl(const unsigned
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
-		return -ENODEV;
-
 	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
 	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (!ax25_dev)
+		return -ENODEV;
+
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (!ax25) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -88,8 +88,8 @@ void ax25_dev_device_up(struct net_devic
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
-	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -118,8 +118,8 @@ void ax25_dev_device_down(struct net_dev
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
-		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
 		ax25_dev_put(ax25_dev);
@@ -129,8 +129,8 @@ void ax25_dev_device_down(struct net_dev
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
-			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
 			ax25_dev_put(ax25_dev);
@@ -153,25 +153,35 @@ int ax25_fwd_ioctl(unsigned int cmd, str
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (!fwd_dev) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
 		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (!ax25_dev->forward) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = NULL;
+		ax25_dev_put(ax25_dev);
 		break;
 
 	default:
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
 	}
 
-	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -78,11 +78,13 @@ static int __must_check ax25_rt_add(stru
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
-		return -EINVAL;
 	if (route->digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (!ax25_dev)
+		return -EINVAL;
+
 	write_lock_bh(&ax25_route_lock);
 
 	ax25_rt = ax25_route_list;
@@ -94,6 +96,7 @@ static int __must_check ax25_rt_add(stru
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -104,6 +107,7 @@ static int __must_check ax25_rt_add(stru
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -111,6 +115,7 @@ static int __must_check ax25_rt_add(stru
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -119,11 +124,11 @@ static int __must_check ax25_rt_add(stru
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
-	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -136,6 +141,7 @@ static int __must_check ax25_rt_add(stru
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -176,8 +182,8 @@ static int ax25_rt_del(struct ax25_route
 			}
 		}
 	}
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -219,8 +225,8 @@ static int ax25_rt_opt(struct ax25_route
 	}
 
 out:
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 



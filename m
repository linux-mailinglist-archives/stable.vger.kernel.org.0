Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6050F451
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345084AbiDZIfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345587AbiDZIep (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585DC793B6;
        Tue, 26 Apr 2022 01:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E360061778;
        Tue, 26 Apr 2022 08:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0D0C385A0;
        Tue, 26 Apr 2022 08:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961669;
        bh=HRaZK4q0oobgNNfcBxQob0Vq7AIphKt7FJqZclEIGgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAWtXO/s8nQ7vl2hVDtc0TuG0XKFcgzHnABAgD07zUtX7vxOEbenLVE46wyyn/85O
         odE3oUTQ1Bx6/3WjM8DT8WkZxbpxRQJohm/AEdUVf2iRWOxb/qSz+YJs2tZRFAdhIR
         +t0O2O5n6cQq/9MC61tCOU55bN6avcicy/r1jJas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 45/53] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Tue, 26 Apr 2022 10:21:25 +0200
Message-Id: <20220426081736.970216121@linuxfoundation.org>
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

commit d01ffb9eee4af165d83b08dd73ebdf9fe94a519b upstream.

If we dereference ax25_dev after we call kfree(ax25_dev) in
ax25_dev_device_down(), it will lead to concurrency UAF bugs.
There are eight syscall functions suffer from UAF bugs, include
ax25_bind(), ax25_release(), ax25_connect(), ax25_ioctl(),
ax25_getname(), ax25_sendmsg(), ax25_getsockopt() and
ax25_info_show().

One of the concurrency UAF can be shown as below:

  (USE)                       |    (FREE)
                              |  ax25_device_event
                              |    ax25_dev_device_down
ax25_bind                     |    ...
  ...                         |      kfree(ax25_dev)
  ax25_fillin_cb()            |    ...
    ax25_fillin_cb_from_dev() |
  ...                         |

The root cause of UAF bugs is that kfree(ax25_dev) in
ax25_dev_device_down() is not protected by any locks.
When ax25_dev, which there are still pointers point to,
is released, the concurrency UAF bug will happen.

This patch introduces refcount into ax25_dev in order to
guarantee that there are no pointers point to it when ax25_dev
is released.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ax25.h    |   10 ++++++++++
 net/ax25/af_ax25.c    |    2 ++
 net/ax25/ax25_dev.c   |   12 ++++++++++--
 net/ax25/ax25_route.c |    3 +++
 4 files changed, 25 insertions(+), 2 deletions(-)

--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -236,6 +236,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -290,6 +291,15 @@ static __inline__ void ax25_cb_put(ax25_
 	}
 }
 
+#define ax25_dev_hold(__ax25_dev) \
+	refcount_inc(&((__ax25_dev)->refcount))
+
+static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+{
+	if (refcount_dec_and_test(&ax25_dev->refcount)) {
+		kfree(ax25_dev);
+	}
+}
 static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	skb->dev      = dev;
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -101,6 +101,7 @@ again:
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -449,6 +450,7 @@ static int ax25_ctl_ioctl(const unsigned
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -40,6 +40,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -59,6 +60,7 @@ void ax25_dev_device_up(struct net_devic
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold(dev);
@@ -86,6 +88,7 @@ void ax25_dev_device_up(struct net_devic
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
+	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
 
 	ax25_register_dev_sysctl(ax25_dev);
@@ -115,20 +118,22 @@ void ax25_dev_device_down(struct net_dev
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
+		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
-		kfree(ax25_dev);
+		ax25_dev_put(ax25_dev);
 		return;
 	}
 
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
+			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
-			kfree(ax25_dev);
+			ax25_dev_put(ax25_dev);
 			return;
 		}
 
@@ -136,6 +141,7 @@ void ax25_dev_device_down(struct net_dev
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -152,6 +158,7 @@ int ax25_fwd_ioctl(unsigned int cmd, str
 		if (ax25_dev->forward != NULL)
 			return -EINVAL;
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
 		break;
 
 	case SIOCAX25DELFWD:
@@ -164,6 +171,7 @@ int ax25_fwd_ioctl(unsigned int cmd, str
 		return -EINVAL;
 	}
 
+	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -119,6 +119,7 @@ static int __must_check ax25_rt_add(stru
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
+	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
@@ -175,6 +176,7 @@ static int ax25_rt_del(struct ax25_route
 			}
 		}
 	}
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 
 	return 0;
@@ -217,6 +219,7 @@ static int ax25_rt_opt(struct ax25_route
 	}
 
 out:
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 	return err;
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6379582E74
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241561AbiG0RMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236728AbiG0RME (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:12:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736345142C;
        Wed, 27 Jul 2022 09:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19EECB821C6;
        Wed, 27 Jul 2022 16:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6920EC433C1;
        Wed, 27 Jul 2022 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940101;
        bh=bd5gYaHzduW2SH4yfuMVkYTJ4C4Z4l9hyNNt7ZVn/HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KT+Iko7nbcQO7DxwWDWJ2k2K1eZ7Swmapb8vsoO3NKpwDu6FMjadhyTRYomETOrcr
         v0rgeS++FFoWfl5cey3RTH8EmJr7PvnAaBTxXm48kGkSRKGYtNz8/fcfvn1N2RgUvW
         nhpGwIMwGbg/NM2LL3y2NfACDyM3oCZ9aXmV6dZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/201] net: skb: introduce kfree_skb_reason()
Date:   Wed, 27 Jul 2022 18:09:38 +0200
Message-Id: <20220727161029.996916473@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit c504e5c2f9648a1e5c2be01e8c3f59d394192bd3 ]

Introduce the interface kfree_skb_reason(), which is able to pass
the reason why the skb is dropped to 'kfree_skb' tracepoint.

Add the 'reason' field to 'trace_kfree_skb', therefor user can get
more detail information about abnormal skb with 'drop_monitor' or
eBPF.

All drop reasons are defined in the enum 'skb_drop_reason', and
they will be print as string in 'kfree_skb' tracepoint in format
of 'reason: XXX'.

( Maybe the reasons should be defined in a uapi header file, so that
user space can use them? )

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h     | 23 ++++++++++++++++++++++-
 include/trace/events/skb.h | 36 +++++++++++++++++++++++++++++-------
 net/core/dev.c             |  3 ++-
 net/core/drop_monitor.c    | 10 +++++++---
 net/core/skbuff.c          | 12 +++++++-----
 5 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e213acaa91ec..029bc228bcf9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -304,6 +304,17 @@ struct sk_buff_head {
 
 struct sk_buff;
 
+/* The reason of skb drop, which is used in kfree_skb_reason().
+ * en...maybe they should be splited by group?
+ *
+ * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
+ * used to translate the reason to string.
+ */
+enum skb_drop_reason {
+	SKB_DROP_REASON_NOT_SPECIFIED,
+	SKB_DROP_REASON_MAX,
+};
+
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
  * buffers which do not start on a page boundary.
@@ -1074,8 +1085,18 @@ static inline bool skb_unref(struct sk_buff *skb)
 	return true;
 }
 
+void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason);
+
+/**
+ *	kfree_skb - free an sk_buff with 'NOT_SPECIFIED' reason
+ *	@skb: buffer to free
+ */
+static inline void kfree_skb(struct sk_buff *skb)
+{
+	kfree_skb_reason(skb, SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 void skb_release_head_state(struct sk_buff *skb);
-void kfree_skb(struct sk_buff *skb);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 9e92f22eb086..294c61bbe44b 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,29 +9,51 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
+#define TRACE_SKB_DROP_REASON					\
+	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EMe(SKB_DROP_REASON_MAX, MAX)
+
+#undef EM
+#undef EMe
+
+#define EM(a, b)	TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+TRACE_SKB_DROP_REASON
+
+#undef EM
+#undef EMe
+#define EM(a, b)	{ a, #b },
+#define EMe(a, b)	{ a, #b }
+
 /*
  * Tracepoint for free an sk_buff:
  */
 TRACE_EVENT(kfree_skb,
 
-	TP_PROTO(struct sk_buff *skb, void *location),
+	TP_PROTO(struct sk_buff *skb, void *location,
+		 enum skb_drop_reason reason),
 
-	TP_ARGS(skb, location),
+	TP_ARGS(skb, location, reason),
 
 	TP_STRUCT__entry(
-		__field(	void *,		skbaddr		)
-		__field(	void *,		location	)
-		__field(	unsigned short,	protocol	)
+		__field(void *,		skbaddr)
+		__field(void *,		location)
+		__field(unsigned short,	protocol)
+		__field(enum skb_drop_reason,	reason)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->location = location;
 		__entry->protocol = ntohs(skb->protocol);
+		__entry->reason = reason;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p",
-		__entry->skbaddr, __entry->protocol, __entry->location)
+	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
+		  __entry->skbaddr, __entry->protocol, __entry->location,
+		  __print_symbolic(__entry->reason,
+				   TRACE_SKB_DROP_REASON))
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 6111506a4105..12b1811cb488 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5005,7 +5005,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
 				trace_consume_skb(skb);
 			else
-				trace_kfree_skb(skb, net_tx_action);
+				trace_kfree_skb(skb, net_tx_action,
+						SKB_DROP_REASON_NOT_SPECIFIED);
 
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 				__kfree_skb(skb);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 1d99b731e5b2..78202141930f 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -110,7 +110,8 @@ static u32 net_dm_queue_len = 1000;
 
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
-				void *location);
+				void *location,
+				enum skb_drop_reason reason);
 	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
 				int work, int budget);
 	void (*work_item_func)(struct work_struct *work);
@@ -262,7 +263,9 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
-static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
+static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
+				void *location,
+				enum skb_drop_reason reason)
 {
 	trace_drop_common(skb, location);
 }
@@ -494,7 +497,8 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 
 static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 					      struct sk_buff *skb,
-					      void *location)
+					      void *location,
+					      enum skb_drop_reason reason)
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7ef0f5a8ab03..5ebef94e14dc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -759,21 +759,23 @@ void __kfree_skb(struct sk_buff *skb)
 EXPORT_SYMBOL(__kfree_skb);
 
 /**
- *	kfree_skb - free an sk_buff
+ *	kfree_skb_reason - free an sk_buff with special reason
  *	@skb: buffer to free
+ *	@reason: reason why this skb is dropped
  *
  *	Drop a reference to the buffer and free it if the usage count has
- *	hit zero.
+ *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
+ *	tracepoint.
  */
-void kfree_skb(struct sk_buff *skb)
+void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	if (!skb_unref(skb))
 		return;
 
-	trace_kfree_skb(skb, __builtin_return_address(0));
+	trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
-EXPORT_SYMBOL(kfree_skb);
+EXPORT_SYMBOL(kfree_skb_reason);
 
 void kfree_skb_list(struct sk_buff *segs)
 {
-- 
2.35.1




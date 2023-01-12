Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE8D66767D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbjALOcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbjALObm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:31:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E164FCED
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:23:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B221CCE1E6B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ACEC433D2;
        Thu, 12 Jan 2023 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533399;
        bh=4DQOyMXlgJBuPVB/7mv6To1lAsCIQWGslXAc//to2H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzkY8AKpymx14SLrXo08SjTFau0Ub6/mNMEo+ziKTyPME3CWKEUuqqjdCf+G85Fgj
         7eOl0XH9PB0j9ppHLfU9FRYdte+yfLla89oeeFUPVsbClfn8nVM8AfnhU2+V0A0Oir
         uWoz57mvyqYiQyvgEDYBNeRogz8TJYAd6vjbqktA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@idosch.org>,
        Marco Elver <elver@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 464/783] net: switch to storing KCOV handle directly in sk_buff
Date:   Thu, 12 Jan 2023 14:53:00 +0100
Message-Id: <20230112135545.769250086@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Marco Elver <elver@google.com>

[ Upstream commit fa69ee5aa48b5b52e8028c2eb486906e9998d081 ]

It turns out that usage of skb extensions can cause memory leaks. Ido
Schimmel reported: "[...] there are instances that blindly overwrite
'skb->extensions' by invoking skb_copy_header() after __alloc_skb()."

Therefore, give up on using skb extensions for KCOV handle, and instead
directly store kcov_handle in sk_buff.

Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
Fixes: 85ce50d337d1 ("net: kcov: don't select SKB_EXTENSIONS when there is no NET")
Fixes: 97f53a08cba1 ("net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling")
Link: https://lore.kernel.org/linux-wireless/20201121160941.GA485907@shredder.lan/
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20201125224840.2014773-1-elver@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 37 +++++++++++++------------------------
 lib/Kconfig.debug      |  1 -
 net/core/skbuff.c      |  6 ------
 3 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 462b0e3ef2b2..521d66ec8d80 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -702,6 +702,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@transport_header: Transport layer header
  *	@network_header: Network layer header
  *	@mac_header: Link layer header
+ *	@kcov_handle: KCOV remote handle for remote coverage collection
  *	@tail: Tail pointer
  *	@end: End pointer
  *	@head: Head of buffer
@@ -906,6 +907,10 @@ struct sk_buff {
 	__u16			network_header;
 	__u16			mac_header;
 
+#ifdef CONFIG_KCOV
+	u64			kcov_handle;
+#endif
+
 	/* private: */
 	__u32			headers_end[0];
 	/* public: */
@@ -4160,9 +4165,6 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
-#endif
-#if IS_ENABLED(CONFIG_KCOV)
-	SKB_EXT_KCOV_HANDLE,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
@@ -4618,35 +4620,22 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 #endif
 }
 
-#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle)
 {
-	/* Do not allocate skb extensions only to set kcov_handle to zero
-	 * (as it is zero by default). However, if the extensions are
-	 * already allocated, update kcov_handle anyway since
-	 * skb_set_kcov_handle can be called to zero a previously set
-	 * value.
-	 */
-	if (skb_has_extensions(skb) || kcov_handle) {
-		u64 *kcov_handle_ptr = skb_ext_add(skb, SKB_EXT_KCOV_HANDLE);
-
-		if (kcov_handle_ptr)
-			*kcov_handle_ptr = kcov_handle;
-	}
+#ifdef CONFIG_KCOV
+	skb->kcov_handle = kcov_handle;
+#endif
 }
 
 static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 {
-	u64 *kcov_handle = skb_ext_find(skb, SKB_EXT_KCOV_HANDLE);
-
-	return kcov_handle ? *kcov_handle : 0;
-}
+#ifdef CONFIG_KCOV
+	return skb->kcov_handle;
 #else
-static inline void skb_set_kcov_handle(struct sk_buff *skb,
-				       const u64 kcov_handle) { }
-static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
-#endif /* CONFIG_KCOV && CONFIG_SKB_EXTENSIONS */
+	return 0;
+#endif
+}
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4aed8abb2022..19c28a34c5f1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1915,7 +1915,6 @@ config KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
-	select SKB_EXTENSIONS if NET
 	help
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 06169889b0ca..176bcbb07aab 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4258,9 +4258,6 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MPTCP)
 	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
 #endif
-#if IS_ENABLED(CONFIG_KCOV)
-	[SKB_EXT_KCOV_HANDLE] = SKB_EXT_CHUNKSIZEOF(u64),
-#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4277,9 +4274,6 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 		skb_ext_type_len[SKB_EXT_MPTCP] +
-#endif
-#if IS_ENABLED(CONFIG_KCOV)
-		skb_ext_type_len[SKB_EXT_KCOV_HANDLE] +
 #endif
 		0;
 }
-- 
2.35.1




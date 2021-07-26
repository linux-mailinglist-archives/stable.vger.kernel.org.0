Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9063D5FF7
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhGZPUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236925AbhGZPT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:19:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B7EA60F6E;
        Mon, 26 Jul 2021 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315225;
        bh=C74wUqKWfRrdYnltohrz/NLkHnD/XDZvFEhXWQ+dZrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWPoK4U5SjAFHuIXj8Z3G9Llve8YXIGTS+DQvQXroIOQoR9v7NblXoYbbejX18+x2
         tx9M+N7dCIuMReune6WTG0W8KEpIU9COBIUTF5bcPoX2oAmNbBAjagn5MKFmLGpqkB
         bQHybSInLvqxogZedL5GwlyOc5fg46kMNot6l+Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/167] net: add kcov handle to skb extensions
Date:   Mon, 26 Jul 2021 17:37:26 +0200
Message-Id: <20210726153839.811941110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit 6370cc3bbd8a0f9bf975b013781243ab147876c6 ]

Remote KCOV coverage collection enables coverage-guided fuzzing of the
code that is not reachable during normal system call execution. It is
especially helpful for fuzzing networking subsystems, where it is
common to perform packet handling in separate work queues even for the
packets that originated directly from the user space.

Enable coverage-guided frame injection by adding kcov remote handle to
skb extensions. Default initialization in __alloc_skb and
__build_skb_around ensures that no socket buffer that was generated
during a system call will be missed.

Code that is of interest and that performs packet processing should be
annotated with kcov_remote_start()/kcov_remote_stop().

An alternative approach is to determine kcov_handle solely on the
basis of the device/interface that received the specific socket
buffer. However, in this case it would be impossible to distinguish
between packets that originated during normal background network
processes or were intentionally injected from the user space.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 33 +++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |  1 +
 net/core/skbuff.c      | 11 +++++++++++
 3 files changed, 45 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a828cf99c521..2d01b2bbb746 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4150,6 +4150,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
+#endif
+#if IS_ENABLED(CONFIG_KCOV)
+	SKB_EXT_KCOV_HANDLE,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
@@ -4605,5 +4608,35 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 #endif
 }
 
+#ifdef CONFIG_KCOV
+static inline void skb_set_kcov_handle(struct sk_buff *skb,
+				       const u64 kcov_handle)
+{
+	/* Do not allocate skb extensions only to set kcov_handle to zero
+	 * (as it is zero by default). However, if the extensions are
+	 * already allocated, update kcov_handle anyway since
+	 * skb_set_kcov_handle can be called to zero a previously set
+	 * value.
+	 */
+	if (skb_has_extensions(skb) || kcov_handle) {
+		u64 *kcov_handle_ptr = skb_ext_add(skb, SKB_EXT_KCOV_HANDLE);
+
+		if (kcov_handle_ptr)
+			*kcov_handle_ptr = kcov_handle;
+	}
+}
+
+static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
+{
+	u64 *kcov_handle = skb_ext_find(skb, SKB_EXT_KCOV_HANDLE);
+
+	return kcov_handle ? *kcov_handle : 0;
+}
+#else
+static inline void skb_set_kcov_handle(struct sk_buff *skb,
+				       const u64 kcov_handle) { }
+static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
+#endif /* CONFIG_KCOV */
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5b7f88a2876d..ffccc13d685b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1869,6 +1869,7 @@ config KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
+	select SKB_EXTENSIONS
 	help
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1301ea694b94..d17b87aabc8b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -249,6 +249,9 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 
 		fclones->skb2.fclone = SKB_FCLONE_CLONE;
 	}
+
+	skb_set_kcov_handle(skb, kcov_common_handle());
+
 out:
 	return skb;
 nodata:
@@ -282,6 +285,8 @@ static struct sk_buff *__build_skb_around(struct sk_buff *skb,
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
 	atomic_set(&shinfo->dataref, 1);
 
+	skb_set_kcov_handle(skb, kcov_common_handle());
+
 	return skb;
 }
 
@@ -4248,6 +4253,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MPTCP)
 	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
 #endif
+#if IS_ENABLED(CONFIG_KCOV)
+	[SKB_EXT_KCOV_HANDLE] = SKB_EXT_CHUNKSIZEOF(u64),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4264,6 +4272,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 		skb_ext_type_len[SKB_EXT_MPTCP] +
+#endif
+#if IS_ENABLED(CONFIG_KCOV)
+		skb_ext_type_len[SKB_EXT_KCOV_HANDLE] +
 #endif
 		0;
 }
-- 
2.30.2




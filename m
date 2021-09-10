Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FAC406BFC
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbhIJMgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233412AbhIJMfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 811C1611EF;
        Fri, 10 Sep 2021 12:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277243;
        bh=jx5t3bf8yjhyeNP/jxFN7F7TS1awzNOerSmZ7lr/JFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlNcz+cRa316AxhMe5qqBlxgWujx/tWzTB4UdDnAK4A+DV2A00n/O5AitS4MWdvEe
         baWuWzoPB0X8cLnpaQFZ/uhm4OnFOwkWCgkd19RxZNxlbVUQVMSveifO+u+OIy3a70
         3EeDLBtl5e3S+iivbA6fW4kf2upWbRBMDuwO22j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 07/26] net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling
Date:   Fri, 10 Sep 2021 14:30:11 +0200
Message-Id: <20210910122916.498423785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 97f53a08cba128a724ebbbf34778d3553d559816 upstream.

The previous Kconfig patch led to some other build errors as
reported by the 0day bot and my own overnight build testing.

These are all in <linux/skbuff.h> when KCOV is enabled but
SKB_EXTENSIONS is not enabled, so fix those by combining those conditions
in the header file.

Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
Fixes: 85ce50d337d1 ("net: kcov: don't select SKB_EXTENSIONS when there is no NET")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20201116212108.32465-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4608,7 +4608,7 @@ static inline void skb_reset_redirect(st
 #endif
 }
 
-#ifdef CONFIG_KCOV
+#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle)
 {
@@ -4636,7 +4636,7 @@ static inline u64 skb_get_kcov_handle(st
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle) { }
 static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
-#endif /* CONFIG_KCOV */
+#endif /* CONFIG_KCOV && CONFIG_SKB_EXTENSIONS */
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */



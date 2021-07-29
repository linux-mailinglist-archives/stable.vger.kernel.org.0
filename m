Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E98F3DAB51
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhG2Srs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhG2Srr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 14:47:47 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A46C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:47:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so9550308ede.4
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=56q/XfG7Ej/3qxK6s3TSsQbB3POYVRyE+XuRUxq+S4k=;
        b=jy3/MU6nnWq74n3b+nhBEcAvkLhYIjvkkVkLCVWB7U545pW9KWQX3KlKrRp41PwB0h
         fKiawnOEqjF1SkeaouH8OGIJWHzpgOiMfOhrgkK9UTe85PmxiCMvW2hXd8PcstjojXk7
         WPyyg0mW6O0x9XFn2kfYsJWt2LT2CFClOzNKQTh55qNech3p+Nir2qdUedut+2Dq10fK
         2bGRfOFbbZy7eoGSrWNkADkmHGHLHJAQdmxzYEyAKzSJDHJw7zCxTXdhO7c095AlNcc5
         Q/Ci3wEuPNiTwYgHQIs9D8Sqoy4wJBPEsRfb1twVSn5WkSAaf1Clpuk+hsF+evpSRdHE
         q86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=56q/XfG7Ej/3qxK6s3TSsQbB3POYVRyE+XuRUxq+S4k=;
        b=pPXnDqpIyCWaJYPZwWPKgXUAndjO6bUgMlA2mMQxBKIUvoXROQyD0Bh0qfNxtHsgH6
         1KnF3+lwwq0t89OIt/iewd04FXOLvo7vzfnKO9WHoucNF1he6ZTC4I0UyQoEdaSvmRRM
         O61I4QWL1Ait0fquIpzwR2Ga0aRAT9w/qGLh8hhlcVz9xXaDNcpjx9xiBrOM9v6X43ho
         sfn0Dh3N/uif2M17AYc1hcDtvgw/9qCMlIOjEpSPbvpl3WHvD1CSg9kyI7GtpDWmrVta
         ggIbKOCGdjtTf2TLc5zQ+G5dLyKdy22kUn/IqfZhBaefcNXt1dni+GbJjkjJyLJeKhWC
         kPVQ==
X-Gm-Message-State: AOAM532Sf8XpE6jvf+VjFjCFZV7d54ud0pAy92Hoy+r1Vszdkd18RRIC
        ACYB1m2UaD3+BZg4pLGWFY8FyS9yt9wRHlFO
X-Google-Smtp-Source: ABdhPJyoGl71Cm239CsRRKY1fVY4g9ajnLVwnSyXcjH8VNClvN3QlC8AcE7gMXoL9OMXp17wI9yKmA==
X-Received: by 2002:aa7:c857:: with SMTP id g23mr7595959edt.100.1627584462325;
        Thu, 29 Jul 2021 11:47:42 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id c14sm1250207ejb.78.2021.07.29.11.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:47:42 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 4.14 2/2] gro: ensure frag0 meets IP header alignment
Date:   Thu, 29 Jul 2021 20:47:33 +0200
Message-Id: <20210729184733.3217814-3-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729184733.3217814-1-matthieu.baerts@tessares.net>
References: <20210729184733.3217814-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 38ec4944b593fd90c5ef42aaaa53e66ae5769d04 ]

After commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Guenter Roeck reported one failure in his tests using sh architecture.

After much debugging, we have been able to spot silent unaligned accesses
in inet_gro_receive()

The issue at hand is that upper networking stacks assume their header
is word-aligned. Low level drivers are supposed to reserve NET_IP_ALIGN
bytes before the Ethernet header to make that happen.

This patch hardens skb_gro_reset_offset() to not allow frag0 fast-path
if the fragment is not properly aligned.

Some arches like x86, arm64 and powerpc do not care and define NET_IP_ALIGN
as 0, this extra check will be a NOP for them.

Note that if frag0 is not used, GRO will call pskb_may_pull()
as many times as needed to pull network and transport headers.

[ Backport note ]

    A small conflict has been reported:

        ++<<<<<<< HEAD
         +      if (skb_mac_header(skb) == skb_tail_pointer(skb) &&
         +          pinfo->nr_frags &&
         +          !PageHighMem(skb_frag_page(frag0))) {
        ++=======
        +       if (!skb_headlen(skb) && pinfo->nr_frags &&
        +           !PageHighMem(skb_frag_page(frag0)) &&
        +           (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
        ++>>>>>>> 38ec4944b593 (gro: ensure frag0 meets IP header alignment)

    This is expected because older kernels are missing
    commit 8aef998df3979 ("net: core: allow fast GRO for skbs with Ethernet header in head").
    This commit modifies the beginning of the 'if' statement.

    The resolution was easy: the patch we want to backport here is
    adding new conditions to the 'if' statement:

        && (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))

    We simply append these new conditions to it on older kernels.

    Another issue had to be resolved: skb_frag_off() is used in this
    patch we want to backport but this function is not defined in
    kernels < 5.4. It has then been extracted and imported from
    commit 7240b60c98d63 ("linux: Add skb_frag_t page_offset accessors").

Fixes: 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Fixes: 78a478d0efd9 ("gro: Inline skb_gro_header and cache frag0 virtual address")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/linux/skbuff.h | 9 +++++++++
 net/core/dev.c         | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index de3e59329b02..2f303454a323 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2784,6 +2784,15 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
 		skb->pfmemalloc = true;
 }
 
+/**
+ * skb_frag_off() - Returns the offset of a skb fragment
+ * @frag: the paged fragment
+ */
+static inline unsigned int skb_frag_off(const skb_frag_t *frag)
+{
+	return frag->page_offset;
+}
+
 /**
  * skb_frag_page - retrieve the page referred to by a paged fragment
  * @frag: the paged fragment
diff --git a/net/core/dev.c b/net/core/dev.c
index aa419f3162b8..ea09e0809c12 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4763,7 +4763,8 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
 
 	if (skb_mac_header(skb) == skb_tail_pointer(skb) &&
 	    pinfo->nr_frags &&
-	    !PageHighMem(skb_frag_page(frag0))) {
+	    !PageHighMem(skb_frag_page(frag0)) &&
+	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
 		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
 		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
 						    skb_frag_size(frag0),
-- 
2.31.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A263DAB36
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhG2Sot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhG2Sos (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 14:44:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038F6C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:44:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qk33so12274112ejc.12
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTvMQciHo14y7Im8y8xC3aC85/jqeGh/JTlTMH4VWNk=;
        b=LxeTY+LxzCwvdDyKC7QUyc4Zs7s1Xchi4zC/CxMN8hIrmkVm0Xba9s975l2P1tvMXd
         ARjVprx5MdyDqydSgzRywMyIMzvneOyyav8TXI1JOl7L/7ZvpQe31fUvs/alyF1+5tvt
         uMUcnsP3Jc34lrJR6Ur2NVoySUk7YMIdSphT9thycBo5e9hFrrV8ettd1MDRyXizMu0B
         DUNrdyZDVNe9FLD9SSFiyX3AlLHdvZ0j78uhXcEIB5y2iRD0me0dovfqriqG4mCAk9u0
         J8SRIj7Yh9g8yRi9JfI/TLujAQpVz64wqCMw3tj4iz6wLiIfnN8aD8PWC2D7qKyYwilv
         b0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTvMQciHo14y7Im8y8xC3aC85/jqeGh/JTlTMH4VWNk=;
        b=oB7d58DOrPY+0kIl3tfTaWg3k+Gl0Twva0boVrKFvej0+AeL4ABrNOZBIcn+m3KgPr
         MYHn/p1ci0OGnO+VcSPWWehQR7EharmEl1CSXnXiuGA2m279MczfC1GnfpcwcJQeuFEi
         ZGnZILk1jaw067slqkidxGxyJtfv/av/LPVsdRQPJh6zpTnQW3O4mZ/tj3LFx+aU5Qi7
         WR3h221qW9X++wm+if91jlaLdCUB9N5YnIUkJ3PN3vxJo27fsaMaOk2nisauLUzS8vPi
         6JuyyVjHa3wiaJyeTUBzHX9FBgTUSkx6IcmQsbj1P/DlbTzCqcsnGgzdenvDYXPZw0h3
         lBrA==
X-Gm-Message-State: AOAM5319eJ4W+jRNZbMAo9CcnFsxuACTjWNM7KP+B1PhvnmJCBGu1u25
        76vzDqgoEPXQl0JsHHG8mTpXD7+UyMnZaEMB
X-Google-Smtp-Source: ABdhPJyyZb6H67fz2/lysTYsML3jibnMPIieedMS5A8dEC2MWgJaV3JcIcaZ9ijzs/bkmEjKVjFtKw==
X-Received: by 2002:a17:907:101a:: with SMTP id ox26mr2772621ejb.236.1627584283362;
        Thu, 29 Jul 2021 11:44:43 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id l2sm1260057ejg.37.2021.07.29.11.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:44:43 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 4.19 2/2] gro: ensure frag0 meets IP header alignment
Date:   Thu, 29 Jul 2021 20:44:27 +0200
Message-Id: <20210729184427.3202526-3-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729184427.3202526-1-matthieu.baerts@tessares.net>
References: <20210729184427.3202526-1-matthieu.baerts@tessares.net>
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
index 06176ef2a842..5f2e6451ece5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2788,6 +2788,15 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
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
index 722ae0b57f3f..a6798117bb1a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5400,7 +5400,8 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
 
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


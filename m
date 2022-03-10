Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEB04D5469
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbiCJWPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240292AbiCJWPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:15:05 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494BA197B45
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 14:14:03 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q29so4891590pgn.7
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 14:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UzG3xwxvfaLfshaLysPhOgwGVwb5K3wxbNsB2PeYW8Y=;
        b=xIIfbSPNUV8Ow0wLvcRQdP2Qe7loeLLVXmOTwxDaXkfmDW5jCezViM98w7q1uQr1I2
         g2Io5NWjZjlegDBMXHuSk+kWVxbfISQOzk7UR0mcoCMj/FP9XMU5QzSH338gEXdaQMm3
         FXAYA8/XXSntazYo0o5GiyvFgBJ5bUFtmxaHVcpBwZuxVnkcFSokFlDIb88U/Nadisgb
         0oJnJDk7Jub0KO+awAzgiGlZfGkXRooPIu/ule2CbLNwTSSxC0BqhuV/puIYC3k0Vyfy
         RyQvzHYY0FabRV9wwYNpG983O9ytwUKxe98ekoHczUocjnhzjEjkhPo1bf/CT3OgdcV4
         gsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UzG3xwxvfaLfshaLysPhOgwGVwb5K3wxbNsB2PeYW8Y=;
        b=0dAD3S2K+k0yaGCAAXHydMUpMZwePhAgwpKKR+TLB6eqgSjggqklhfWV9RgvUpaEZh
         2KkBqnEpCPjVBOsU68mmKJJCWGx+Z2sEUHaVHc7AzLLPE4TZ9rBtkWKi3224h/usO4mn
         eCmh2wIv2WH6SpuWkZZsgY6+KtyYWeIGPmfVJEaJJ+ggucF8yMapfzl3FyS4Yu8AB4Og
         aXRkCp/tFvp706dvWujYtsLj7PdaRFCKeLlypYuGa1woMtnyQWPhuy66W3RdiZPqkxvK
         EbXxrZUCBxJ03/OlOKH/daE1skIYJsTo8a69o0vVrc6lpHOEnF26RFaOKi25lYvnHo+I
         cg5w==
X-Gm-Message-State: AOAM530JJXVOONbipQ8yibbEGuVGRvVAnuznexI/zIF0ZSACGp6QmjKm
        FFenBCuLozaBwzZcHYwwVvpo/Q==
X-Google-Smtp-Source: ABdhPJyDPDNCNzaw9MyEiRkIMnm6aKQ+Xl8kK1W11zZDCZEXYzHIEfNaF1f5kgz+ExrcyR7MJSGhAQ==
X-Received: by 2002:a05:6a00:843:b0:4f7:2830:6d81 with SMTP id q3-20020a056a00084300b004f728306d81mr6965380pfk.76.1646950442784;
        Thu, 10 Mar 2022 14:14:02 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id nn15-20020a17090b38cf00b001bfceefd8cfsm3511915pjb.48.2022.03.10.14.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 14:14:02 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     davem@davemloft.net
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Subject: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
Date:   Thu, 10 Mar 2022 14:13:28 -0800
Message-Id: <20220310221328.877987-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
References: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot found a kernel bug in the ipv6 stack:
LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
The reproducer triggers it by sending a crafted message via sendmmsg()
call, which triggers skb_over_panic, and crashes the kernel:

skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
dev:<NULL>

Add a check that prevents an invalid packet with MTU equall to the
fregment header size to eat up all the space for payload.

The reproducer can be found here:
LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=1648c83fb00000

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Reported-by: syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
v2: Instead of updating the alloclen add a check that prevents
    an invalid packet with MTU equall to the fregment header size
    to eat up all the space for payload.
    Fix suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
---
 net/ipv6/ip6_output.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4788f6b37053..6d45112322a0 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1649,6 +1649,16 @@ static int __ip6_append_data(struct sock *sk,
 			skb->protocol = htons(ETH_P_IPV6);
 			skb->ip_summed = csummode;
 			skb->csum = 0;
+
+			/*
+			 *	Check if there is still room for payload
+			 */
+			if (fragheaderlen >= mtu) {
+				err = -EMSGSIZE;
+				kfree_skb(skb);
+				goto error;
+			}
+
 			/* reserve for fragmentation and ipsec header */
 			skb_reserve(skb, hh_len + sizeof(struct frag_hdr) +
 				    dst_exthdrlen);
-- 
2.35.1


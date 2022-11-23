Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC2C635923
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbiKWKH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbiKWKGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0879211448
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A51EAB81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FF0C433D6;
        Wed, 23 Nov 2022 09:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197429;
        bh=PdfCU1X6XYHJsoyBFE9JeH+3AI5seyQenXz8TZFlYLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWSsvh7Ouni1f2wlBXe7At5kIk5wMgJJ9bz2QM4uVX646RuG2525i5jdAccJBSA1N
         ylJyrBQ70AKHWGzl3UhmoIGaAtyqEMY+Ld26Zscg1ZWkmTTxQP9CFyR4ihxpo+IgJr
         k9vSFTG3m0DEg9jM7vgKo3K9IdcRgMwOueCpSpbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 291/314] net: use struct_group to copy ip/ipv6 header addresses
Date:   Wed, 23 Nov 2022 09:52:16 +0100
Message-Id: <20221123084638.719999911@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 58e0be1ef6118c5352b56a4d06e974c5599993a5 ]

kernel test robot reported warnings when build bonding module with
make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/bonding/:

                 from ../drivers/net/bonding/bond_main.c:35:
In function ‘fortify_memcpy_chk’,
    inlined from ‘iph_to_flow_copy_v4addrs’ at ../include/net/ip.h:566:2,
    inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3984:3:
../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function ‘fortify_memcpy_chk’,
    inlined from ‘iph_to_flow_copy_v6addrs’ at ../include/net/ipv6.h:900:2,
    inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3994:3:
../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is because we try to copy the whole ip/ip6 address to the flow_key,
while we only point the to ip/ip6 saddr. Note that since these are UAPI
headers, __struct_group() is used to avoid the compiler warnings.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c3f8324188fa ("net: Add full IPv6 addresses to flow_keys")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20221115142400.1204786-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h          | 2 +-
 include/net/ipv6.h        | 2 +-
 include/uapi/linux/ip.h   | 6 ++++--
 include/uapi/linux/ipv6.h | 6 ++++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 1c979fd1904c..1eca38ac6c67 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -563,7 +563,7 @@ static inline void iph_to_flow_copy_v4addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v4addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v4addrs.src) +
 			      sizeof(flow->addrs.v4addrs.src));
-	memcpy(&flow->addrs.v4addrs, &iph->saddr, sizeof(flow->addrs.v4addrs));
+	memcpy(&flow->addrs.v4addrs, &iph->addrs, sizeof(flow->addrs.v4addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 }
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index de9dcc5652c4..59125562c1a4 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -897,7 +897,7 @@ static inline void iph_to_flow_copy_v6addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v6addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v6addrs.src) +
 		     sizeof(flow->addrs.v6addrs.src));
-	memcpy(&flow->addrs.v6addrs, &iph->saddr, sizeof(flow->addrs.v6addrs));
+	memcpy(&flow->addrs.v6addrs, &iph->addrs, sizeof(flow->addrs.v6addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 }
 
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index 961ec16a26b8..874a92349bf5 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -100,8 +100,10 @@ struct iphdr {
 	__u8	ttl;
 	__u8	protocol;
 	__sum16	check;
-	__be32	saddr;
-	__be32	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		__be32	saddr;
+		__be32	daddr;
+	);
 	/*The options start here. */
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 03cdbe798fe3..81f4243bebb1 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -130,8 +130,10 @@ struct ipv6hdr {
 	__u8			nexthdr;
 	__u8			hop_limit;
 
-	struct	in6_addr	saddr;
-	struct	in6_addr	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		struct	in6_addr	saddr;
+		struct	in6_addr	daddr;
+	);
 };
 
 
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E2664323D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiLETZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiLETYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:24:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B9CDFDF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25294B81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFF6C433D6;
        Mon,  5 Dec 2022 19:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268002;
        bh=IEuMc7J74Vq1N7DJbllTRIp1+yMIfdF/73nFpwkss8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yv6Si71dLdJcYRZE+bCA+KOPnwl++eb/dLRbygUxBgEhYdeMGD2IwRa1JfO/qJs8U
         QTrC6IXI+sQDtdw7gEGGOoNaNyBG0eHfApEL+rodNoSgG5wdEic3E1b7n+4p5do6XY
         mDXvScfwZ2+SRi26G8d15Rlih/3ZvjhySzRxesgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gleb Mazovetskiy <glex.spb@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/105] tcp: configurable source port perturb table size
Date:   Mon,  5 Dec 2022 20:09:22 +0100
Message-Id: <20221205190804.842005303@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

From: Gleb Mazovetskiy <glex.spb@gmail.com>

[ Upstream commit aeac4ec8f46d610a10adbaeff5e2edf6a88ffc62 ]

On embedded systems with little memory and no relevant
security concerns, it is beneficial to reduce the size
of the table.

Reducing the size from 2^16 to 2^8 saves 255 KiB
of kernel RAM.

Makes the table size configurable as an expert option.

The size was previously increased from 2^8 to 2^16
in commit 4c2c8f03a5ab ("tcp: increase source port perturb table to
2^16").

Signed-off-by: Gleb Mazovetskiy <glex.spb@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/Kconfig           | 10 ++++++++++
 net/ipv4/inet_hashtables.c | 10 +++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 2e12f848203a..8acfa1487478 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -388,6 +388,16 @@ config INET_IPCOMP
 
 	  If unsure, say Y.
 
+config INET_TABLE_PERTURB_ORDER
+	int "INET: Source port perturbation table size (as power of 2)" if EXPERT
+	default 16
+	help
+	  Source port perturbation table size (as power of 2) for
+	  RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm.
+
+	  The default is almost always what you want.
+	  Only change this if you know what you are doing.
+
 config INET_XFRM_TUNNEL
 	tristate
 	select INET_TUNNEL
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 70070f1003a0..3c58019f0718 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -718,13 +718,13 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
+ *
  * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
- * attacks were since demonstrated, thus we use 65536 instead to really
- * give more isolation and privacy, at the expense of 256kB of kernel
- * memory.
+ * attacks were since demonstrated, thus we use 65536 by default instead
+ * to really give more isolation and privacy, at the expense of 256kB
+ * of kernel memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 16
-#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+#define INET_TABLE_PERTURB_SIZE (1 << CONFIG_INET_TABLE_PERTURB_ORDER)
 static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-- 
2.35.1




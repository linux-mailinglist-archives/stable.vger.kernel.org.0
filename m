Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1C356FC47
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiGKJlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiGKJk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B458B904D4;
        Mon, 11 Jul 2022 02:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E861161227;
        Mon, 11 Jul 2022 09:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08352C34115;
        Mon, 11 Jul 2022 09:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531253;
        bh=Vymnmh1NdcpbekCmXewv0IKJXbg8zm4/a6uY9d1SZwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZOtD/uiR0N0Z76Kv7LNkwtJdLOBxuRcs8pYgZMOe03zbTYc2MvP2zCbPMaFMfEJ4
         sniVomjjgzeA8xOuEy6AZfM9m5Q1FE2aUdt05GyoV77mvE3wd6rRaFjqGggXjjspcG
         hwvuvDGCn/hg5LdHXb1lnkgJxS/TbrMBAULGqL9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/230] memory: renesas-rpc-if: Avoid unaligned bus access for HyperFlash
Date:   Mon, 11 Jul 2022 11:04:53 +0200
Message-Id: <20220711090605.133661300@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Gabbasov <andrew_gabbasov@mentor.com>

[ Upstream commit 1869023e24c0de73a160a424dac4621cefd628ae ]

HyperFlash devices in Renesas SoCs use 2-bytes addressing, according
to HW manual paragraph 62.3.3 (which officially describes Serial Flash
access, but seems to be applicable to HyperFlash too). And 1-byte bus
read operations to 2-bytes unaligned addresses in external address space
read mode work incorrectly (returns the other byte from the same word).

Function memcpy_fromio(), used by the driver to read data from the bus,
in ARM64 architecture (to which Renesas cores belong) uses 8-bytes
bus accesses for appropriate aligned addresses, and 1-bytes accesses
for other addresses. This results in incorrect data read from HyperFlash
in unaligned cases.

This issue can be reproduced using something like the following commands
(where mtd1 is a parition on Hyperflash storage, defined properly
in a device tree):

[Correct fragment, read from Hyperflash]

    root@rcar-gen3:~# dd if=/dev/mtd1 of=/tmp/zz bs=32 count=1
    root@rcar-gen3:~# hexdump -C /tmp/zz
    00000000  f4 03 00 aa f5 03 01 aa  f6 03 02 aa f7 03 03 aa  |................|
    00000010  00 00 80 d2 40 20 18 d5  00 06 81 d2 a0 18 a6 f2  |....@ ..........|
    00000020

[Incorrect read of the same fragment: see the difference at offsets 8-11]

    root@rcar-gen3:~# dd if=/dev/mtd1 of=/tmp/zz bs=12 count=1
    root@rcar-gen3:~# hexdump -C /tmp/zz
    00000000  f4 03 00 aa f5 03 01 aa  03 03 aa aa              |............|
    0000000c

Fix this issue by creating a local replacement of the copying function,
that performs only properly aligned bus accesses, and is used for reading
from HyperFlash.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Link: https://lore.kernel.org/r/20210922184830.29147-1-andrew_gabbasov@mentor.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 48 +++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 3a416705f61c..c77b23b68a93 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -199,7 +199,6 @@ static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 
 	*val = readl(rpc->base + reg);
 	return 0;
-
 }
 
 static int rpcif_reg_write(void *context, unsigned int reg, unsigned int val)
@@ -577,6 +576,48 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 }
 EXPORT_SYMBOL(rpcif_manual_xfer);
 
+static void memcpy_fromio_readw(void *to,
+				const void __iomem *from,
+				size_t count)
+{
+	const int maxw = (IS_ENABLED(CONFIG_64BIT)) ? 8 : 4;
+	u8 buf[2];
+
+	if (count && ((unsigned long)from & 1)) {
+		*(u16 *)buf = __raw_readw((void __iomem *)((unsigned long)from & ~1));
+		*(u8 *)to = buf[1];
+		from++;
+		to++;
+		count--;
+	}
+	while (count >= 2 && !IS_ALIGNED((unsigned long)from, maxw)) {
+		*(u16 *)to = __raw_readw(from);
+		from += 2;
+		to += 2;
+		count -= 2;
+	}
+	while (count >= maxw) {
+#ifdef CONFIG_64BIT
+		*(u64 *)to = __raw_readq(from);
+#else
+		*(u32 *)to = __raw_readl(from);
+#endif
+		from += maxw;
+		to += maxw;
+		count -= maxw;
+	}
+	while (count >= 2) {
+		*(u16 *)to = __raw_readw(from);
+		from += 2;
+		to += 2;
+		count -= 2;
+	}
+	if (count) {
+		*(u16 *)buf = __raw_readw(from);
+		*(u8 *)to = buf[0];
+	}
+}
+
 ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
 {
 	loff_t from = offs & (RPCIF_DIRMAP_SIZE - 1);
@@ -598,7 +639,10 @@ ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
 	regmap_write(rpc->regmap, RPCIF_DRDMCR, rpc->dummy);
 	regmap_write(rpc->regmap, RPCIF_DRDRENR, rpc->ddr);
 
-	memcpy_fromio(buf, rpc->dirmap + from, len);
+	if (rpc->bus_size == 2)
+		memcpy_fromio_readw(buf, rpc->dirmap + from, len);
+	else
+		memcpy_fromio(buf, rpc->dirmap + from, len);
 
 	pm_runtime_put(rpc->dev);
 
-- 
2.35.1




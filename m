Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9E266C4F0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjAPQAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjAPP7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:59:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3F7234D1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE3060C1B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721C9C433D2;
        Mon, 16 Jan 2023 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884782;
        bh=Kg7o9ILd9umfJqg+NIOsUPFefo2+2Ad+dmy4JUz8HOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKrjRHApIzcdZAvEQgQo/ehBdEwohkgCZvOOIVgtkSFUOod8+hkutJm4uuixYLHoy
         QW1yNFBxO70wJI+x+an0WJ5TfvWUY97g9cTH+EFmcCI9cutCx0PxtbOH5kFCiuCetJ
         jvP+sZLPytIWKerdnLaiSDTEqHtGeRWXDlPZTJkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mikhail Zhilkin <csharper2005@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/183] mtd: parsers: scpart: fix __udivdi3 undefined on mips
Date:   Mon, 16 Jan 2023 16:50:30 +0100
Message-Id: <20230116154807.888936474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Mikhail Zhilkin <csharper2005@gmail.com>

[ Upstream commit 105c14b84d93168431abba5d55e6c26fa4b65abb ]

This fixes the following compile error on mips architecture with clang
version 16.0.0 reported by the 0-DAY CI Kernel Test Service:
   ld.lld: error: undefined symbol: __udivdi3
   referenced by scpart.c
   mtd/parsers/scpart.o:(scpart_parse) in archive drivers/built-in.a

As a workaround this makes 'offs' a 32-bit type. This is enough, because
the mtd containing partition table practically does not exceed 1 MB. We
can revert this when the [Link] has been resolved.

Link: https://github.com/ClangBuiltLinux/linux/issues/1635
Fixes: 9b78ef0c7997 ("mtd: parsers: add support for Sercomm partitions")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mikhail Zhilkin <csharper2005@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/805fe58e-690f-6a3f-5ebf-2f6f6e6e4599@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/scpart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/scpart.c b/drivers/mtd/parsers/scpart.c
index 02601bb33de4..6e5e11c37078 100644
--- a/drivers/mtd/parsers/scpart.c
+++ b/drivers/mtd/parsers/scpart.c
@@ -50,7 +50,7 @@ static int scpart_scan_partmap(struct mtd_info *master, loff_t partmap_offs,
 	int cnt = 0;
 	int res = 0;
 	int res2;
-	loff_t offs;
+	uint32_t offs;
 	size_t retlen;
 	struct sc_part_desc *pdesc = NULL;
 	struct sc_part_desc *tmpdesc;
-- 
2.35.1




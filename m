Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A0469069F
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjBILSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjBILSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:18:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131DCB6D7F;
        Thu,  9 Feb 2023 03:16:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE2C061A1B;
        Thu,  9 Feb 2023 11:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359B5C433EF;
        Thu,  9 Feb 2023 11:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941401;
        bh=jD0r6D3ptcJMgMOSGbo3BBIdZWxVXUrTY/Hn+enSM/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYZhnEGxTYUaZvtxRZQcKqqj49ghDrAk3v68X46i/lAhtepg9MpAyCJ6oQZgjShx4
         gLRUdfSuHgBo3+wevb1/WDBy4LJnAhXOcGfvUQPrHkQlnllNj5VzjfdkfunorbERlI
         cUf582q3KjCHQeuiMp6EsN8gVKvYWfTrYne2N9+77GOOBBzNcTUallR3HDDcX81olF
         2uU5Ygh70ISemDRl5cuXxxeSnVCbDr+/1Rkjwa/CzAT1RGewqiKZEbkW0017FYPKs0
         xplv1yzsKxHXb9vK/wBpDV6bkACv/ivkkGKG2Mh5vN6gTPJHc4Kwytq1pJ5GXwff4t
         V8J0Xi/sbBZ4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, agordeev@linux.ibm.com,
        terrelln@fb.com, masahiroy@kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 25/38] s390/decompressor: specify __decompress() buf len to avoid overflow
Date:   Thu,  9 Feb 2023 06:14:44 -0500
Message-Id: <20230209111459.1891941-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 7ab41c2c08a32132ba8c14624910e2fe8ce4ba4b ]

Historically calls to __decompress() didn't specify "out_len" parameter
on many architectures including s390, expecting that no writes beyond
uncompressed kernel image are performed. This has changed since commit
2aa14b1ab2c4 ("zstd: import usptream v1.5.2") which includes zstd library
commit 6a7ede3dfccb ("Reduce size of dctx by reutilizing dst buffer
(#2751)"). Now zstd decompression code might store literal buffer in
the unwritten portion of the destination buffer. Since "out_len" is
not set, it is considered to be unlimited and hence free to use for
optimization needs. On s390 this might corrupt initrd or ipl report
which are often placed right after the decompressor buffer. Luckily the
size of uncompressed kernel image is already known to the decompressor,
so to avoid the problem simply specify it in the "out_len" parameter.

Link: https://github.com/facebook/zstd/commit/6a7ede3dfccb
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Link: https://lore.kernel.org/r/patch-1.thread-41c676.git-41c676c2d153.your-ad-here.call-01675030179-ext-9637@work.hours
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/decompressor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/decompressor.c b/arch/s390/boot/decompressor.c
index e27c2140d6206..623f6775d01d7 100644
--- a/arch/s390/boot/decompressor.c
+++ b/arch/s390/boot/decompressor.c
@@ -80,6 +80,6 @@ void *decompress_kernel(void)
 	void *output = (void *)decompress_offset;
 
 	__decompress(_compressed_start, _compressed_end - _compressed_start,
-		     NULL, NULL, output, 0, NULL, error);
+		     NULL, NULL, output, vmlinux.image_size, NULL, error);
 	return output;
 }
-- 
2.39.0


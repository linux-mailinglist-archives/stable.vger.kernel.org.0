Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B3169CE52
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjBTN6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjBTN6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535081E5ED
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99AC160EAE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A9C433EF;
        Mon, 20 Feb 2023 13:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901471;
        bh=jD0r6D3ptcJMgMOSGbo3BBIdZWxVXUrTY/Hn+enSM/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSYRooi0zTMFiAM0N+sGc7QJPpHpGa18yYfIEY0btzJwK413xieR34rB0f6KnLGkn
         QLjMplpA9dDI4AL8d4v7VT89kOVJUaegyXvvZPKxXsUNpdbNjxnQXlD3pDJzR9+Q17
         t777+euIluvuvmUPE8BP3EaHVlK2U4PALW4WFGCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/118] s390/decompressor: specify __decompress() buf len to avoid overflow
Date:   Mon, 20 Feb 2023 14:35:45 +0100
Message-Id: <20230220133601.599609480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




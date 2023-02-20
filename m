Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7056769CDA0
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjBTNvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjBTNvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54731E2A2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5701EB80D43
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5881C433D2;
        Mon, 20 Feb 2023 13:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901064;
        bh=UjbjQ8Yer2dYefk720z6z+rFveRSZQ0hi4knrXkKSYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Grwr+IHKUNgQyaeMZJHE6KY1y1wkbJ6IVP5k8h57kOdDQyZRXbS3aX9TjiOF44Nnt
         DpbnvRsUHpIPdJeydIeohlZgmrc1QTDKcUwNLJP5A++uojrwnHAqUMMsaZc0Q0tQS8
         sRy4HSMlv+6TIxvdjv42UdkLnGeSC6umuQW5/Nuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/83] s390/decompressor: specify __decompress() buf len to avoid overflow
Date:   Mon, 20 Feb 2023 14:35:49 +0100
Message-Id: <20230220133554.274344932@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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
 arch/s390/boot/compressed/decompressor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/compressed/decompressor.c b/arch/s390/boot/compressed/decompressor.c
index e27c2140d6206..623f6775d01d7 100644
--- a/arch/s390/boot/compressed/decompressor.c
+++ b/arch/s390/boot/compressed/decompressor.c
@@ -80,6 +80,6 @@ void *decompress_kernel(void)
 	void *output = (void *)decompress_offset;
 
 	__decompress(_compressed_start, _compressed_end - _compressed_start,
-		     NULL, NULL, output, 0, NULL, error);
+		     NULL, NULL, output, vmlinux.image_size, NULL, error);
 	return output;
 }
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0A6C5591
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjCVT73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjCVT6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:58:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A7469211;
        Wed, 22 Mar 2023 12:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24978B81DE6;
        Wed, 22 Mar 2023 19:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14083C433D2;
        Wed, 22 Mar 2023 19:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515069;
        bh=KVqki8tsn49REbsHK0b0ypCAE+hBI7NJt3mxjxZxeqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALon0rHNd+jYB0oG7mh3HFZAKFfoBXCWMYlh17gRRGt9u7oIcPOVHtJ8m2j5ftttR
         ldPathcJAw4uLC9uQkykPlwjly9rC7Di3zNRlw807PoUs1ywynJzASQLVgrtmKVcMi
         Jojaan9vVWAl/xNWp00wVUay0hs1FP6T+oQE5XjiATb6ngww5TKipVq/yEBicWvlD7
         S0AAspF5R0+i03GAxfJUEiPwlZ5NZT5FveBF1/GPawWXlZBJWqImzso6Gkp+ayYtr1
         J+2stkXxDgLeFtx1/RU+qYozaEyEy/cY6sUgfnbknwLD3N3sNKrrGcEkPD1QQ05Mye
         E6+hhIt2riTtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Terrell <terrelln@fb.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, Yann Collet <cyan@fb.com>,
        gaoxin@cdjrlc.com
Subject: [PATCH AUTOSEL 6.2 08/45] lib: zstd: Backport fix for in-place decompression
Date:   Wed, 22 Mar 2023 15:56:02 -0400
Message-Id: <20230322195639.1995821-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Terrell <terrelln@fb.com>

[ Upstream commit 038505c41f0aad26ef101f4f7f6e111531c3914f ]

Backport the relevant part of upstream commit 5b266196 [0].

This fixes in-place decompression for x86-64 kernel decompression. It
uses a bound of 131072 + (uncompressed_size >> 8), which can be violated
after upstream commit 6a7ede3d [1], as zstd can use part of the output
buffer as temporary storage, and without this patch needs a bound of
~262144.

The fix is for zstd to detect that the input and output buffers overlap,
so that zstd knows it can't use the overlapping portion of the output
buffer as tempoary storage. If the margin is not large enough, this will
ensure that zstd will fail the decompression, rather than overwriting
part of the input data, and causing corruption.

This fix has been landed upstream and is in release v1.5.4. That commit
also adds unit and fuzz tests to verify that the margin we use is
respected, and correct. That means that the fix is well tested upstream.

I have not been able to reproduce the potential bug in x86-64 kernel
decompression locally, nor have I recieved reports of failures to
decompress the kernel. It is possible that compression saves enough
space to make it very hard for the issue to appear.

I've boot tested the zstd compressed kernel on x86-64 and i386 with this
patch, which uses in-place decompression, and sanity tested zstd compression
in btrfs / squashfs to make sure that we don't see any issues, but other
uses of zstd shouldn't be affected, because they don't use in-place
decompression.

Thanks to Vasily Gorbik <gor@linux.ibm.com> for debugging a related issue
on s390, which was triggered by the same commit, but was a bug in how
__decompress() was called [2]. And to Sasha Levin <sashal@kernel.org>
for the CC alerting me of the issue.

[0] https://github.com/facebook/zstd/commit/5b266196a41e6a15e21bd4f0eeab43b938db1d90
[1] https://github.com/facebook/zstd/commit/6a7ede3dfccbf3e0a5928b4224a039c260dcff72
[2] https://lore.kernel.org/r/patch-1.thread-41c676.git-41c676c2d153.your-ad-here.call-01675030179-ext-9637@work.hours

CC: Vasily Gorbik <gor@linux.ibm.com>
CC: Heiko Carstens <hca@linux.ibm.com>
CC: Sasha Levin <sashal@kernel.org>
CC: Yann Collet <cyan@fb.com>
Signed-off-by: Nick Terrell <terrelln@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zstd/decompress/zstd_decompress.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/lib/zstd/decompress/zstd_decompress.c b/lib/zstd/decompress/zstd_decompress.c
index b9b935a9f5c0d..6b3177c947114 100644
--- a/lib/zstd/decompress/zstd_decompress.c
+++ b/lib/zstd/decompress/zstd_decompress.c
@@ -798,7 +798,7 @@ static size_t ZSTD_copyRawBlock(void* dst, size_t dstCapacity,
         if (srcSize == 0) return 0;
         RETURN_ERROR(dstBuffer_null, "");
     }
-    ZSTD_memcpy(dst, src, srcSize);
+    ZSTD_memmove(dst, src, srcSize);
     return srcSize;
 }
 
@@ -858,6 +858,7 @@ static size_t ZSTD_decompressFrame(ZSTD_DCtx* dctx,
 
     /* Loop on each block */
     while (1) {
+        BYTE* oBlockEnd = oend;
         size_t decodedSize;
         blockProperties_t blockProperties;
         size_t const cBlockSize = ZSTD_getcBlockSize(ip, remainingSrcSize, &blockProperties);
@@ -867,16 +868,34 @@ static size_t ZSTD_decompressFrame(ZSTD_DCtx* dctx,
         remainingSrcSize -= ZSTD_blockHeaderSize;
         RETURN_ERROR_IF(cBlockSize > remainingSrcSize, srcSize_wrong, "");
 
+        if (ip >= op && ip < oBlockEnd) {
+            /* We are decompressing in-place. Limit the output pointer so that we
+             * don't overwrite the block that we are currently reading. This will
+             * fail decompression if the input & output pointers aren't spaced
+             * far enough apart.
+             *
+             * This is important to set, even when the pointers are far enough
+             * apart, because ZSTD_decompressBlock_internal() can decide to store
+             * literals in the output buffer, after the block it is decompressing.
+             * Since we don't want anything to overwrite our input, we have to tell
+             * ZSTD_decompressBlock_internal to never write past ip.
+             *
+             * See ZSTD_allocateLiteralsBuffer() for reference.
+             */
+            oBlockEnd = op + (ip - op);
+        }
+
         switch(blockProperties.blockType)
         {
         case bt_compressed:
-            decodedSize = ZSTD_decompressBlock_internal(dctx, op, (size_t)(oend-op), ip, cBlockSize, /* frame */ 1, not_streaming);
+            decodedSize = ZSTD_decompressBlock_internal(dctx, op, (size_t)(oBlockEnd-op), ip, cBlockSize, /* frame */ 1, not_streaming);
             break;
         case bt_raw :
+            /* Use oend instead of oBlockEnd because this function is safe to overlap. It uses memmove. */
             decodedSize = ZSTD_copyRawBlock(op, (size_t)(oend-op), ip, cBlockSize);
             break;
         case bt_rle :
-            decodedSize = ZSTD_setRleBlock(op, (size_t)(oend-op), *ip, blockProperties.origSize);
+            decodedSize = ZSTD_setRleBlock(op, (size_t)(oBlockEnd-op), *ip, blockProperties.origSize);
             break;
         case bt_reserved :
         default:
-- 
2.39.2


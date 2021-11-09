Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95DF44A39E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbhKIB1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:27:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231962AbhKIBZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:25:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1815061B4E;
        Tue,  9 Nov 2021 01:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420198;
        bh=iMiSQysa73jwBc9OUzTzJvJcmqImLeoHVcWuSrD8heg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyJR4zyb1mXXo55G4UFBAJJyPeDXs36vxgxxRVr7Fw6SfLM47geDLW5rUcNviqysb
         KZ7l6ydmNlh98BZ/soI2IZXXNx8lO/Pgv4NtQMmpr3qE9gZHdzFPneQM1RKUmSWpxB
         lvy4kbzm+VkJuq/AAY/Th7wLZ1aTNv2NOxfYZ7tD3Tkdr1+Duon4nEK7taLWoQJDX7
         yNmlRN59fsdRvTTO8UOu8ONTf7QwIicqCOsl8QVZI8N2qAu1/TxzAnFZk52RwMV9uR
         jrFId5FVGFCYkVX8E9mQpQm3BVukHkzghVsJVyvAFlyKl3akedaSlTT9ywDFfaVaSX
         ePZzIngq+kVtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lasse Collin <lasse.collin@tukaani.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, thunder.leizhen@huawei.com,
        akpm@linux-foundation.org, gustavoars@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com
Subject: [PATCH AUTOSEL 4.4 21/30] lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression
Date:   Mon,  8 Nov 2021 20:09:09 -0500
Message-Id: <20211109010918.1192063-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

[ Upstream commit 83d3c4f22a36d005b55f44628f46cc0d319a75e8 ]

With valid files, the safety margin described in lib/decompress_unxz.c
ensures that these buffers cannot overlap. But if the uncompressed size
of the input is larger than the caller thought, which is possible when
the input file is invalid/corrupt, the buffers can overlap. Obviously
the result will then be garbage (and usually the decoder will return
an error too) but no other harm will happen when such an over-run occurs.

This change only affects uncompressed LZMA2 chunks and so this
should have no effect on performance.

Link: https://lore.kernel.org/r/20211010213145.17462-2-xiang@kernel.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_unxz.c |  2 +-
 lib/xz/xz_dec_lzma2.c | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/lib/decompress_unxz.c b/lib/decompress_unxz.c
index 25d59a95bd668..abea25310ac73 100644
--- a/lib/decompress_unxz.c
+++ b/lib/decompress_unxz.c
@@ -167,7 +167,7 @@
  * memeq and memzero are not used much and any remotely sane implementation
  * is fast enough. memcpy/memmove speed matters in multi-call mode, but
  * the kernel image is decompressed in single-call mode, in which only
- * memcpy speed can matter and only if there is a lot of uncompressible data
+ * memmove speed can matter and only if there is a lot of uncompressible data
  * (LZMA2 stores uncompressible chunks in uncompressed form). Thus, the
  * functions below should just be kept small; it's probably not worth
  * optimizing for speed.
diff --git a/lib/xz/xz_dec_lzma2.c b/lib/xz/xz_dec_lzma2.c
index 08c3c80499983..2c5197d6b944d 100644
--- a/lib/xz/xz_dec_lzma2.c
+++ b/lib/xz/xz_dec_lzma2.c
@@ -387,7 +387,14 @@ static void dict_uncompressed(struct dictionary *dict, struct xz_buf *b,
 
 		*left -= copy_size;
 
-		memcpy(dict->buf + dict->pos, b->in + b->in_pos, copy_size);
+		/*
+		 * If doing in-place decompression in single-call mode and the
+		 * uncompressed size of the file is larger than the caller
+		 * thought (i.e. it is invalid input!), the buffers below may
+		 * overlap and cause undefined behavior with memcpy().
+		 * With valid inputs memcpy() would be fine here.
+		 */
+		memmove(dict->buf + dict->pos, b->in + b->in_pos, copy_size);
 		dict->pos += copy_size;
 
 		if (dict->full < dict->pos)
@@ -397,7 +404,11 @@ static void dict_uncompressed(struct dictionary *dict, struct xz_buf *b,
 			if (dict->pos == dict->end)
 				dict->pos = 0;
 
-			memcpy(b->out + b->out_pos, b->in + b->in_pos,
+			/*
+			 * Like above but for multi-call mode: use memmove()
+			 * to avoid undefined behavior with invalid input.
+			 */
+			memmove(b->out + b->out_pos, b->in + b->in_pos,
 					copy_size);
 		}
 
@@ -421,6 +432,12 @@ static uint32_t dict_flush(struct dictionary *dict, struct xz_buf *b)
 		if (dict->pos == dict->end)
 			dict->pos = 0;
 
+		/*
+		 * These buffers cannot overlap even if doing in-place
+		 * decompression because in multi-call mode dict->buf
+		 * has been allocated by us in this file; it's not
+		 * provided by the caller like in single-call mode.
+		 */
 		memcpy(b->out + b->out_pos, dict->buf + dict->start,
 				copy_size);
 	}
-- 
2.33.0


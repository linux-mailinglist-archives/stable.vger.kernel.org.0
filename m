Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FFA3CDC07
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbhGSOvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343916AbhGSOsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B01DE61242;
        Mon, 19 Jul 2021 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708317;
        bh=kbisOGd3B+uqzPfIHDpDeTo7WJGM1uM+KCB1rcbZ+h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqO5F6KDNQRchumnsbdQA0Q5J4s+oF7JGyNqCaCOi0HAs5OAqi2fRTjdu9hlL52bg
         sds1zQmREsTF9GFEQVitLqxnIPl7toGDFjP6R4wVn7r2Ut3wKnT706JYWrmJIqj0x5
         i5AZ23bpXGU03RHDskDl9sMgeNBQBiGPcWFjVazA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Bongkyu Kim <bongkyu.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>,
        Rajat Asthana <thisisrast7@gmail.com>,
        Nick Terrell <terrelln@fb.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 265/315] lib/decompress_unlz4.c: correctly handle zero-padding around initrds.
Date:   Mon, 19 Jul 2021 16:52:34 +0200
Message-Id: <20210719144952.134159415@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dimitri John Ledkov <dimitri.ledkov@canonical.com>

[ Upstream commit 2c484419efc09e7234c667aa72698cb79ba8d8ed ]

lz4 compatible decompressor is simple.  The format is underspecified and
relies on EOF notification to determine when to stop.  Initramfs buffer
format[1] explicitly states that it can have arbitrary number of zero
padding.  Thus when operating without a fill function, be extra careful to
ensure that sizes less than 4, or apperantly empty chunksizes are treated
as EOF.

To test this I have created two cpio initrds, first a normal one,
main.cpio.  And second one with just a single /test-file with content
"second" second.cpio.  Then i compressed both of them with gzip, and with
lz4 -l.  Then I created a padding of 4 bytes (dd if=/dev/zero of=pad4 bs=1
count=4).  To create four testcase initrds:

 1) main.cpio.gzip + extra.cpio.gzip = pad0.gzip
 2) main.cpio.lz4  + extra.cpio.lz4 = pad0.lz4
 3) main.cpio.gzip + pad4 + extra.cpio.gzip = pad4.gzip
 4) main.cpio.lz4  + pad4 + extra.cpio.lz4 = pad4.lz4

The pad4 test-cases replicate the initrd load by grub, as it pads and
aligns every initrd it loads.

All of the above boot, however /test-file was not accessible in the initrd
for the testcase #4, as decoding in lz4 decompressor failed.  Also an
error message printed which usually is harmless.

Whith a patched kernel, all of the above testcases now pass, and
/test-file is accessible.

This fixes lz4 initrd decompress warning on every boot with grub.  And
more importantly this fixes inability to load multiple lz4 compressed
initrds with grub.  This patch has been shipping in Ubuntu kernels since
January 2021.

[1] ./Documentation/driver-api/early-userspace/buffer-format.rst

BugLink: https://bugs.launchpad.net/bugs/1835660
Link: https://lore.kernel.org/lkml/20210114200256.196589-1-xnox@ubuntu.com/ # v0
Link: https://lkml.kernel.org/r/20210513104831.432975-1-dimitri.ledkov@canonical.com
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Bongkyu Kim <bongkyu.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Cc: Rajat Asthana <thisisrast7@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_unlz4.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index 1b0baf3008ea..b202aa864c48 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -115,6 +115,9 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 				error("data corrupted");
 				goto exit_2;
 			}
+		} else if (size < 4) {
+			/* empty or end-of-file */
+			goto exit_3;
 		}
 
 		chunksize = get_unaligned_le32(inp);
@@ -128,6 +131,10 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			continue;
 		}
 
+		if (!fill && chunksize == 0) {
+			/* empty or end-of-file */
+			goto exit_3;
+		}
 
 		if (posp)
 			*posp += 4;
@@ -187,6 +194,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 		}
 	}
 
+exit_3:
 	ret = 0;
 exit_2:
 	if (!input)
-- 
2.30.2




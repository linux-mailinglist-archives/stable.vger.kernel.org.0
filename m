Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E652B6330
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732491AbgKQNfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732513AbgKQNfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF50924654;
        Tue, 17 Nov 2020 13:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620144;
        bh=ITzL0DHMO5cn7ZHSVUyvh9zs/VOC0VJ6rgNllJ0xRCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkE/GXxRdW7gnwO1bpXfUfq6ksC6RM9gjqSufBnj5e/kVn2kvB6fhlwpwjwlY1cTP
         i9y1MFYOZ7ER1ioMT63Es/KJK5it1Y6ltWwDdFxxpXQA9skcQ/Rm/HRjMnvLRSBo4M
         E6vHUc2HiOkzhrHog+fvgCMypI81H5VWItUtFC1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan OLeary <ryanoleary@google.com>,
        Benjamin Gwin <bgwin@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 120/255] arm64: kexec_file: try more regions if loading segments fails
Date:   Tue, 17 Nov 2020 14:04:20 +0100
Message-Id: <20201117122144.781176433@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gwin <bgwin@google.com>

[ Upstream commit 108aa503657ee2fe8aa071dc620d96372c252ecd ]

It's possible that the first region picked for the new kernel will make
it impossible to fit the other segments in the required 32GB window,
especially if we have a very large initrd.

Instead of giving up, we can keep testing other regions for the kernel
until we find one that works.

Suggested-by: Ryan O'Leary <ryanoleary@google.com>
Signed-off-by: Benjamin Gwin <bgwin@google.com>
Link: https://lore.kernel.org/r/20201103201106.2397844-1-bgwin@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/kexec_image.c        | 41 +++++++++++++++++++-------
 arch/arm64/kernel/machine_kexec_file.c |  9 +++++-
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
index af9987c154cab..66adee8b5fc81 100644
--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -43,7 +43,7 @@ static void *image_load(struct kimage *image,
 	u64 flags, value;
 	bool be_image, be_kernel;
 	struct kexec_buf kbuf;
-	unsigned long text_offset;
+	unsigned long text_offset, kernel_segment_number;
 	struct kexec_segment *kernel_segment;
 	int ret;
 
@@ -88,11 +88,37 @@ static void *image_load(struct kimage *image,
 	/* Adjust kernel segment with TEXT_OFFSET */
 	kbuf.memsz += text_offset;
 
-	ret = kexec_add_buffer(&kbuf);
-	if (ret)
+	kernel_segment_number = image->nr_segments;
+
+	/*
+	 * The location of the kernel segment may make it impossible to satisfy
+	 * the other segment requirements, so we try repeatedly to find a
+	 * location that will work.
+	 */
+	while ((ret = kexec_add_buffer(&kbuf)) == 0) {
+		/* Try to load additional data */
+		kernel_segment = &image->segment[kernel_segment_number];
+		ret = load_other_segments(image, kernel_segment->mem,
+					  kernel_segment->memsz, initrd,
+					  initrd_len, cmdline);
+		if (!ret)
+			break;
+
+		/*
+		 * We couldn't find space for the other segments; erase the
+		 * kernel segment and try the next available hole.
+		 */
+		image->nr_segments -= 1;
+		kbuf.buf_min = kernel_segment->mem + kernel_segment->memsz;
+		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
+	}
+
+	if (ret) {
+		pr_err("Could not find any suitable kernel location!");
 		return ERR_PTR(ret);
+	}
 
-	kernel_segment = &image->segment[image->nr_segments - 1];
+	kernel_segment = &image->segment[kernel_segment_number];
 	kernel_segment->mem += text_offset;
 	kernel_segment->memsz -= text_offset;
 	image->start = kernel_segment->mem;
@@ -101,12 +127,7 @@ static void *image_load(struct kimage *image,
 				kernel_segment->mem, kbuf.bufsz,
 				kernel_segment->memsz);
 
-	/* Load additional data */
-	ret = load_other_segments(image,
-				kernel_segment->mem, kernel_segment->memsz,
-				initrd, initrd_len, cmdline);
-
-	return ERR_PTR(ret);
+	return 0;
 }
 
 #ifdef CONFIG_KEXEC_IMAGE_VERIFY_SIG
diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 361a1143e09ee..e443df8569881 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -242,6 +242,11 @@ static int prepare_elf_headers(void **addr, unsigned long *sz)
 	return ret;
 }
 
+/*
+ * Tries to add the initrd and DTB to the image. If it is not possible to find
+ * valid locations, this function will undo changes to the image and return non
+ * zero.
+ */
 int load_other_segments(struct kimage *image,
 			unsigned long kernel_load_addr,
 			unsigned long kernel_size,
@@ -250,7 +255,8 @@ int load_other_segments(struct kimage *image,
 {
 	struct kexec_buf kbuf;
 	void *headers, *dtb = NULL;
-	unsigned long headers_sz, initrd_load_addr = 0, dtb_len;
+	unsigned long headers_sz, initrd_load_addr = 0, dtb_len,
+		      orig_segments = image->nr_segments;
 	int ret = 0;
 
 	kbuf.image = image;
@@ -336,6 +342,7 @@ int load_other_segments(struct kimage *image,
 	return 0;
 
 out_err:
+	image->nr_segments = orig_segments;
 	vfree(dtb);
 	return ret;
 }
-- 
2.27.0




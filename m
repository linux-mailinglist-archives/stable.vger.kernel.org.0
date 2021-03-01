Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF68328689
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhCARLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237019AbhCARGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:06:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F39265006;
        Mon,  1 Mar 2021 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616810;
        bh=mVXHPPGSoVJWCQHkgdeHFEyC1wUa0+k1TnjiwN4hG9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ia8zzCDFijebdNm0Vc/TqooKF/BhQG3vdz4Ul5KzB9tedrjzTLIbMQH/u3nXcOgrW
         5FD8bKHe9mX8yFnCFwnT3oIw3M4zkDAU16Lsz2QfEE0f93oSlFEwLGr/v6yEDG/11r
         lXcfdv7YtmOXGRrym/YEcnCWmGeAAgQXKFgtytjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/247] ima: Free IMA measurement buffer after kexec syscall
Date:   Mon,  1 Mar 2021 17:12:04 +0100
Message-Id: <20210301161036.762777874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

[ Upstream commit f31e3386a4e92ba6eda7328cb508462956c94c64 ]

IMA allocates kernel virtual memory to carry forward the measurement
list, from the current kernel to the next kernel on kexec system call,
in ima_add_kexec_buffer() function.  This buffer is not freed before
completing the kexec system call resulting in memory leak.

Add ima_buffer field in "struct kimage" to store the virtual address
of the buffer allocated for the IMA measurement list.
Free the memory allocated for the IMA measurement list in
kimage_file_post_load_cleanup() function.

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Suggested-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Fixes: 7b8589cc29e7 ("ima: on soft reboot, save the measurement list")
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kexec.h              | 5 +++++
 kernel/kexec_file.c                | 5 +++++
 security/integrity/ima/ima_kexec.c | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 9e4e638fb5051..fe9f6f2dd811d 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -260,6 +260,11 @@ struct kimage {
 	/* Information for loading purgatory */
 	struct purgatory_info purgatory_info;
 #endif
+
+#ifdef CONFIG_IMA_KEXEC
+	/* Virtual address of IMA measurement buffer for kexec syscall */
+	void *ima_buffer;
+#endif
 };
 
 /* kexec interface functions */
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index c6a3b6851372c..2fbdb78d66c80 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -168,6 +168,11 @@ void kimage_file_post_load_cleanup(struct kimage *image)
 	vfree(pi->sechdrs);
 	pi->sechdrs = NULL;
 
+#ifdef CONFIG_IMA_KEXEC
+	vfree(image->ima_buffer);
+	image->ima_buffer = NULL;
+#endif /* CONFIG_IMA_KEXEC */
+
 	/* See if architecture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
 
diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 9f8449dea5b69..6a10d4d8b6e1d 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -134,6 +134,8 @@ void ima_add_kexec_buffer(struct kimage *image)
 		return;
 	}
 
+	image->ima_buffer = kexec_buffer;
+
 	pr_debug("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
 		 kbuf.mem);
 }
-- 
2.27.0




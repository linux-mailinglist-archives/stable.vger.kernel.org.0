Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C223245C3C8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350722AbhKXNmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:42:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349057AbhKXNkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:40:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14A9D630ED;
        Wed, 24 Nov 2021 12:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758620;
        bh=/shuj1JJUYEOLCvHE5CF2Jks4GmenQynGZ8qEF6Oxjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohLUEBI6p41Q3vAE79tEtxQH/80ZkTXlWyPUdeJqu8v7XzBkOLqAkGnyJ7Jg2LDGe
         R4EbgGwn9H/lGJ+jQD7ELkJcXkDxkU3uDUNQTzyLPXGa513J0ZVoH7GpcYI3mJdwie
         RDJsNIgmmlQ0+54cDLii28Cd3u5qogDF5az/J7lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Philipp Rudo <prudo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 129/154] s390/kexec: fix memory leak of ipl report buffer
Date:   Wed, 24 Nov 2021 12:58:45 +0100
Message-Id: <20211124115706.469513675@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit 4aa9340584e37debef06fa99b56d064beb723891 upstream.

unreferenced object 0x38000195000 (size 4096):
  comm "kexec", pid 8548, jiffies 4294953647 (age 32443.270s)
  hex dump (first 32 bytes):
    00 00 00 c8 20 00 00 00 00 00 00 c0 02 80 00 00  .... ...........
    40 40 40 40 40 40 40 40 00 00 00 00 00 00 00 00  @@@@@@@@........
  backtrace:
    [<0000000011a2f199>] __vmalloc_node_range+0xc0/0x140
    [<0000000081fa2752>] vzalloc+0x5a/0x70
    [<0000000063a4c92d>] ipl_report_finish+0x2c/0x180
    [<00000000553304da>] kexec_file_add_ipl_report+0xf4/0x150
    [<00000000862d033f>] kexec_file_add_components+0x124/0x160
    [<000000000d2717bb>] arch_kexec_kernel_image_load+0x62/0x90
    [<000000002e0373b6>] kimage_file_alloc_init+0x1aa/0x2e0
    [<0000000060f2d14f>] __do_sys_kexec_file_load+0x17c/0x2c0
    [<000000008c86fe5a>] __s390x_sys_kexec_file_load+0x40/0x50
    [<000000001fdb9dac>] __do_syscall+0x1bc/0x1f0
    [<000000003ee4258d>] system_call+0x78/0xa0

Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Philipp Rudo <prudo@redhat.com>
Fixes: 99feaa717e55 ("s390/kexec_file: Create ipl report and pass to next kernel")
Cc: <stable@vger.kernel.org> # v5.2: 20c76e242e70: s390/kexec: fix return code handling
Cc: <stable@vger.kernel.org> # v5.2
Link: https://lore.kernel.org/r/20211116033101.GD21646@MiWiFi-R3L-srv
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/kexec.h         |    6 ++++++
 arch/s390/kernel/machine_kexec_file.c |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -74,6 +74,12 @@ void *kexec_file_add_components(struct k
 int arch_kexec_do_relocs(int r_type, void *loc, unsigned long val,
 			 unsigned long addr);
 
+#define ARCH_HAS_KIMAGE_ARCH
+
+struct kimage_arch {
+	void *ipl_buf;
+};
+
 extern const struct kexec_file_ops s390_kexec_image_ops;
 extern const struct kexec_file_ops s390_kexec_elf_ops;
 
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -12,6 +12,7 @@
 #include <linux/kexec.h>
 #include <linux/module_signature.h>
 #include <linux/verification.h>
+#include <linux/vmalloc.h>
 #include <asm/boot_data.h>
 #include <asm/ipl.h>
 #include <asm/setup.h>
@@ -206,6 +207,7 @@ static int kexec_file_add_ipl_report(str
 		goto out;
 	buf.bufsz = data->report->size;
 	buf.memsz = buf.bufsz;
+	image->arch.ipl_buf = buf.buffer;
 
 	data->memsz += buf.memsz;
 
@@ -327,3 +329,11 @@ int arch_kexec_kernel_image_probe(struct
 
 	return kexec_image_probe_default(image, buf, buf_len);
 }
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	vfree(image->arch.ipl_buf);
+	image->arch.ipl_buf = NULL;
+
+	return kexec_image_post_load_cleanup_default(image);
+}



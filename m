Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE1E14AB62
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 22:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgA0VAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 16:00:19 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:39110 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgA0VAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 16:00:19 -0500
Received: by mail-pg1-f201.google.com with SMTP id j187so2909606pge.6
        for <stable@vger.kernel.org>; Mon, 27 Jan 2020 13:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CAH2JUZfxl1gXiFoCO0/GCKYjJBCGBSmgeGFBkbRVI0=;
        b=vRafyqqdBsTOJgglJmYV5o0OlpyXwllJ3p28sfmm8WEusJw/8TTAuXROIItQFjhfru
         FoTeyhiVZvrzp0JIm8RXe97PvQkILEt6fOIfd5MLGgbRHwVUGQteeanpwnUNFpDbUmET
         yeUbkiANImftfw/XgIYW3iLbk9Ux/ghJ7Er+nvIxtGeyx3r4mpmfFWUtKxwkBLylRjuW
         jzAHdXNaxHvnNn+PhPXHv3feb90RvDruMJozvNa2ceu9wpj55ZA+suoil28EMWaYbUp1
         gY9llY8XBheRi/d3lSNUfkp4knvPXUGgFng3P5++sDeiWH/SxzYSdXyD/WICjNpLKhfy
         d9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CAH2JUZfxl1gXiFoCO0/GCKYjJBCGBSmgeGFBkbRVI0=;
        b=OCrvKEUl3BhfMrF/bFfqKZPT6QZICGi/uFIiOAsH++Ia91UzsfG3kxCakMAMOsibgd
         4T9QNsbu1wRxllE0ldihHb8U6EmTeb7mflvR6W2XILxurpj+mh3HllKVgPL/sUll2iIq
         pfVDNFhXjw0aaHKQnKHUjJmpyQNF7iLlYWGu2yMZ4lhI7OKLXDwvq/w8VHtt9v6t4OFD
         RDk1vw4v6XncjvzAy7m+//r09abduM8WTKnXfWqQQ686Q8LtNZgcO3139kbZy9ctZ4Cm
         G8s2lsCNXhjCCmMLPK1KzIkJkgTHwcqfyktTkhNqmnDjUIdKZAnWOzPp40UZBVZQEJ8Y
         BDzQ==
X-Gm-Message-State: APjAAAVM1bBu2c7AbTUYOlT8zocPxWyMsc7gJX7Wfntb67Q0u84k+Bxv
        W+tH7Jny2nwo7kFPuPMYemm0wO8DJQ==
X-Google-Smtp-Source: APXvYqxlVzkT24mENi5mvLCMmQUezkOaccKmD22akDDb2kZdKeiEAlnC02DJ2I9eq5Vhr5yinxSlLv5OQw==
X-Received: by 2002:a63:4503:: with SMTP id s3mr21629876pga.311.1580158818711;
 Mon, 27 Jan 2020 13:00:18 -0800 (PST)
Date:   Mon, 27 Jan 2020 13:00:14 -0800
Message-Id: <20200127210014.5207-1-tkjos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH] staging: android: ashmem: Disallow ashmem memory from being remapped
From:   Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, surenb@google.com, gregkh@linuxfoundation.org,
        arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, maco@google.com
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

When ashmem file is being mmapped the resulting vma->vm_file points to the
backing shmem file with the generic fops that do not check ashmem
permissions like fops of ashmem do. Fix that by disallowing mapping
operation for backing shmem file.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable <stable@vger.kernel.org> # 4.4,4.9,4.14,4.18,5.4
Signed-off-by: Todd Kjos <tkjos@google.com>
---
 drivers/staging/android/ashmem.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 74d497d39c5a..c6695354b123 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -351,8 +351,23 @@ static inline vm_flags_t calc_vm_may_flags(unsigned long prot)
 	       _calc_vm_trans(prot, PROT_EXEC,  VM_MAYEXEC);
 }
 
+static int ashmem_vmfile_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/* do not allow to mmap ashmem backing shmem file directly */
+	return -EPERM;
+}
+
+static unsigned long
+ashmem_vmfile_get_unmapped_area(struct file *file, unsigned long addr,
+				unsigned long len, unsigned long pgoff,
+				unsigned long flags)
+{
+	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+}
+
 static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	static struct file_operations vmfile_fops;
 	struct ashmem_area *asma = file->private_data;
 	int ret = 0;
 
@@ -393,6 +408,19 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 		}
 		vmfile->f_mode |= FMODE_LSEEK;
 		asma->file = vmfile;
+		/*
+		 * override mmap operation of the vmfile so that it can't be
+		 * remapped which would lead to creation of a new vma with no
+		 * asma permission checks. Have to override get_unmapped_area
+		 * as well to prevent VM_BUG_ON check for f_ops modification.
+		 */
+		if (!vmfile_fops.mmap) {
+			vmfile_fops = *vmfile->f_op;
+			vmfile_fops.mmap = ashmem_vmfile_mmap;
+			vmfile_fops.get_unmapped_area =
+					ashmem_vmfile_get_unmapped_area;
+		}
+		vmfile->f_op = &vmfile_fops;
 	}
 	get_file(asma->file);
 
-- 
2.25.0.341.g760bfbb309-goog


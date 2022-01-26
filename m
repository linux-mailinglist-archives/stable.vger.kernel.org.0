Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7784549C181
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 03:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbiAZC6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 21:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbiAZC55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 21:57:57 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7100C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:57:56 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c190-20020a1c9ac7000000b0035081bc722dso3054623wme.5
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I3RC1pvj5eN/eY23rSAiJ3humqZ0lwYSWOtpC61NHQI=;
        b=jNTeFwL67cZoQTfL3CTPUUXmJbZg+PHlJvFqPCm0VSiIy4Ozn/cx9HduX35l3iaCRd
         Zo+UDxBmr4tJC4w19s5OKN/VJxGN5IjAdBCs4+At9DRJ5GA+UZFeGElYc/4eGUeAizeX
         hZ1xjYN+Cf7Hb8VWADmJ3foDDldJgAtAWC1vn/drBnOWEdu7ev7wUoDWf2pYO2NDZRGa
         uBJg3mskxFEhifHLRnm494Lgux5MeV0i2UBE2cziBg2guvSj2CbmANfX5ZaVfCZtRmqG
         OXoVCnyOl72igibDQKEjwTgIh9bGwFkToE3bOPnznnNsxyeJJgcQYV19e4be+IYkAIo+
         OXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I3RC1pvj5eN/eY23rSAiJ3humqZ0lwYSWOtpC61NHQI=;
        b=4YACFIH6gZ5f+Su++xPkpSbR1Z7nCbgptCK9t4H+HPPF+ro53vqWcUis4KBfhooRFk
         KTVlW2mW1/T1IMKAO88Ptpo4b8FrcSC70qum2RlDLbqyl5kA+hSEbgjAsk+4uZ6Fmq9G
         YuzLPVYsyV3nWEVKO1IXEXimW6Us97DqNjGtKAFPrbYhxgkcdCBPL7iW6TPIULSkZgmo
         3icQ8BfXeaADjZ9IVpzWDl5tkDaMCN4WUlkBzCfb04M7VIq78yLnL6vN9gCmLZKbHOga
         X0j09jYAxQmrjCbW9a3LzDOBstqClN3U056mpCQyj5NHnk012eLmBCSQfJvrjSk8Oc9j
         qBIQ==
X-Gm-Message-State: AOAM532qVkSPKjcgsu7UHiW/16WJe/5N1SjSGCR5lTm5SGIfW0vhmm6T
        d59ksB1kbbAR6tJ9gQBzf4gGEg==
X-Google-Smtp-Source: ABdhPJykvD2mplP3Qu8rxt/N+hGR9ePoALUnM7FwAuu/hTLH32tIjiqmdpOqsVZu/PsqptkEj6gcXw==
X-Received: by 2002:a05:600c:4101:: with SMTP id j1mr5355624wmi.28.1643165875272;
        Tue, 25 Jan 2022 18:57:55 -0800 (PST)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id y2sm1797168wmj.13.2022.01.25.18.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 18:57:54 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Bill Messmer <wmessmer@microsoft.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: [PATCH] coredump: Also dump first pages of non-executable ELF libraries
Date:   Wed, 26 Jan 2022 03:57:39 +0100
Message-Id: <20220126025739.2014888-1-jannh@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When I rewrote the VMA dumping logic for coredumps, I changed it to
recognize ELF library mappings based on the file being executable instead
of the mapping having an ELF header. But turns out, distros ship many ELF
libraries as non-executable, so the heuristic goes wrong...

Restore the old behavior where FILTER(ELF_HEADERS) dumps the first page of
any offset-0 readable mapping that starts with the ELF magic.

This fix is technically layer-breaking a bit, because it checks for
something ELF-specific in fs/coredump.c; but since we probably want to
share this between standard ELF and FDPIC ELF anyway, I guess it's fine?
And this also keeps the change small for backporting.

Cc: stable@vger.kernel.org
Fixes: 429a22e776a2 ("coredump: rework elf/elf_fdpic vma_dump_size() into c=
ommon helper")
Reported-by: Bill Messmer <wmessmer@microsoft.com>
Signed-off-by: Jann Horn <jannh@google.com>
---

@Bill: If you happen to have a kernel tree lying around, you could give
this a try and report back whether this solves your issues?
But if not, it's also fine, I've tested myself that with this patch
applied, the first 0x1000 bytes of non-executable libraries are dumped
into the coredump according to "readelf".

 fs/coredump.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1c060c0a2d72..b73817712dd2 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -42,6 +42,7 @@
 #include <linux/path.h>
 #include <linux/timekeeping.h>
 #include <linux/sysctl.h>
+#include <linux/elf.h>
=20
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -980,6 +981,8 @@ static bool always_dump_vma(struct vm_area_struct *vma)
 	return false;
 }
=20
+#define DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER 1
+
 /*
  * Decide how much of @vma's contents should be included in a core dump.
  */
@@ -1039,9 +1042,20 @@ static unsigned long vma_dump_size(struct vm_area_st=
ruct *vma,
 	 * dump the first page to aid in determining what was mapped here.
 	 */
 	if (FILTER(ELF_HEADERS) &&
-	    vma->vm_pgoff =3D=3D 0 && (vma->vm_flags & VM_READ) &&
-	    (READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) !=3D 0)
-		return PAGE_SIZE;
+	    vma->vm_pgoff =3D=3D 0 && (vma->vm_flags & VM_READ)) {
+		if ((READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) !=3D 0)
+			return PAGE_SIZE;
+
+		/*
+		 * ELF libraries aren't always executable.
+		 * We'll want to check whether the mapping starts with the ELF
+		 * magic, but not now - we're holding the mmap lock,
+		 * so copy_from_user() doesn't work here.
+		 * Use a placeholder instead, and fix it up later in
+		 * dump_vma_snapshot().
+		 */
+		return DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER;
+	}
=20
 #undef	FILTER
=20
@@ -1116,8 +1130,6 @@ int dump_vma_snapshot(struct coredump_params *cprm, i=
nt *vma_count,
 		m->end =3D vma->vm_end;
 		m->flags =3D vma->vm_flags;
 		m->dump_size =3D vma_dump_size(vma, cprm->mm_flags);
-
-		vma_data_size +=3D m->dump_size;
 	}
=20
 	mmap_write_unlock(mm);
@@ -1127,6 +1139,23 @@ int dump_vma_snapshot(struct coredump_params *cprm, =
int *vma_count,
 		return -EFAULT;
 	}
=20
+	for (i =3D 0; i < *vma_count; i++) {
+		struct core_vma_metadata *m =3D (*vma_meta) + i;
+
+		if (m->dump_size =3D=3D DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER) {
+			char elfmag[SELFMAG];
+
+			if (copy_from_user(elfmag, (void __user *)m->start, SELFMAG) ||
+					memcmp(elfmag, ELFMAG, SELFMAG) !=3D 0) {
+				m->dump_size =3D 0;
+			} else {
+				m->dump_size =3D PAGE_SIZE;
+			}
+		}
+
+		vma_data_size +=3D m->dump_size;
+	}
+
 	*vma_data_size_ptr =3D vma_data_size;
 	return 0;
 }

base-commit: 0280e3c58f92b2fe0e8fbbdf8d386449168de4a8
--=20
2.35.0.rc0.227.g00780c9af4-goog


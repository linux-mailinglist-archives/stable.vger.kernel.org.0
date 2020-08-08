Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE09F23F879
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 20:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHHShf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 14:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgHHShe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 14:37:34 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FC9C061756;
        Sat,  8 Aug 2020 11:37:34 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so2679609pgh.3;
        Sat, 08 Aug 2020 11:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E2HEcTXnQvxfyOU/9ep7TLdb0ZWR8Mv/2sU679c6wow=;
        b=hreHI/4z4gnMY2MsrUHeUlwsPkiZWg5h72Fy63z5HJTURdX0b/EDfhyL+3V/iECZL0
         8EWb5a1vq2nZkIrjs6zbBVrKHymnm1f3YH9DSPB7jcWuXbgc1eABRjVRr6PulL5u32+Z
         XtKD9YNv4/h+bwVMbFCqtfavMWn5tMZwrYgKpBBjLPlR8Iv3tAAmo4I8W7io6rfZnpJG
         7z1FqihIxrtRPdvmHFnQPpXcvbFOE+KHk5nNmruZeHxP88/0eeTjpTPdT3L/0Q3coDUY
         er+FJi7aOvW2r/DKmWGhUCzMVGuv4Il/ApdihfubGbjPn6DyNKIjqVk2y4PDeFZ1VPlS
         LCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E2HEcTXnQvxfyOU/9ep7TLdb0ZWR8Mv/2sU679c6wow=;
        b=fzOpVstk4E1VDsrw/9ZeapkJ52j7IjBQwljEePdRN+3j+V30prIAifl2bWEQ1LooGm
         jSKisPTq7UfJ5Gf9tIS28Cr6m6Okr+NVINrhvmQNNaW1ssHmKMPe9lxOpxLF7r9fQ3CC
         lrkPIFQfQxdYwio+qpkxcWCLpPMPXwIBV7ijHnahtLRIM0A/izPfp6cuXfrrTnV0yIh6
         xypZC6k5QdrX7O1MW5zkOOX0I6EES4TTqQYfWwaGJPKjb5XDG4LQGtaqSF3HZPIpzyGK
         blVl+Nk0B8eB7iBgCS2nA8BelK0XKZ1OQsJ59zPBaZnUYmHgycuACD4KqATgX3oI5O+C
         Golg==
X-Gm-Message-State: AOAM533Io0VUPkh/zmvnPHva6LShCJYN9MU6pzDzSc7oZUL+LCWuLSUg
        9uU/xjsygEdIRj1wsLufeCgnHW1s
X-Google-Smtp-Source: ABdhPJz3FrHRgj5GwEumJjVbaMn5fGL88iRBUP3Q9C6cKXPRZ/gU+kCYqJLXbfdmfUDrLxLU24vqtQ==
X-Received: by 2002:a65:58c4:: with SMTP id e4mr15939810pgu.108.1596911853996;
        Sat, 08 Aug 2020 11:37:33 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:400:e00:19b7:f650:7bbe:a7fb])
        by smtp.gmail.com with ESMTPSA id q2sm17066767pff.107.2020.08.08.11.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 11:37:33 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] binfmt_flat: revert "binfmt_flat: don't offset the data start"
Date:   Sat,  8 Aug 2020 11:37:13 -0700
Message-Id: <20200808183713.12425-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

binfmt_flat loader uses the gap between text and data to store data
segment pointers for the libraries. Even in the absence of shared
libraries it stores at least one pointer to the executable's own data
segment. Text and data can go back to back in the flat binary image and
without offsetting data segment last few instructions in the text
segment may get corrupted by the data segment pointer.

Fix it by reverting commit a2357223c50a ("binfmt_flat: don't offset the
data start").

Cc: stable@vger.kernel.org
Fixes: a2357223c50a ("binfmt_flat: don't offset the data start")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 fs/binfmt_flat.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index f2f9086ebe98..b9c658e0548e 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -576,7 +576,7 @@ static int load_flat_file(struct linux_binprm *bprm,
 			goto err;
 		}
 
-		len = data_len + extra;
+		len = data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
 		len = PAGE_ALIGN(len);
 		realdatastart = vm_mmap(NULL, 0, len,
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
@@ -590,7 +590,9 @@ static int load_flat_file(struct linux_binprm *bprm,
 			vm_munmap(textpos, text_len);
 			goto err;
 		}
-		datapos = ALIGN(realdatastart, FLAT_DATA_ALIGN);
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(unsigned long),
+				FLAT_DATA_ALIGN);
 
 		pr_debug("Allocated data+bss+stack (%u bytes): %lx\n",
 			 data_len + bss_len + stack_len, datapos);
@@ -620,7 +622,7 @@ static int load_flat_file(struct linux_binprm *bprm,
 		memp_size = len;
 	} else {
 
-		len = text_len + data_len + extra;
+		len = text_len + data_len + extra + MAX_SHARED_LIBS * sizeof(u32);
 		len = PAGE_ALIGN(len);
 		textpos = vm_mmap(NULL, 0, len,
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
@@ -635,7 +637,9 @@ static int load_flat_file(struct linux_binprm *bprm,
 		}
 
 		realdatastart = textpos + ntohl(hdr->data_start);
-		datapos = ALIGN(realdatastart, FLAT_DATA_ALIGN);
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(u32),
+				FLAT_DATA_ALIGN);
 
 		reloc = (__be32 __user *)
 			(datapos + (ntohl(hdr->reloc_start) - text_len));
@@ -652,9 +656,8 @@ static int load_flat_file(struct linux_binprm *bprm,
 					 (text_len + full_data
 						  - sizeof(struct flat_hdr)),
 					 0);
-			if (datapos != realdatastart)
-				memmove((void *)datapos, (void *)realdatastart,
-						full_data);
+			memmove((void *) datapos, (void *) realdatastart,
+					full_data);
 #else
 			/*
 			 * This is used on MMU systems mainly for testing.
@@ -710,7 +713,8 @@ static int load_flat_file(struct linux_binprm *bprm,
 		if (IS_ERR_VALUE(result)) {
 			ret = result;
 			pr_err("Unable to read code+data+bss, errno %d\n", ret);
-			vm_munmap(textpos, text_len + data_len + extra);
+			vm_munmap(textpos, text_len + data_len + extra +
+				MAX_SHARED_LIBS * sizeof(u32));
 			goto err;
 		}
 	}
-- 
2.20.1


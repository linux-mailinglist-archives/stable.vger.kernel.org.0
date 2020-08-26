Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B50252DBD
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgHZMEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729583AbgHZMEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:04:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2AC02087C;
        Wed, 26 Aug 2020 12:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443440;
        bh=RLhBF8BrYcQu3ik2K38CBUQEniwHM8YmqxQC9DDM8B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSnBUDqmYs3eAxqaD2m5Y1FgNMEvCVGnjjerpPx6nuMd1jLwCsfKB+k3dE2W3dTwF
         n0hbe88JU7Bk2nU5iKOMfN/oDI8LgGXC1w35boEixkdb49CknmxXBf1RaXfZOQWoVG
         Vfm4aaEpsAjLVsI8l9/pttv/LWRqBX96qQuRPCV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Greg Ungerer <gerg@linux-m68k.org>
Subject: [PATCH 5.8 16/16] binfmt_flat: revert "binfmt_flat: dont offset the data start"
Date:   Wed, 26 Aug 2020 14:02:53 +0200
Message-Id: <20200826114912.015762856@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114911.216745274@linuxfoundation.org>
References: <20200826114911.216745274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 2217b982624680d19a80ebb4600d05c8586c4f96 upstream.

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
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/binfmt_flat.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -576,7 +576,7 @@ static int load_flat_file(struct linux_b
 			goto err;
 		}
 
-		len = data_len + extra;
+		len = data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
 		len = PAGE_ALIGN(len);
 		realdatastart = vm_mmap(NULL, 0, len,
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
@@ -590,7 +590,9 @@ static int load_flat_file(struct linux_b
 			vm_munmap(textpos, text_len);
 			goto err;
 		}
-		datapos = ALIGN(realdatastart, FLAT_DATA_ALIGN);
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(unsigned long),
+				FLAT_DATA_ALIGN);
 
 		pr_debug("Allocated data+bss+stack (%u bytes): %lx\n",
 			 data_len + bss_len + stack_len, datapos);
@@ -620,7 +622,7 @@ static int load_flat_file(struct linux_b
 		memp_size = len;
 	} else {
 
-		len = text_len + data_len + extra;
+		len = text_len + data_len + extra + MAX_SHARED_LIBS * sizeof(u32);
 		len = PAGE_ALIGN(len);
 		textpos = vm_mmap(NULL, 0, len,
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
@@ -635,7 +637,9 @@ static int load_flat_file(struct linux_b
 		}
 
 		realdatastart = textpos + ntohl(hdr->data_start);
-		datapos = ALIGN(realdatastart, FLAT_DATA_ALIGN);
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(u32),
+				FLAT_DATA_ALIGN);
 
 		reloc = (__be32 __user *)
 			(datapos + (ntohl(hdr->reloc_start) - text_len));
@@ -652,9 +656,8 @@ static int load_flat_file(struct linux_b
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
@@ -710,7 +713,8 @@ static int load_flat_file(struct linux_b
 		if (IS_ERR_VALUE(result)) {
 			ret = result;
 			pr_err("Unable to read code+data+bss, errno %d\n", ret);
-			vm_munmap(textpos, text_len + data_len + extra);
+			vm_munmap(textpos, text_len + data_len + extra +
+				MAX_SHARED_LIBS * sizeof(u32));
 			goto err;
 		}
 	}



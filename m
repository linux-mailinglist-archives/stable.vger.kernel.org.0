Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D944328FBE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbhCAT5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234733AbhCATof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ECC76510B;
        Mon,  1 Mar 2021 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618870;
        bh=xnB4jhQfrv/DG2lf8LK+Veia8APj8DVBYW29+Jt0+qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZKqcwWpuOd2oGm88M/zl3DMI4LbD+6ZnRSKr/t5WFP8akanaxd3Q0jEz3Z/lfetm
         zNQXvNmNm2PXPxghg7OiQTeWwyV2VFAL9+woz8nI0OHs4ckCysO/RKQ2z+o+Dcikij
         46zNjO9Ap9tvvIyRDH/EuLGGxhK3Zncm/w7FwzJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/663] ima: Free IMA measurement buffer after kexec syscall
Date:   Mon,  1 Mar 2021 17:08:15 +0100
Message-Id: <20210301161154.041224805@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 9e93bef529680..5f61389f5f361 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -300,6 +300,11 @@ struct kimage {
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
index e21f6b9234f7a..7825adcc5efc3 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -166,6 +166,11 @@ void kimage_file_post_load_cleanup(struct kimage *image)
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
index 206ddcaa5c67a..e29bea3dd4ccd 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -129,6 +129,8 @@ void ima_add_kexec_buffer(struct kimage *image)
 		return;
 	}
 
+	image->ima_buffer = kexec_buffer;
+
 	pr_debug("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
 		 kbuf.mem);
 }
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D2D444B93
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 00:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhKCXZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 19:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhKCXZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 19:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B27608FB;
        Wed,  3 Nov 2021 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635981772;
        bh=PW/WWDcyBTnfu0tXHgz//eODV+c6DYwOC/CHWkF43eQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qFr+cdGTuy0DUFnhdx4aAHMJrJAEkmdH5Lyod6yTIRWwtCoYRhioX1jTxa6gc5SPK
         NXmKrUWDm4/Yq7PW8G1svaxM60yJc/lZWx8yFlosacQSvVpPKkDoWq/Sh+/OW5LrgX
         TlXf7387E+BC/h2Sn0jWIs2vB8222nR5LOYzYfMPz6OMPBIF9cPFoQxFiIBTZTJ46A
         u9QU+iZ/GoT+60199T9691ZYtI8lxxmuxBGk1PcyuX1u1hUedRwKhokmvGSsaAIdkW
         KtlIvbkRr8BIaHvRK7pfpk8raxBtwHdEEF8yIy9HTBKS+zrW/pXCeByD7iQYGagpXH
         +z1QXWmCA1RrQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Free backing memory after faulting the enclave page
Date:   Thu,  4 Nov 2021 01:22:38 +0200
Message-Id: <20211103232238.110557-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The backing memory was not freed, after loading it back to the SGX
reserved memory. This problem was not prevalent with the systems that
were available at the time when SGX was first upstreamed, as the swapped
memory could grow only up to 128 MB.  However, Icelake Server can have
gigabytes of SGX memory, and thus this has become a real bottleneck.

Free the swap space for other use by calling shmem_truncate_range(),
when a page is faulted back.

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e3901c..f2d3f2e5028f 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -22,6 +22,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 {
 	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
 	struct sgx_encl *encl = encl_page->encl;
+	struct inode *inode = file_inode(encl->backing);
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
 	pgoff_t page_index;
@@ -60,6 +61,9 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	sgx_encl_put_backing(&b, false);
 
+	/* Free the backing memory. */
+	shmem_truncate_range(inode, PFN_PHYS(page_index), PFN_PHYS(page_index) + PAGE_SIZE - 1);
+
 	return ret;
 }
 
-- 
2.32.0


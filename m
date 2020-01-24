Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD60148140
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390644AbgAXLSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390415AbgAXLSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:25 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 681E920704;
        Fri, 24 Jan 2020 11:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864705;
        bh=9u8ZdeYALsrZG/D77ADyMIlfNISPQvEldg7rLQhyxXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWt+soH4gzqZJ2KUICL918OfR5prYowlAtcmTGTdsxbbbFM8oeVsP63LC/byHLqLK
         Hd7+K4WeL0fvlK07qDz8dGavCzTstjayLwF2hHT43VqeTGaU3FY2IVjnIROVp0Cr7e
         E+u/+nlh/55CF7fUeolUjLaJjy+Lgx2SdMbbOsOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 329/639] s390/kexec_file: Fix potential segment overlap in ELF loader
Date:   Fri, 24 Jan 2020 10:28:19 +0100
Message-Id: <20200124093128.326895193@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

[ Upstream commit 6339a3889ad4d0dd930ed7a1e873fb81d3e690f7 ]

When loading an ELF image via kexec_file the segment alignment is ignored
in the calculation for the load address of the next segment. When there are
multiple segments this can lead to segment overlap and thus load failure.

Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Fixes: 8be018827154 ("s390/kexec_file: Add ELF loader")
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/kexec_elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/kexec_elf.c b/arch/s390/kernel/kexec_elf.c
index 602e7cc26d118..5cf340b778f18 100644
--- a/arch/s390/kernel/kexec_elf.c
+++ b/arch/s390/kernel/kexec_elf.c
@@ -58,7 +58,7 @@ static int kexec_file_add_elf_kernel(struct kimage *image,
 		if (ret)
 			return ret;
 
-		data->memsz += buf.memsz;
+		data->memsz = ALIGN(data->memsz, phdr->p_align) + buf.memsz;
 	}
 
 	return 0;
-- 
2.20.1




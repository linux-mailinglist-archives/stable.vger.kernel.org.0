Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083CA13F5E9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391715AbgAPS7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388493AbgAPRGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E56A207FF;
        Thu, 16 Jan 2020 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194385;
        bh=63y6luguthzjydgpuxrNuDfTMIivEt0uMmMzMVa7/rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNHw5814U1TMfTLd0eLpOJLeW8SvipO0ieFNRbIhiOX+2yvlbuiPhpRB3IlX+mKWn
         9LdX/1MA8CRv0rl/tOUo+uV2P00ReVs2raVbZbgv+qPG7vkUxLmrDZck7f+PQ3Q+Ps
         TpyqiNsapsBMM4g0/J7V7ICSVtV2ywCCj06G7eGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Rudo <prudo@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 314/671] s390/kexec_file: Fix potential segment overlap in ELF loader
Date:   Thu, 16 Jan 2020 11:59:12 -0500
Message-Id: <20200116170509.12787-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 602e7cc26d11..5cf340b778f1 100644
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


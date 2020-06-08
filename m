Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D061F2FFA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgFIAzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgFHXJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C34BE20897;
        Mon,  8 Jun 2020 23:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657762;
        bh=0iFoIg7nV2CD2R+djatO1hodQJVSkJJ3Jzd7XRmEByk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvkJPWcz8Chv93fFOsvsqHwdIG9INMFslKzZxNlTm/Mr9ZP2eN13AoCFRPORr0OEK
         u5yYL/fQidpuRVK2lt3I+keORZldq6cgdPYrfpiSVuEBVWC7e03xqtlXwzNg959qOT
         Zi+BDEA9azIFKb/u8RMcB5no+K0Eq8Bxc04xk/Lk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        James Morse <james.morse@arm.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 147/274] arm64: kexec_file: print appropriate variable
Date:   Mon,  8 Jun 2020 19:04:00 -0400
Message-Id: <20200608230607.3361041-147-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

[ Upstream commit 51075e0cb759a736e60ab4f3a5fed8670dba5852 ]

The value of kbuf->memsz may be different than kbuf->bufsz after calling
kexec_add_buffer(). Hence both values should be logged.

Fixes: 52b2a8af74360 ("arm64: kexec_file: load initrd and device-tree")
Fixes: 3751e728cef29 ("arm64: kexec_file: add crash dump support")
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: James Morse <james.morse@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Link: https://lore.kernel.org/r/20200430163142.27282-2-l.stelmach@samsung.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec_file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index b40c3b0def92..5ebb21b859b4 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -284,7 +284,7 @@ int load_other_segments(struct kimage *image,
 		image->arch.elf_headers_sz = headers_sz;
 
 		pr_debug("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			 image->arch.elf_headers_mem, headers_sz, headers_sz);
+			 image->arch.elf_headers_mem, kbuf.bufsz, kbuf.memsz);
 	}
 
 	/* load initrd */
@@ -305,7 +305,7 @@ int load_other_segments(struct kimage *image,
 		initrd_load_addr = kbuf.mem;
 
 		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-				initrd_load_addr, initrd_len, initrd_len);
+				initrd_load_addr, kbuf.bufsz, kbuf.memsz);
 	}
 
 	/* load dtb */
@@ -332,7 +332,7 @@ int load_other_segments(struct kimage *image,
 	image->arch.dtb_mem = kbuf.mem;
 
 	pr_debug("Loaded dtb at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			kbuf.mem, dtb_len, dtb_len);
+			kbuf.mem, kbuf.bufsz, kbuf.memsz);
 
 	return 0;
 
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929C8383537
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243134AbhEQPQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243346AbhEQPNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82DEB61C44;
        Mon, 17 May 2021 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261908;
        bh=yb2t9n9d73ncxUe8UzTCxpoOQfoZZe3tejDhEVDgH2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEv88AyWKmUYph6q/SI/NTBspQ6hdOV1evqll3iIbQTHDLHquzhGk9SuM3ZnxTpg0
         YIX8NHxUfzOjvSwmIwcR8KiBYutraq/ZWe5HxnOj4uNvj6tYH2XjPWOF/AnjZ2Rp0L
         4lFSbOcEOLvY92I0cHvLWIqtsywNxlYYxfkndTYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 185/329] RISC-V: Fix error code returned by riscv_hartid_to_cpuid()
Date:   Mon, 17 May 2021 16:01:36 +0200
Message-Id: <20210517140308.389910521@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <anup.patel@wdc.com>

[ Upstream commit 533b4f3a789d49574e7ae0f6ececed153f651f97 ]

We should return a negative error code upon failure in
riscv_hartid_to_cpuid() instead of NR_CPUS. This is also
aligned with all uses of riscv_hartid_to_cpuid() which
expect negative error code upon failure.

Fixes: 6825c7a80f18 ("RISC-V: Add logical CPU indexing for RISC-V")
Fixes: f99fb607fb2b ("RISC-V: Use Linux logical CPU number instead of hartid")
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index ea028d9e0d24..d44567490d91 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -54,7 +54,7 @@ int riscv_hartid_to_cpuid(int hartid)
 			return i;
 
 	pr_err("Couldn't find cpu id for hartid [%d]\n", hartid);
-	return i;
+	return -ENOENT;
 }
 
 void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out)
-- 
2.30.2




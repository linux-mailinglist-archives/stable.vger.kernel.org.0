Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE4654972B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383887AbiFMO1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383972AbiFMOYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57FD47573;
        Mon, 13 Jun 2022 04:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64724B80EB2;
        Mon, 13 Jun 2022 11:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44CBC34114;
        Mon, 13 Jun 2022 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120769;
        bh=orI7NLzyYAo4r79BAJZsq8oCnJd/A00pdqYpG0bPBhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAgRqBsOS4E51GtWDGC7fcJdZFqUJru3SIONZppa/Ww+O6HBuPOrBgqMH09Wx3bNg
         oSivHaiya3f9fvzwhNJO3NM5d+GwKMct9Va43L7J0PJzyCwxbTJa9wa76Fj2qejyLE
         xVvhHTlj8p9uF30Dr8HtpRtSN2slfaTtdNUNX+eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liao Chang <liaochang1@huawei.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 151/298] RISC-V: use memcpy for kexec_file mode
Date:   Mon, 13 Jun 2022 12:10:45 +0200
Message-Id: <20220613094929.517599059@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit b7fb4d78a6ade6026d9e5cf438c2a46ab962e032 ]

The pointer to buffer loading kernel binaries is in kernel space for
kexec_fil mode, When copy_from_user copies data from pointer to a block
of memory, it checkes that the pointer is in the user space range, on
RISCV-V that is:

static inline bool __access_ok(unsigned long addr, unsigned long size)
{
	return size <= TASK_SIZE && addr <= TASK_SIZE - size;
}

and TASK_SIZE is 0x4000000000 for 64-bits, which now causes
copy_from_user to reject the access of the field 'buf' of struct
kexec_segment that is in range [CONFIG_PAGE_OFFSET - VMALLOC_SIZE,
CONFIG_PAGE_OFFSET), is invalid user space pointer.

This patch fixes this issue by skipping access_ok(), use mempcy() instead.

Signed-off-by: Liao Chang <liaochang1@huawei.com>
Link: https://lore.kernel.org/r/20220408100914.150110-3-lizhengyu3@huawei.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/machine_kexec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index cbef0fc73afa..df8e24559035 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -65,7 +65,9 @@ machine_kexec_prepare(struct kimage *image)
 		if (image->segment[i].memsz <= sizeof(fdt))
 			continue;
 
-		if (copy_from_user(&fdt, image->segment[i].buf, sizeof(fdt)))
+		if (image->file_mode)
+			memcpy(&fdt, image->segment[i].buf, sizeof(fdt));
+		else if (copy_from_user(&fdt, image->segment[i].buf, sizeof(fdt)))
 			continue;
 
 		if (fdt_check_header(&fdt))
-- 
2.35.1




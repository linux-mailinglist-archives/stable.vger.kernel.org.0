Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA98F99B8A
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391867AbfHVRZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391863AbfHVRZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:34 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E7D2064A;
        Thu, 22 Aug 2019 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494733;
        bh=fhxerGabZfXb3FnqDlDzXd1dKIMry2EkxBDyGiHtxIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN18KC+5pIy1tK6yh3tuBMpeZgJKehj7JV+FEab1LtILZ2SGidTf19KQho0X5irSG
         BeTsPwaXL2FeS7iEVeMjtlQl3emOQfjOkMwYtTndpc9ePkF1tPFH7RdSK6F4moh3VY
         M9VDSD+Qxz8pXPeH2N7rWks+UZ9c7gBdk0BgA14M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH 4.19 25/85] riscv: Make __fstate_clean() work correctly.
Date:   Thu, 22 Aug 2019 10:18:58 -0700
Message-Id: <20190822171732.250431221@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

commit 69703eb9a8ae28a46cd5bce7d69ceeef6273a104 upstream.

Make the __fstate_clean() function correctly set the
state of sstatus.FS in pt_regs to SR_FS_CLEAN.

Fixes: 7db91e57a0acd ("RISC-V: Task implementation")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[paul.walmsley@sifive.com: expanded "Fixes" commit ID]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/include/asm/switch_to.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -23,7 +23,7 @@ extern void __fstate_restore(struct task
 
 static inline void __fstate_clean(struct pt_regs *regs)
 {
-	regs->sstatus |= (regs->sstatus & ~(SR_FS)) | SR_FS_CLEAN;
+	regs->sstatus = (regs->sstatus & ~SR_FS) | SR_FS_CLEAN;
 }
 
 static inline void fstate_save(struct task_struct *task,



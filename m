Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58888CE51
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfHNIYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 04:24:05 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38848 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfHNIYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 04:24:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id o70so7806800pfg.5
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 01:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LKUTmfxWju3JH0UYdXaX0ZmxM1v34X/CQR0cjWXAdV0=;
        b=aprA4MX8fFP42+7Kfj2VmM2auYXDJcnW8YzO6vnSgXZD4MuPEx8PnT719qHFqIr/8n
         QmbZ0QuY/hdaPVLq5Qw9zGc+lgBmz54nZxOVLVk/a6ciHKcZKGRIPSumxAOoQa+lFXMg
         Z4uMvEByYuk/s/C8PNQittEjIb+K5+DyAfQ6cEBZ/zDoQd5MGztJ4aOzq10agMJA7UiN
         FDqQTgG0lMxnF4XDCJNHNKvx7sAok8gbO5bys2VzvMgT+AmDci9oOg+AHhe05JKeg2zn
         0209fn6vu9pR/FoCbx1lMxKN4l+zwrkJSq8FNq7tY10dmn+tm2v/q4XkIMFQCz5Jcn91
         Xm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LKUTmfxWju3JH0UYdXaX0ZmxM1v34X/CQR0cjWXAdV0=;
        b=fq4oxB9GoxufSqO2eVuiNjBVtltqgovs6ppfl+NbNCI6l3sZdqRl1jiIla8ohJZ/Wz
         YelUBAkG09vMcj4Zo/43/R+k13nLNpov+rXWRlGSJ0/HHPc4nS8fhSx+xzMPKrlktkiF
         N+WOejnOyNrBJSHJI/Eu/nKI/Fo4enaavrkW/cnPFt6I5YoeQvC6++H3Eo3FQoDGQ0YX
         qfj/SGUpeGjEtHziy1cmvYthBFILm/tSkPlTd/XYFYAf6ZWX8uV9NYCNHnEs5A43BdPv
         K2HZmcU/P+xTZhHYWZw+/eC0lrsNsGl7GOvjE8sWle4mfsNot9e6PTfbSGGO6jR5dHQg
         6rbw==
X-Gm-Message-State: APjAAAUL/gK1DASRA9r8siAr1+QVYtIhJeGj6Ev2T1WXF1KsOOI0t2y+
        WztrYgHaFqN6kGxfMtgeqbI87zxNhxE=
X-Google-Smtp-Source: APXvYqyF7XbbwdZczu0+BTGt6EYKJY4ia695LRy4XRq7P8Im2pJg5qZNWSLmNfYr09pro/ZO5lhd3A==
X-Received: by 2002:a17:90a:ad86:: with SMTP id s6mr4822761pjq.42.1565771040942;
        Wed, 14 Aug 2019 01:24:00 -0700 (PDT)
Received: from localhost.localdomain (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id f205sm12359152pfa.161.2019.08.14.01.23.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 01:24:00 -0700 (PDT)
From:   Vincent Chen <vincent.chen@sifive.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vincent Chen <vincent.chen@sifive.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] riscv: Make __fstate_clean() work correctly.
Date:   Wed, 14 Aug 2019 16:23:53 +0800
Message-Id: <1565771033-1831-3-git-send-email-vincent.chen@sifive.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565771033-1831-1-git-send-email-vincent.chen@sifive.com>
References: <1565771033-1831-1-git-send-email-vincent.chen@sifive.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make the __fstate_clean() function correctly set the
state of sstatus.FS in pt_regs to SR_FS_CLEAN.

Fixes: 7db91e5 ("RISC-V: Task implementation")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
 arch/riscv/include/asm/switch_to.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 0575b8a..0aa5b94 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -16,7 +16,7 @@ extern void __fstate_restore(struct task_struct *restore_from);
 
 static inline void __fstate_clean(struct pt_regs *regs)
 {
-	regs->sstatus |= (regs->sstatus & ~(SR_FS)) | SR_FS_CLEAN;
+	regs->sstatus = (regs->sstatus & ~SR_FS) | SR_FS_CLEAN;
 }
 
 static inline void fstate_off(struct task_struct *task,
-- 
2.7.4


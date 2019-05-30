Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B089F2F5AD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfE3DLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbfE3DLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:13 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A1C24476;
        Thu, 30 May 2019 03:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185872;
        bh=1/jtWjLwtQUBaIeNDr26UgU8Xxb0ANdHzNd+W3F8NtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9qYCRpTbQziYRCVA+bpiMplT8SG7taDQgA5wPJri3HzOnh1TQVFHOFAwwwQ9MsT1
         mF/PBCRZHUIdRWMq2Fj05U58pIyFsYMBrzwXsZkJsylIXnwllH0DgkfpP3YW/QyQDT
         r/Lrd3UxnmliXWLAJg57SqC348TSxBmYbMiBUbRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jann Horn <jannh@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 216/405] x86/microcode: Fix the ancient deprecated microcode loading method
Date:   Wed, 29 May 2019 20:03:34 -0700
Message-Id: <20190530030552.020366038@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 24613a04ad1c0588c10f4b5403ca60a73d164051 ]

Commit

  2613f36ed965 ("x86/microcode: Attempt late loading only when new microcode is present")

added the new define UCODE_NEW to denote that an update should happen
only when newer microcode (than installed on the system) has been found.

But it missed adjusting that for the old /dev/cpu/microcode loading
interface. Fix it.

Fixes: 2613f36ed965 ("x86/microcode: Attempt late loading only when new microcode is present")
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jann Horn <jannh@google.com>
Link: https://lkml.kernel.org/r/20190405133010.24249-3-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 5260185cbf7ba..8a4a7823451ac 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -418,8 +418,9 @@ static int do_microcode_update(const void __user *buf, size_t size)
 		if (ustate == UCODE_ERROR) {
 			error = -1;
 			break;
-		} else if (ustate == UCODE_OK)
+		} else if (ustate == UCODE_NEW) {
 			apply_microcode_on_target(cpu);
+		}
 	}
 
 	return error;
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6A3A72F
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbfFIQrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730735AbfFIQrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70F42081C;
        Sun,  9 Jun 2019 16:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098827;
        bh=Nggsw0KzbLBQhB1nqN+J0wSd06FmF8uIhVN1dpIoAP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6GMxDfIBdLkoPjro0icDS69hJGICT096QJ9gRl00SibbMqJEM8tka4iQW3z4Yspl
         ipGkyi7dks877C9BnKeJJCLOiE2144jleoPvxDkuIQPLx1p+xVFSLmM0YNa8NStjix
         i5Pdd3UeEo8sT9JWg/3zhGTz+Hrfvjtsw+GfqR+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 5.1 42/70] s390/mm: fix address space detection in exception handling
Date:   Sun,  9 Jun 2019 18:41:53 +0200
Message-Id: <20190609164130.814053228@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 962f0af83c239c0aef05639631e871c874b00f99 upstream.

Commit 0aaba41b58bc ("s390: remove all code using the access register
mode") removed access register mode from the kernel, and also from the
address space detection logic. However, user space could still switch
to access register mode (trans_exc_code == 1), and exceptions in that
mode would not be correctly assigned.

Fix this by adding a check for trans_exc_code == 1 to get_fault_type(),
and remove the wrong comment line before that function.

Fixes: 0aaba41b58bc ("s390: remove all code using the access register mode")
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@vger.kernel.org> # v4.15+
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/fault.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -83,7 +83,6 @@ static inline int notify_page_fault(stru
 
 /*
  * Find out which address space caused the exception.
- * Access register mode is impossible, ignore space == 3.
  */
 static inline enum fault_type get_fault_type(struct pt_regs *regs)
 {
@@ -108,6 +107,10 @@ static inline enum fault_type get_fault_
 		}
 		return VDSO_FAULT;
 	}
+	if (trans_exc_code == 1) {
+		/* access register mode, not used in the kernel */
+		return USER_FAULT;
+	}
 	/* home space exception -> access via kernel ASCE */
 	return KERNEL_FAULT;
 }



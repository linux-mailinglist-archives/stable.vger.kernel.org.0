Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932C181B2A
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfHENM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730317AbfHENKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:10:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC5E7216F4;
        Mon,  5 Aug 2019 13:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010621;
        bh=/0xk2gHnCvIfVuMEUs3c7iLXShhDkwFJ79DbXu5ckCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTMcYuFePiog14R60Qrbj5eMBcUEl2Ucq+7/hXqQsNFulZYsu2ls1KxvfBAGpigm9
         1pCSWhRY9uC8uC6sISctaGm2Wygsxndbu9XvGq4F+/C9h9d7fcv7TUV17i5zoZz0U4
         uYYyYrOjsZenWFls378EiVIvueLdk1Za4SN/YuMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/74] x86, boot: Remove multiple copy of static function sanitize_boot_params()
Date:   Mon,  5 Aug 2019 15:02:53 +0200
Message-Id: <20190805124939.100786922@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8c5477e8046ca139bac250386c08453da37ec1ae ]

Kernel build warns:
 'sanitize_boot_params' defined but not used [-Wunused-function]

at below files:
  arch/x86/boot/compressed/cmdline.c
  arch/x86/boot/compressed/error.c
  arch/x86/boot/compressed/early_serial_console.c
  arch/x86/boot/compressed/acpi.c

That's becausethey each include misc.h which includes a definition of
sanitize_boot_params() via bootparam_utils.h.

Remove the inclusion from misc.h and have the c file including
bootparam_utils.h directly.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/1563283092-1189-1-git-send-email-zhenzhong.duan@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/misc.c | 1 +
 arch/x86/boot/compressed/misc.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8dd1d5ccae580..0387d7a96c842 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -17,6 +17,7 @@
 #include "pgtable.h"
 #include "../string.h"
 #include "../voffset.h"
+#include <asm/bootparam_utils.h>
 
 /*
  * WARNING!!
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index a423bdb426862..47fd18db6b3bf 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -22,7 +22,6 @@
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
-#include <asm/bootparam_utils.h>
 
 #define BOOT_BOOT_H
 #include "../ctype.h"
-- 
2.20.1




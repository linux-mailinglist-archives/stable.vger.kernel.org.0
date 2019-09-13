Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F24CB1E50
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbfIMNI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388354AbfIMNI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:08:56 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D87F208C2;
        Fri, 13 Sep 2019 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380136;
        bh=18tAscth9FF9plE93REuaZYkwT31wbrMuT8sabAMCe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1YX3lB1coAOlgUYIV2UxZ0QLkIib8sNd8IQAX6COMQb4DKKMCr3LmMNZSFebk/61
         w3iFMljXtOlXJBNA7KemifQ755mU8Ihgau9tnSAZOAcR4dj49ngtQjW+yl4KKKNbFE
         6yASltB8315kiyOq4Yb3Is5tSmHu52soWuJcfVqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.4 7/9] x86, boot: Remove multiple copy of static function sanitize_boot_params()
Date:   Fri, 13 Sep 2019 14:06:57 +0100
Message-Id: <20190913130430.474572665@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130424.160808669@linuxfoundation.org>
References: <20190913130424.160808669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 8c5477e8046ca139bac250386c08453da37ec1ae upstream.

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
[nc: Fixed conflict around lack of 67b6662559f7f]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/misc.c |    1 +
 arch/x86/boot/compressed/misc.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -11,6 +11,7 @@
 
 #include "misc.h"
 #include "../string.h"
+#include <asm/bootparam_utils.h>
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -19,7 +19,6 @@
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
-#include <asm/bootparam_utils.h>
 
 #define BOOT_BOOT_H
 #include "../ctype.h"



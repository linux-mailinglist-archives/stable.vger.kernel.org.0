Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A8B12B9B6
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfL0SCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727510AbfL0SCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:02:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 512F0222C4;
        Fri, 27 Dec 2019 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469755;
        bh=lNUYq7bp5wkI5mc/7OLg2R0gWlSNmXm1kqXk6M4f69k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B32APcw5uku0IzPoAkEef4riZ48RmuwqhyYKRM3VVfoNTsnpey9/E9vC/mdCf9JAU
         TqZjG4M8ZiSMsgdaFnz5Sv6YxX//tJsczEuQirnI2r9xmKqIEzV/16RVnoyMqK1DIG
         9B3QaL5wdJCJEFbVvaKsGLnaKr+zGYhedG6xP6/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 09/57] efi/gop: Return EFI_SUCCESS if a usable GOP was found
Date:   Fri, 27 Dec 2019 13:01:34 -0500
Message-Id: <20191227180222.7076-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit dbd89c303b4420f6cdb689fd398349fc83b059dd ]

If we've found a usable instance of the Graphics Output Protocol
(GOP) with a framebuffer, it is possible that one of the later EFI
calls fails while checking if any support console output. In this
case status may be an EFI error code even though we found a usable
GOP.

Fix this by explicitly return EFI_SUCCESS if a usable GOP has been
located.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191206165542.31469-4-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/gop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 16ed61c023e8..81ffda5d1e48 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -200,7 +200,7 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
 
-	return status;
+	return EFI_SUCCESS;
 }
 
 static efi_status_t
@@ -318,7 +318,7 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
 
-	return status;
+	return EFI_SUCCESS;
 }
 
 /*
-- 
2.20.1


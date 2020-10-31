Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328DD2A16DB
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgJaLlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgJaLlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF2920791;
        Sat, 31 Oct 2020 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144461;
        bh=VV/tAmNQ4bx5LSG6mS5ASZFVS/ylzdW2u5eTRa9Y5io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjyZTqOzN81S2jjJEDGKX9cw7qMhGRScnVDZc0KmjlIUScUPBe9ydNV/ySNGkIHtN
         jeacwXjf1CpHJU1/LCCdIE3ID73s5E3a6DmokbYb948eKK5TLx65t52t2oBmx5D2k/
         z4vUYYsmIi1L5zRWDoyRZuVfBk5GuJpvTIkEhJso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH 5.8 19/70] fs/kernel_read_file: Remove FIRMWARE_EFI_EMBEDDED enum
Date:   Sat, 31 Oct 2020 12:35:51 +0100
Message-Id: <20201031113500.430407586@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 06e67b849ab910a49a629445f43edb074153d0eb upstream.

The "FIRMWARE_EFI_EMBEDDED" enum is a "where", not a "what". It
should not be distinguished separately from just "FIRMWARE", as this
confuses the LSMs about what is being loaded. Additionally, there was
no actual validation of the firmware contents happening.

Fixes: e4c2c0ff00ec ("firmware: Add new platform fallback mechanism and firmware_request_platform()")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Scott Branden <scott.branden@broadcom.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201002173828.2099543-3-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/fallback_platform.c |    2 +-
 include/linux/fs.h                               |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/base/firmware_loader/fallback_platform.c
+++ b/drivers/base/firmware_loader/fallback_platform.c
@@ -17,7 +17,7 @@ int firmware_fallback_platform(struct fw
 	if (!(opt_flags & FW_OPT_FALLBACK_PLATFORM))
 		return -ENOENT;
 
-	rc = security_kernel_load_data(LOADING_FIRMWARE_EFI_EMBEDDED);
+	rc = security_kernel_load_data(LOADING_FIRMWARE);
 	if (rc)
 		return rc;
 
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3011,7 +3011,6 @@ extern int do_pipe_flags(int *, int);
 	id(UNKNOWN, unknown)		\
 	id(FIRMWARE, firmware)		\
 	id(FIRMWARE_PREALLOC_BUFFER, firmware)	\
-	id(FIRMWARE_EFI_EMBEDDED, firmware)	\
 	id(MODULE, kernel-module)		\
 	id(KEXEC_IMAGE, kexec-image)		\
 	id(KEXEC_INITRAMFS, kexec-initramfs)	\



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49EA9E096
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbfH0IFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732786AbfH0IF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22F822CED;
        Tue, 27 Aug 2019 08:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893125;
        bh=ebZgYB6R0/vyzOKHPC4jX6y5EBXSalTY8oBL7udNUd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0c9Uh15dDZhMw6neI9kL+P2y/kSa5UxcgSpZvqKVMnZ/L55buw1VH0KwPCFSRawOc
         ULKzs4KshSYPiINMJeEdNPOVaqAqjo0UD3deiSGbC6LXaLno/Uyb1F/ToqMVhMmeSP
         xZ/y4A3o4qfuRIduv53QJTJuzc7JrcSP9qx0HUl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil MacLeod <neil@nmacleod.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 5.2 129/162] x86/boot: Fix boot regression caused by bootparam sanitizing
Date:   Tue, 27 Aug 2019 09:50:57 +0200
Message-Id: <20190827072743.013028143@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

commit 7846f58fba964af7cb8cf77d4d13c33254725211 upstream.

commit a90118c445cc ("x86/boot: Save fields explicitly, zero out everything
else") had two errors:

    * It preserved boot_params.acpi_rsdp_addr, and
    * It failed to preserve boot_params.hdr

Therefore, zero out acpi_rsdp_addr, and preserve hdr.

Fixes: a90118c445cc ("x86/boot: Save fields explicitly, zero out everything else")
Reported-by: Neil MacLeod <neil@nmacleod.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neil MacLeod <neil@nmacleod.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190821192513.20126-1-jhubbard@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/bootparam_utils.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -59,7 +59,6 @@ static void sanitize_boot_params(struct
 			BOOT_PARAM_PRESERVE(apm_bios_info),
 			BOOT_PARAM_PRESERVE(tboot_addr),
 			BOOT_PARAM_PRESERVE(ist_info),
-			BOOT_PARAM_PRESERVE(acpi_rsdp_addr),
 			BOOT_PARAM_PRESERVE(hd0_info),
 			BOOT_PARAM_PRESERVE(hd1_info),
 			BOOT_PARAM_PRESERVE(sys_desc_table),
@@ -71,6 +70,7 @@ static void sanitize_boot_params(struct
 			BOOT_PARAM_PRESERVE(eddbuf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
+			BOOT_PARAM_PRESERVE(hdr),
 			BOOT_PARAM_PRESERVE(e820_table),
 			BOOT_PARAM_PRESERVE(eddbuf),
 		};



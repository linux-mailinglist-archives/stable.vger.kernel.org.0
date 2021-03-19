Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D07A341E3A
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 14:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhCSN3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 09:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhCSN3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 09:29:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE79C061760;
        Fri, 19 Mar 2021 06:29:11 -0700 (PDT)
Date:   Fri, 19 Mar 2021 13:29:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616160550;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=T2Etk9/6pxYPV9+0mqaTWRaKTYLDsWYbpKisiaXPbD4=;
        b=BVFBjiy+v/h3blktLsLKPPyy7htycAzeMqtzEUFgDAbmssihe0MIHnABss2obtD01yUQ6O
        xTudMi+cIHRmlTYyko1lb5MDJtKnBwXG83dF4q22q+TjB6hXp/ASgW8sMGBMhtBEh90e70
        RT+Hl+Oud34dKEYOTX+3Q93vlepLWGQCQ8appDHMdGy/GUNEIzd9QqY1EXEfUXK7Hv/PMT
        vNAItwgwdNkSOyJRrTk26QqD5GQLGNMuhX6DpAbErlxnI97U+8CMgRkJF8GJddhPO1vuxH
        742bBmFx/zHKorXnK3pItwjKslUojro1VygOHvlpNrh/3jKWOCnCkp/mp440QQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616160550;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=T2Etk9/6pxYPV9+0mqaTWRaKTYLDsWYbpKisiaXPbD4=;
        b=CftzSy+5ViyUco3whQxhlLsLFnQ1Yh4SRSiQmZ/nadIVeaE7abrogdxoAnGdDyj88qs3R4
        se0XI8VnLF2eHbBQ==
From:   "tip-bot2 for Shawn Guo" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efivars: respect EFI_UNSUPPORTED return from firmware
Cc:     <stable@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161616054960.398.616542925097476806.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     483028edacab374060d93955382b4865a9e07cba
Gitweb:        https://git.kernel.org/tip/483028edacab374060d93955382b4865a9e07cba
Author:        Shawn Guo <shawn.guo@linaro.org>
AuthorDate:    Wed, 17 Mar 2021 14:36:06 +08:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Wed, 17 Mar 2021 09:40:24 +01:00

efivars: respect EFI_UNSUPPORTED return from firmware

As per UEFI spec 2.8B section 8.2, EFI_UNSUPPORTED may be returned by
EFI variable runtime services if no variable storage is supported by
firmware.  In this case, there is no point for kernel to continue
efivars initialization.  That said, efivar_init() should fail by
returning an error code, so that efivarfs will not be mounted on
/sys/firmware/efi/efivars at all.  Otherwise, user space like efibootmgr
will be confused by the EFIVARFS_MAGIC seen there, while EFI variable
calls cannot be made successfully.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/vars.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 41c1d00..abdc8a6 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -485,6 +485,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			}
 
 			break;
+		case EFI_UNSUPPORTED:
+			err = -EOPNOTSUPP;
+			status = EFI_NOT_FOUND;
+			break;
 		case EFI_NOT_FOUND:
 			break;
 		default:

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A5C3442CC
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhCVMpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232702AbhCVMnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:43:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC90619A8;
        Mon, 22 Mar 2021 12:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416877;
        bh=ft9Lb4MR6Vk8OXPD4zVw5IuZdRbUn+8SmoXMMeTeq2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP/oBMA0a7aVRaTmXbCRhWEwY+GbV68ZnL+palEFQm63TdTHnR1EFTDBHJAEFekdx
         e+Ivl9p6anN/jLP1smONp6WFLUNkdU5ljTO4fM9wqQn282CPaGueS8flwltc7FnhVQ
         pLZ08WSvehYs2KLHU4XqLbJDAYzVGqCLUNuDZBDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 144/157] efivars: respect EFI_UNSUPPORTED return from firmware
Date:   Mon, 22 Mar 2021 13:28:21 +0100
Message-Id: <20210322121938.315527706@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

commit 483028edacab374060d93955382b4865a9e07cba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/vars.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -485,6 +485,10 @@ int efivar_init(int (*func)(efi_char16_t
 			}
 
 			break;
+		case EFI_UNSUPPORTED:
+			err = -EOPNOTSUPP;
+			status = EFI_NOT_FOUND;
+			break;
 		case EFI_NOT_FOUND:
 			break;
 		default:



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4509266C481
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjAPPz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjAPPzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3AA234D5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAF6D61037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BF0C433D2;
        Mon, 16 Jan 2023 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884524;
        bh=6tsBmFtam1/tY3esMmayO7fRCaEfHUxqGVnxy6B+b34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5xbzJ2kQHIgIKrXhbPYim8I/VEq89xn9RiGzEF7bX87yzrRcwdt0/HDnb/6lsmbM
         E869l2fLJWpwLeeFmQIGiTO0niY9+1MmKvjVY1337Pg+hPbUiH0Sw1LuL3/m+BQwpD
         hb5tyZrCHf5it26F0dPaxdqCh84tpEyx70A+7aug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ding Hui <dinghui@sangfor.com.cn>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 009/183] efi: fix userspace infinite retry read efivars after EFI runtime services page fault
Date:   Mon, 16 Jan 2023 16:48:52 +0100
Message-Id: <20230116154803.768917283@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

commit e006ac3003080177cf0b673441a4241f77aaecce upstream.

After [1][2], if we catch exceptions due to EFI runtime service, we will
clear EFI_RUNTIME_SERVICES bit to disable EFI runtime service, then the
subsequent routine which invoke the EFI runtime service should fail.

But the userspace cat efivars through /sys/firmware/efi/efivars/ will stuck
and infinite loop calling read() due to efivarfs_file_read() return -EINTR.

The -EINTR is converted from EFI_ABORTED by efi_status_to_err(), and is
an improper return value in this situation, so let virt_efi_xxx() return
EFI_DEVICE_ERROR and converted to -EIO to invoker.

Cc: <stable@vger.kernel.org>
Fixes: 3425d934fc03 ("efi/x86: Handle page faults occurring while running EFI runtime services")
Fixes: 23715a26c8d8 ("arm64: efi: Recover from synchronous exceptions occurring in firmware")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 7feee3d9c2bf..1fba4e09cdcf 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -62,6 +62,7 @@ struct efi_runtime_work efi_rts_work;
 									\
 	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {			\
 		pr_warn_once("EFI Runtime Services are disabled!\n");	\
+		efi_rts_work.status = EFI_DEVICE_ERROR;			\
 		goto exit;						\
 	}								\
 									\
-- 
2.39.0




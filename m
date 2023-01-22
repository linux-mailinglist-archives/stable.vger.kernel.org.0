Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9D6676EF0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjAVPQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjAVPQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2922037
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44CB8B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ADBC433EF;
        Sun, 22 Jan 2023 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400559;
        bh=Qj/x9nL42oBnVzM5mFOhNfHivTU8x7Kd4DHXOCWwFdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fG9N0Swo701k9zvBUlE0sWW9J/p7dKybX3P3/e8+7rDol/7HusywymJT/EC+guIoH
         K9omPX2OdP3PK3UtJLY/ZebG4WGpriymGi+DcmwssJpLUATpFMQXPfOlQ6Vbg2f/Yo
         csrB4IFboXFkcSb1FKsWX227iKDxF+TStzNr+XKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ding Hui <dinghui@sangfor.com.cn>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/117] efi: fix userspace infinite retry read efivars after EFI runtime services page fault
Date:   Sun, 22 Jan 2023 16:03:31 +0100
Message-Id: <20230122150233.580786123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit e006ac3003080177cf0b673441a4241f77aaecce ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index f3e54f6616f0..60075e0e4943 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92759272F32
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgIUQzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbgIUQpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474BE20874;
        Mon, 21 Sep 2020 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706752;
        bh=xdeqEMggzB4FvlJF3TTpzHbNj9IqrUdNiNTNJo4ZUfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O979cFsWmcFiiAX8J8ddP3eBBXruGgC51G1JkGfI182QGoa8gLSZbybwqHUaeuXxw
         L/7TJortzon0n0AxiNn7fv8yUSiAas9TGsh6Ht38taoLPTwecx+6CfmZ+HOvxRyVXD
         iBaBJfaz5KRwssZM/ltx3jvLLp7JUSvYXF1Yqw3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Branden Sherrell <sherrellbc@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 080/118] efi: efibc: check for efivars write capability
Date:   Mon, 21 Sep 2020 18:28:12 +0200
Message-Id: <20200921162040.049943315@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 46908326c6b801201f1e46f5ed0db6e85bef74ae ]

Branden reports that commit

  f88814cc2578c1 ("efi/efivars: Expose RT service availability via efivars abstraction")

regresses UEFI platforms that implement GetVariable but not SetVariable
when booting kernels that have EFIBC (bootloader control) enabled.

The reason is that EFIBC is a user of the efivars abstraction, which was
updated to permit users that rely only on the read capability, but not on
the write capability. EFIBC is in the latter category, so it has to check
explicitly whether efivars supports writes.

Fixes: f88814cc2578c1 ("efi/efivars: Expose RT service availability via efivars abstraction")
Tested-by: Branden Sherrell <sherrellbc@gmail.com>
Link: https://lore.kernel.org/linux-efi/AE217103-C96F-4AFC-8417-83EC11962004@gmail.com/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efibc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index 35dccc88ac0af..15a47539dc563 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -84,7 +84,7 @@ static int __init efibc_init(void)
 {
 	int ret;
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+	if (!efivars_kobject() || !efivar_supports_writes())
 		return -ENODEV;
 
 	ret = register_reboot_notifier(&efibc_reboot_notifier);
-- 
2.25.1




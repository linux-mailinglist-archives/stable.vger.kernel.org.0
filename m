Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B312F3109
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbhALNPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403949AbhALM5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD4A723132;
        Tue, 12 Jan 2021 12:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456163;
        bh=R1Gg9szGqRp7szDQbVm8G4rG8+I5sS1lsQ2r0lXUOpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZcTa82Kjc1WVbEFOhZ3yJs4F+t1151R699+KcJDqAfvz+JZlbDxE+UTY50ko+oz9
         TiDd3kCZEdck8CwKN09iQFA3yqd28n8hXIj36oBFYqSaAogrO7iC675O/6Lj+D3uHo
         zDkk/7a8UnxtwVShJcFAlUnV06VGK2ASzX2oOSh0s4IPUusEEQ+Qs+KdodNyBjE24v
         6hQEHhb5f9q9eg0GrEubbe3oyIxTF4WSUw+/UrDFImGLnI2t3p4eQjchtpdp8KjQUm
         iIagypByR/z9ZqWOsW/oN1A751Sbxvl8UZDFinEpUdlR6Bth45W3pPXUAatb72U6Nt
         bkwNOX6MsMGfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <ogabbay@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 21/51] habanalabs: register to pci shutdown callback
Date:   Tue, 12 Jan 2021 07:55:03 -0500
Message-Id: <20210112125534.70280-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit fcaebc7354188b0d708c79df4390fbabd4d9799d ]

We need to make sure our device is idle when rebooting a virtual
machine. This is done in the driver level.

The firmware will later handle FLR but we want to be extra safe and
stop the devices until the FLR is handled.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/habanalabs_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index f9067d3ef4376..3bcef64a677ae 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -528,6 +528,7 @@ static struct pci_driver hl_pci_driver = {
 	.id_table = ids,
 	.probe = hl_pci_probe,
 	.remove = hl_pci_remove,
+	.shutdown = hl_pci_remove,
 	.driver.pm = &hl_pm_ops,
 	.err_handler = &hl_pci_err_handler,
 };
-- 
2.27.0


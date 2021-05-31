Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DCC39625F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhEaOzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234047AbhEaOxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C6AB6193A;
        Mon, 31 May 2021 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469514;
        bh=EQuL5AWD/fApjp0/wL1bMQy/0dIiryBUxf0x/fpQz9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvUBnwFK6XLEfBcKdg2wD8EPGiAnQpRVWqujctb/MwpFzKfPSOf25L8N3selEEW4f
         u6w6lKujLMP8Ibl/LGSqdADHKjvsc7t+DFffVpN1sqCZQWDYU8kIG2duI62n7/cnkk
         088A9aMRpCNvmuYkpR3E/BffuvsbM8I/qdhTadKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 209/296] platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI
Date:   Mon, 31 May 2021 15:14:24 +0200
Message-Id: <20210531130710.890146435@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit bc1eca606d8084465e6f89fd646cc71defbad490 ]

The intel_punit_ipc driver might be compiled as a module.
When udev handles the event of the devices appearing
the intel_punit_ipc module is missing.

Append MODULE_DEVICE_TABLE for ACPI case to fix the loading issue.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210519101521.79338-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_punit_ipc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel_punit_ipc.c b/drivers/platform/x86/intel_punit_ipc.c
index 05cced59e251..f58b8543f6ac 100644
--- a/drivers/platform/x86/intel_punit_ipc.c
+++ b/drivers/platform/x86/intel_punit_ipc.c
@@ -312,6 +312,7 @@ static const struct acpi_device_id punit_ipc_acpi_ids[] = {
 	{ "INT34D4", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, punit_ipc_acpi_ids);
 
 static struct platform_driver intel_punit_ipc_driver = {
 	.probe = intel_punit_ipc_probe,
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68604290A7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243117AbhJKOLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242419AbhJKOI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 320CB611C1;
        Mon, 11 Oct 2021 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960900;
        bh=kLTm8P6x3BXBi1E6Aqz11EmYLMX1ltJXQxV3/VpM1Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvTVRgS9Iczzqx24JXikf6p5pkWujJ4aYDnpgbFTbI1qCCf/plxqFKuL+KXhAgw7z
         45gAWBXMnfkRKa6mn8QFHBg2g7JGd18xtD8A9rqgX+hmYIxi74dFfEC2OCGUiKerZk
         Bq2Tr2HbPulGw3tGb7yJT7W8z8aFVxOwRl37PznE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 075/151] ptp_pch: Load module automatically if ID matches
Date:   Mon, 11 Oct 2021 15:45:47 +0200
Message-Id: <20211011134520.276678966@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7cd8b1542a7ba0720c5a0a85ed414a122015228b ]

The driver can't be loaded automatically because it misses
module alias to be provided. Add corresponding MODULE_DEVICE_TABLE()
call to the driver.

Fixes: 863d08ece9bf ("supports eg20t ptp clock")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_pch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index a17e8cc642c5..8070f3fd98f0 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -644,6 +644,7 @@ static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	 },
 	{0}
 };
+MODULE_DEVICE_TABLE(pci, pch_ieee1588_pcidev_id);
 
 static SIMPLE_DEV_PM_OPS(pch_pm_ops, pch_suspend, pch_resume);
 
-- 
2.33.0




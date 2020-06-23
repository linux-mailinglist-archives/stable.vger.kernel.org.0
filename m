Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BB12061B6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392740AbgFWUtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392279AbgFWUtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:49:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8322921548;
        Tue, 23 Jun 2020 20:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945344;
        bh=xR+VQHL8k3nm7QQNu2tsD11HiP+t/gpZL2k7gf8zjmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsooPLg1u2k/gp4cn3gCDDsrpKhO5FDygBUO03lcU5kKXN5RN8XyBfKlN4d94Ll3M
         VophLcef/iTR/UOk/mkxL8U6iE2yH1iwhhJIsEFuTqv20OWVCz/bIdVkh6f5eN2zlm
         tcxtJZkSSZ278mPIRxizZfu8hpKCvJty9mDj1wCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Qais Yousef <qais.yousef@arm.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/136] usb/ehci-platform: Set PM runtime as active on resume
Date:   Tue, 23 Jun 2020 21:59:21 +0200
Message-Id: <20200623195308.955410923@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 16bdc04cc98ab0c74392ceef2475ecc5e73fcf49 ]

Follow suit of ohci-platform.c and perform pm_runtime_set_active() on
resume.

ohci-platform.c had a warning reported due to the missing
pm_runtime_set_active() [1].

[1] https://lore.kernel.org/lkml/20200323143857.db5zphxhq4hz3hmd@e107158-lin.cambridge.arm.com/

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
CC: Tony Prisk <linux@prisktech.co.nz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mathias Nyman <mathias.nyman@intel.com>
CC: Oliver Neukum <oneukum@suse.de>
CC: linux-arm-kernel@lists.infradead.org
CC: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20200518154931.6144-3-qais.yousef@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-platform.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index f1908ea9fbd86..6fcd332880143 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -390,6 +390,11 @@ static int ehci_platform_resume(struct device *dev)
 	}
 
 	ehci_resume(hcd, priv->reset_on_resume);
+
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
-- 
2.25.1




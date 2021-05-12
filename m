Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DE737CC08
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbhELQjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhELQcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9024261A2D;
        Wed, 12 May 2021 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835110;
        bh=Ne5trIiyEQCtOpf/bkKgwHifDtC47CY9uAXmcnuHXNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOPUZfsqb4Xe+MFzFQF3THBmreBzeEAF3Dgch242nvkCKQ2FA6HYNxqyweMBPoFlO
         cKQRKD+gP615jeOIBn2gHRvmubXMjKb3JS3xv0rajMgEItyx2HQDfBNCgG21yxdIqF
         cBnnK2l3WpFoj0dMX3Pw27R9ZCqqbQaB5qaHXHgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 212/677] usb: host: ehci-tegra: Select USB_GADGET Kconfig option
Date:   Wed, 12 May 2021 16:44:18 +0200
Message-Id: <20210512144844.282670488@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 0b9828763aeafa5e527b9d98b8789bdb34937fbc ]

Select USB_GADGET Kconfig option in order to fix build failure which
happens because ChipIdea driver has a build dependency on both USB_GADGET
and USB_EHCI_HCD, while USB_EHCI_TEGRA force-selects the ChipIdea driver
without taking into account the tristate USB_GADGET dependency. It's not
possible to do anything about the cyclic dependency of the Kconfig
options, but USB_EHCI_TEGRA is now a deprecated option that isn't used
by defconfigs and USB_GADGET is wanted on Tegra by default, hence it's
okay to have a bit clunky workaround for it.

Fixes: c3590c7656fb ("usb: host: ehci-tegra: Remove the driver")
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210320151915.7566-2-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index b94f2a070c05..df9428f1dc5e 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -272,6 +272,7 @@ config USB_EHCI_TEGRA
 	select USB_CHIPIDEA
 	select USB_CHIPIDEA_HOST
 	select USB_CHIPIDEA_TEGRA
+	select USB_GADGET
 	help
 	  This option is deprecated now and the driver was removed, use
 	  USB_CHIPIDEA_TEGRA instead.
-- 
2.30.2




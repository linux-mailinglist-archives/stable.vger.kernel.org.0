Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E311B7FBB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 22:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgDXUGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 16:06:55 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5105 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgDXUGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 16:06:55 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea3469f0000>; Fri, 24 Apr 2020 13:05:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 Apr 2020 13:06:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 Apr 2020 13:06:55 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 20:06:54 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 24 Apr 2020 20:06:54 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.165.152]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ea346de0000>; Fri, 24 Apr 2020 13:06:54 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <baolin.wang@linaro.org>, <kstewart@linuxfoundation.org>,
        <tglx@linutronix.de>, <bradleybolen@gmail.com>,
        <gregkh@linuxfoundation.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>
CC:     <anrao@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 4.19.113 0/3] Fix for long operation cmds busy detection
Date:   Fri, 24 Apr 2020 13:06:49 -0700
Message-ID: <1587758812-3331-1-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587758751; bh=MLMeZlGwo09nxFFR4BPaUlO5N8koBh6qfFD6TaQ2IpY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=BBaqvbsEihLBksbQRZk/HJhlXcr26oHDS0BvxaVffIT+VFOt8E/ltllT5fGgh47OG
         dYMBf88T44yQ2YgH8LylJrYJyFznW4lRL38crhSy1Eg/AQ9ooSkYPHRrrCRQwSB0vo
         5ljVr8l4pw8eDYDhk6pCBFJyijuLYFIcpc9OBVe9sRCEpWnR7h8/JhalZo48UxH7my
         8VQ7K4R+elTsDS8fzoXOa9lqBVwL6asTS2xsULGG0flLPAOSMOSIYs4Z4cg7AphZg8
         R9PAvAvlhK9cu1r7/DHQeyMWw2Tq0bnQUQ6dobsZxBuZg6OeUQseutupnjo3xVtfIW
         odSaO98D78Vgw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series includes manually backported changes that implements Tegra
specific timeout callback to switch between finite and infinite HW busy
detection wait modes.

sdhci-tegra driver patch implements set_timeout callback based on one of
the sdhci host driver patch that refactors sdhci_set_timeout and allows
drivers to call __sdhci_set_timeout with their timeout callback
implementation.

Both of these patches are manually backported in this series.


Sowjanya Komatineni (3):
  mmc: sdhci: Refactor sdhci_set_timeout()
  sdhci: tegra: Implement Tegra specific set_timeout callback
  sdhci: tegra: Enable MMC_CAP_WAIT_WHILE_BUSY host capability

 drivers/mmc/host/sdhci-tegra.c | 32 ++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c       | 38 ++++++++++++++++++++------------------
 drivers/mmc/host/sdhci.h       |  1 +
 3 files changed, 53 insertions(+), 18 deletions(-)

-- 
2.7.4


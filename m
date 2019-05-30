Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345622F023
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbfE3EBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731455AbfE3DSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B66F824764;
        Thu, 30 May 2019 03:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186290;
        bh=B1REWhhUT/QzQkBeseofxK6UAlJ9OwSyGnb7velQKW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5mFBGMzsD0+zA06tiLivczBXL7At07Y1/EfAFnwrWBE86Y5mgNNrMY/zoqPlDb2m
         B5Q5I90oyBg8UMFMIvICbzIe9adZSWrM9J/rn41R/iQP0QA82RYygJfSoJPoL5fN4E
         jYr41BzFPYsFzcebb9CvJRai33yFpBTR6yKLM7WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 248/276] igb: Exclude device from suspend direct complete optimization
Date:   Wed, 29 May 2019 20:06:46 -0700
Message-Id: <20190530030540.657718120@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5b6e13216be29ced7350d9c354a1af8fe0ad9a3e ]

igb sets different WoL settings in system suspend callback and runtime
suspend callback.

The suspend direct complete optimization leaves igb in runtime suspended
state with wrong WoL setting during system suspend.

To fix this, we need to disable suspend direct complete optimization to
let igb always use suspend callback to set correct WoL during system
suspend.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index aa39a068858e9..5aa083d9a6c9a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3468,6 +3468,9 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			break;
 		}
 	}
+
+	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NEVER_SKIP);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	return 0;
 
-- 
2.20.1




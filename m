Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF575451ED2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344963AbhKPAhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344740AbhKOTZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 612FD636B9;
        Mon, 15 Nov 2021 19:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003001;
        bh=/2HF/Sw8iqJg4ODcPHrq0Q+pNuRet88pFKqvCuqggiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qIMpUfYlUaH6A5B+sEPMHCJqvV/v8O9FzaLtGorrl7wut8zVsmDz79EXzex+AvBz
         M+tWebynyeOMJCMFLGk+NWHrZetK9JA1lvfJR6li3cUXViwbaX7gehv44xvbce+gcs
         3nEahgDtJ60/Imm2b+N/W8VLVtCuxxowjJZyWUJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 741/917] dmaengine: idxd: reconfig device after device reset command
Date:   Mon, 15 Nov 2021 18:03:56 +0100
Message-Id: <20211115165454.043047557@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit e530a9f3db4188d1f4e3704b0948ef69c04d5ca6 ]

Device reset clears the MSIXPERM table and the device registers. Re-program
the MSIXPERM table and re-enable the error interrupts post reset.

Fixes: 745e92a6d816 ("dmaengine: idxd: idxd: move remove() bits for idxd 'struct device' to device.c")
Reported-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163054188513.2853562.12077053294595278181.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index cbbfa17d8d11b..419b206f8a42d 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -583,6 +583,8 @@ void idxd_device_reset(struct idxd_device *idxd)
 	spin_lock(&idxd->dev_lock);
 	idxd_device_clear_state(idxd);
 	idxd->state = IDXD_DEV_DISABLED;
+	idxd_unmask_error_interrupts(idxd);
+	idxd_msix_perm_setup(idxd);
 	spin_unlock(&idxd->dev_lock);
 }
 
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC89D13EF73
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404745AbgAPSPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392871AbgAPR3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F4F02470D;
        Thu, 16 Jan 2020 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195789;
        bh=dD48XLursiYa//ePhMcMMl4C1MPrYkYGKY8FF/TExg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZmlqdvZVywIM7sIbFoRHeGTLSb+2RoS2daKQPJozSJd4kcncmMqZI75C7Ai22UPS
         hnejJmjatu9KlG75dB3oxCkeAw+LBQ+IlL2LIovdM0raEqdxElIlcL3UWEZnTH4w20
         8zapg/LofbksdntflHMRsS04fjS4q39N6fBo77Xw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 311/371] nvme: retain split access workaround for capability reads
Date:   Thu, 16 Jan 2020 12:23:03 -0500
Message-Id: <20200116172403.18149-254-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 3a8ecc935efabdad106b5e06d07b150c394b4465 ]

Commit 7fd8930f26be4

  "nvme: add a common helper to read Identify Controller data"

has re-introduced an issue that we have attempted to work around in the
past, in commit a310acd7a7ea ("NVMe: use split lo_hi_{read,write}q").

The problem is that some PCIe NVMe controllers do not implement 64-bit
outbound accesses correctly, which is why the commit above switched
to using lo_hi_[read|write]q for all 64-bit BAR accesses occuring in
the code.

In the mean time, the NVMe subsystem has been refactored, and now calls
into the PCIe support layer for NVMe via a .reg_read64() method, which
fails to use lo_hi_readq(), and thus reintroduces the problem that the
workaround above aimed to address.

Given that, at the moment, .reg_read64() is only used to read the
capability register [which is known to tolerate split reads], let's
switch .reg_read64() to lo_hi_readq() as well.

This fixes a boot issue on some ARM boxes with NVMe behind a Synopsys
DesignWare PCIe host controller.

Fixes: 7fd8930f26be4 ("nvme: add a common helper to read Identify Controller data")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index cd11cced3678..3788c053a0b1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2274,7 +2274,7 @@ static int nvme_pci_reg_write32(struct nvme_ctrl *ctrl, u32 off, u32 val)
 
 static int nvme_pci_reg_read64(struct nvme_ctrl *ctrl, u32 off, u64 *val)
 {
-	*val = readq(to_nvme_dev(ctrl)->bar + off);
+	*val = lo_hi_readq(to_nvme_dev(ctrl)->bar + off);
 	return 0;
 }
 
-- 
2.20.1


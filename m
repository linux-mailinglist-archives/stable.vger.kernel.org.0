Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A7D20E835
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391687AbgF2WEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgF2SfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95FC2405C;
        Mon, 29 Jun 2020 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443930;
        bh=7NDwsqB7TgbdnkZ66qpsR+9t4LAP6VSLYc1GeJ1+DD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOtKi7r0hDKXkNZlA7RZ5RBdduTEYe/TO47gLPB3+t0jHJhIdUPXviQvmVWUbFQbX
         JuSLn+r1ZcYa/aF5Ime9O5vwt//XkgT2A3RHT/+NVJ+BHpristHmW15SLqSKxw8aM7
         M8uuO2o3luk/2YcZBYtLXPvJr5Sk2ZJyEiZqTcwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 031/265] bnxt_en: Read VPD info only for PFs
Date:   Mon, 29 Jun 2020 11:14:24 -0400
Message-Id: <20200629151818.2493727-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit c55e28a8b43fcd7dc71868bd165705bc7741a7ca ]

Virtual functions does not have VPD information. This patch modifies
calling bnxt_read_vpd_info() only for PFs and avoids an unnecessary
error log.

Fixes: a0d0fd70fed5 ("bnxt_en: Read partno and serialno of the board from VPD")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c202c2a3d140d..b6fb5a1709c01 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11884,7 +11884,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &bnxt_ethtool_ops;
 	pci_set_drvdata(pdev, dev);
 
-	bnxt_vpd_read_info(bp);
+	if (BNXT_PF(bp))
+		bnxt_vpd_read_info(bp);
 
 	rc = bnxt_alloc_hwrm_resources(bp);
 	if (rc)
-- 
2.25.1


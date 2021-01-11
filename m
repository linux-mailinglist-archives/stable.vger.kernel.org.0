Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2052F13D7
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbhAKNPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731811AbhAKNPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F402229C;
        Mon, 11 Jan 2021 13:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370915;
        bh=0gazlHiRwnOZOpwzqr5Yp5TzvlslYu9zih3AHPdaybU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dqMvn4/fg5H5gna+9q3HKOLd6/vDwW1Cv8nLXkqinGbPZm51q9aZdY1jngfWF2lm
         84agzlDPj5otLEyTUY0ebKIngMyLOX1BmDv0Ckw935vgxtM1eTJibOplIjfAwh8IWV
         /1nvwk9hct6VNAFcSrxN6vHxOlPEhxgf7hlPiwWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/145] scsi: ufs-pci: Enable UFSHCD_CAP_RPM_AUTOSUSPEND for Intel controllers
Date:   Mon, 11 Jan 2021 14:01:22 +0100
Message-Id: <20210111130051.326737408@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit dd78bdb6f810bdcb173b42379af558c676c8e0aa ]

Enable runtime PM auto-suspend by default for Intel host controllers.

Link: https://lore.kernel.org/r/20201207083120.26732-5-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 888d8c9ca3a55..fadd566025b86 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -148,6 +148,8 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 {
 	struct intel_host *host;
 
+	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
+
 	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
-- 
2.27.0




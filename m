Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A148A1AF0C4
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgDROwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgDROmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D881522252;
        Sat, 18 Apr 2020 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220941;
        bh=aBiKRtEwJSJ8EawSUmhre+WjRJEOrBukB4zaQ//1MYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCO5MiC9WXbVcnSkq8yXnLtFflNOWuXow1rAq7lR0jKRSp/hQiIG+1NaFCJORDaKq
         nR8JxCi9SCDwDSphhg7xxlTUvD54bF3qAAXEle/wYpLWTkwyWzyMYuNTJsgR6pMOcP
         ggeSh/mEWwfA7LBhrMNzYzhjsyFxtpsUlAb+94CE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Murthy Bhat <Murthy.Bhat@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 75/78] scsi: smartpqi: fix call trace in device discovery
Date:   Sat, 18 Apr 2020 10:40:44 -0400
Message-Id: <20200418144047.9013-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microsemi.com>

[ Upstream commit b969261134c1b990b96ea98fe5e0fcf8ec937c04 ]

Use sas_phy_delete rather than sas_phy_free which, according to
comments, should not be called for PHYs that have been set up
successfully.

Link: https://lore.kernel.org/r/157048748876.11757.17773443136670011786.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 6776dfc1d317c..b7e28b9f8589f 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -45,9 +45,9 @@ static void pqi_free_sas_phy(struct pqi_sas_phy *pqi_sas_phy)
 	struct sas_phy *phy = pqi_sas_phy->phy;
 
 	sas_port_delete_phy(pqi_sas_phy->parent_port->port, phy);
-	sas_phy_free(phy);
 	if (pqi_sas_phy->added_to_port)
 		list_del(&pqi_sas_phy->phy_list_entry);
+	sas_phy_delete(phy);
 	kfree(pqi_sas_phy);
 }
 
-- 
2.20.1


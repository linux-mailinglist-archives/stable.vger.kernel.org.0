Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03643CD7D8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242245AbhGSOTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242131AbhGSOSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D42246112D;
        Mon, 19 Jul 2021 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706762;
        bh=lHdeqfKYjwgtzBUNGdz46DWAGCPWre0/g1WWiMcGvN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StXtkhvSWjqaUPTOUmJPQZOm/B7XMGd4JSmnCkmjx3G5Eh23fkmjIZO2yDGMDPfsI
         3z7GDglHoTpBErkQn1KxwGfWJ4tzAYcwdq8vv/07IbDRRFxp2zmFU+aSABi19AmBbN
         U2onMeu8Kvb5q2JWtXL2QjMpaq047xoGHz0xZwTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 088/188] scsi: mpt3sas: Fix error return value in _scsih_expander_add()
Date:   Mon, 19 Jul 2021 16:51:12 +0200
Message-Id: <20210719144933.596548323@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit d6c2ce435ffe23ef7f395ae76ec747414589db46 ]

When an expander does not contain any 'phys', an appropriate error code -1
should be returned, as done elsewhere in this function. However, we
currently do not explicitly assign this error code to 'rc'. As a result, 0
was incorrectly returned.

Link: https://lore.kernel.org/r/20210514081300.6650-1-thunder.leizhen@huawei.com
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8735e4257028..49b751a8f5f3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5014,8 +5014,10 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	    handle, parent_handle, (unsigned long long)
 	    sas_expander->sas_address, sas_expander->num_phys);
 
-	if (!sas_expander->num_phys)
+	if (!sas_expander->num_phys) {
+		rc = -1;
 		goto out_fail;
+	}
 	sas_expander->phy = kcalloc(sas_expander->num_phys,
 	    sizeof(struct _sas_phy), GFP_KERNEL);
 	if (!sas_expander->phy) {
-- 
2.30.2




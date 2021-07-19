Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8F3CD98C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbhGSOao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244045AbhGSO3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BCBA6128A;
        Mon, 19 Jul 2021 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707322;
        bh=5ZDHVfW8B0AvKuteMND22zDcF8Pgi9DikFQfqF5Cwjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmRKVRCrIQfVLoLtBPJ+A5NoefoY0koO5gkuz5JpgemiqN9uxrTwoqjHVRU3q0TCc
         8lifHiX4xwzCOedwswe5wSe6LaYsCxie7eiczDfquIls8l60sWVijFQspWX5AzOfJ/
         0mb0tKjqiYf3DvzhizUpe7FHttV5T98e6HF/QBNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 114/245] scsi: mpt3sas: Fix error return value in _scsih_expander_add()
Date:   Mon, 19 Jul 2021 16:50:56 +0200
Message-Id: <20210719144944.101593110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index aa2078d7e23e..58876b8a2e9f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5199,8 +5199,10 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
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




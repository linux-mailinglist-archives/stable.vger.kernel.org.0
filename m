Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882023C4FE0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343723AbhGLH2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245498AbhGLH1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:27:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B514061221;
        Mon, 12 Jul 2021 07:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074600;
        bh=tqny+4dDP+UDnNDW3XHLKCXwa3ZCi57AIDTxHNSfd0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quP1xfwoXuAuAbZrGr/EHMfTWXKf1hFXHLDylB8PgKpZOio7P0Owr7ysQzx/fZwEk
         CWWYWi7KA7m6TiVZk6eSpKPLHFUMV9tCxpnexFhPs8zHAeH8amviSZFz6VZrGy3xgW
         6wMW1dgZlXdeSB7bc6o4bRzXDcl7RvhRLOubK7Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 635/700] scsi: mpt3sas: Fix error return value in _scsih_expander_add()
Date:   Mon, 12 Jul 2021 08:11:58 +0200
Message-Id: <20210712061043.398508643@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index ae1973878cc7..7824e77bc6e2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6883,8 +6883,10 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		 handle, parent_handle,
 		 (u64)sas_expander->sas_address, sas_expander->num_phys);
 
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




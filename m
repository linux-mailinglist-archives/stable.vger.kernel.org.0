Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD083461DBD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhK2S3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48206 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377720AbhK2S1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98D8DCE13DE;
        Mon, 29 Nov 2021 18:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46617C53FAD;
        Mon, 29 Nov 2021 18:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210200;
        bh=4Fm6j3ICJq9RcLGNelDiZbMqVMzF/L0u4zpT9hiL/bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQQZDHKiEzG3sTjqLCLndMPUqiLPc7lnUn01C2V2p4CODrq3PUkxRf3/LENN5Hjk8
         uNAysOgExQcTzFRbrkgpl+vu2RFgYfVlSSx7K0I/0L1XNbvQFs5tFry++eyBLOH2k5
         6xcfCX31QFal+KjkXZIN+aHYATFjp3yLgw7uz/m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/69] firmware: arm_scmi: pm: Propagate return value to caller
Date:   Mon, 29 Nov 2021 19:18:25 +0100
Message-Id: <20211129181705.071604867@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 1446fc6c678e8d8b31606a4b877abe205f344b38 ]

of_genpd_add_provider_onecell may return error, so let's propagate
its return value to caller

Link: https://lore.kernel.org/r/20211116064227.20571-1-peng.fan@oss.nxp.com
Fixes: 898216c97ed2 ("firmware: arm_scmi: add device power domain support using genpd")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/scmi_pm_domain.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/scmi_pm_domain.c b/drivers/firmware/arm_scmi/scmi_pm_domain.c
index 041f8152272bf..177874adccf0d 100644
--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -106,9 +106,7 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
 	scmi_pd_data->domains = domains;
 	scmi_pd_data->num_domains = num_domains;
 
-	of_genpd_add_provider_onecell(np, scmi_pd_data);
-
-	return 0;
+	return of_genpd_add_provider_onecell(np, scmi_pd_data);
 }
 
 static const struct scmi_device_id scmi_id_table[] = {
-- 
2.33.0




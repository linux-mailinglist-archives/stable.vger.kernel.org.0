Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD3C4623C0
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhK2Vxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbhK2Vvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:51:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E67C0F4B11;
        Mon, 29 Nov 2021 10:25:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A09A4CE13FE;
        Mon, 29 Nov 2021 18:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C474C53FC7;
        Mon, 29 Nov 2021 18:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210334;
        bh=4Fm6j3ICJq9RcLGNelDiZbMqVMzF/L0u4zpT9hiL/bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/jvH8paHtXVpib4CCmIcPsHuler4WB433uVxqgfoYZR7Lc2cunMplyDg8BGTcIL7
         qG6a5lZcwgaL72Sm7quRMz5eqXLJMu/Dp8UAUF/KUG/pb5wqKgrrDMl6LG0+6mndcV
         ILT8OM9sHNAso9LywAiJZU268cxzSMjiSR0CXusA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/92] firmware: arm_scmi: pm: Propagate return value to caller
Date:   Mon, 29 Nov 2021 19:18:21 +0100
Message-Id: <20211129181709.158000821@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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




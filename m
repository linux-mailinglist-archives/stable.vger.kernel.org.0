Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66154624E9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhK2WdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhK2Wc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:32:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA051C1404F9;
        Mon, 29 Nov 2021 10:30:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AD3BB815CF;
        Mon, 29 Nov 2021 18:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF00C53FC7;
        Mon, 29 Nov 2021 18:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210643;
        bh=ZSmSfHig9PTFkY3PXBe3JjIQjQjMoLFmcOxhowBkzdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9E+LvGxE+44nnvvYo8UXZS2w4BZuz9dXxW9173xu0OpPu1aeY3R9TYxkQP7LqKMK
         QOZU8MFvoOJVNDa1HIOn8BvHNlLIs9yLnTyityGyvStQJSUZmwlQCVQYLgVzWSsQrv
         5cXW/Y5DYJrbJtuApqgPx7Scdh80KqKkiud2syI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/121] firmware: arm_scmi: pm: Propagate return value to caller
Date:   Mon, 29 Nov 2021 19:18:04 +0100
Message-Id: <20211129181713.435546458@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 9e44479f02842..a4e4aa9a35426 100644
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




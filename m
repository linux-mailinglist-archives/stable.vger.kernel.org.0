Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12C0246FCE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgHQRyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388609AbgHQQLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:11:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FFC520760;
        Mon, 17 Aug 2020 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680678;
        bh=tE+/jS+BvX9zc+s1uCDMixr7naVAWq9W2jUqiuF35ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUhK2vv4wwMZWOydY/34/0rXUrTy+yHUZTf6qeVr7K7kc7mfc4uG84uHUiI346xfo
         1A7enQKRvs84LNZvO7nkrpjz/Lb37OZ5zxQpDWGqS5YDKldoATMiPENjRn+1MTTIuL
         cO9Oips5fVfQM6I0N5iUK+MTsubz4JKpPanFYANI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/168] firmware: arm_scmi: Fix SCMI genpd domain probing
Date:   Mon, 17 Aug 2020 17:15:44 +0200
Message-Id: <20200817143734.386887260@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit e0f1a30cf184821499eeb67daedd7a3f21bbcb0b ]

When, at probe time, an SCMI communication failure inhibits the capacity
to query power domains states, such domains should be skipped.

Registering partially initialized SCMI power domains with genpd will
causes kernel panic.

 arm-scmi timed out in resp(caller: scmi_power_state_get+0xa4/0xd0)
 scmi-power-domain scmi_dev.2: failed to get state for domain 9
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
 Mem abort info:
   ESR = 0x96000006
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000006
   CM = 0, WnR = 0
 user pgtable: 4k pages, 48-bit VAs, pgdp=00000009f3691000
 [0000000000000000] pgd=00000009f1ca0003, p4d=00000009f1ca0003, pud=00000009f35ea003, pmd=0000000000000000
 Internal error: Oops: 96000006 [#1] PREEMPT SMP
 CPU: 2 PID: 381 Comm: bash Not tainted 5.8.0-rc1-00011-gebd118c2cca8 #2
 Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Jan  3 2020
 Internal error: Oops: 96000006 [#1] PREEMPT SMP
 pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
 pc : of_genpd_add_provider_onecell+0x98/0x1f8
 lr : of_genpd_add_provider_onecell+0x48/0x1f8
 Call trace:
  of_genpd_add_provider_onecell+0x98/0x1f8
  scmi_pm_domain_probe+0x174/0x1e8
  scmi_dev_probe+0x90/0xe0
  really_probe+0xe4/0x448
  driver_probe_device+0xfc/0x168
  device_driver_attach+0x7c/0x88
  bind_store+0xe8/0x128
  drv_attr_store+0x2c/0x40
  sysfs_kf_write+0x4c/0x60
  kernfs_fop_write+0x114/0x230
  __vfs_write+0x24/0x50
  vfs_write+0xbc/0x1e0
  ksys_write+0x70/0xf8
  __arm64_sys_write+0x24/0x30
  el0_svc_common.constprop.3+0x94/0x160
  do_el0_svc+0x2c/0x98
  el0_sync_handler+0x148/0x1a8
  el0_sync+0x158/0x180

Do not register any power domain that failed to be queried with genpd.

Fixes: 898216c97ed2 ("firmware: arm_scmi: add device power domain support using genpd")
Link: https://lore.kernel.org/r/20200619220330.12217-1-cristian.marussi@arm.com
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/scmi_pm_domain.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_scmi/scmi_pm_domain.c b/drivers/firmware/arm_scmi/scmi_pm_domain.c
index 87f737e01473c..041f8152272bf 100644
--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -85,7 +85,10 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
 	for (i = 0; i < num_domains; i++, scmi_pd++) {
 		u32 state;
 
-		domains[i] = &scmi_pd->genpd;
+		if (handle->power_ops->state_get(handle, i, &state)) {
+			dev_warn(dev, "failed to get state for domain %d\n", i);
+			continue;
+		}
 
 		scmi_pd->domain = i;
 		scmi_pd->handle = handle;
@@ -94,13 +97,10 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
 		scmi_pd->genpd.power_off = scmi_pd_power_off;
 		scmi_pd->genpd.power_on = scmi_pd_power_on;
 
-		if (handle->power_ops->state_get(handle, i, &state)) {
-			dev_warn(dev, "failed to get state for domain %d\n", i);
-			continue;
-		}
-
 		pm_genpd_init(&scmi_pd->genpd, NULL,
 			      state == SCMI_POWER_STATE_GENERIC_OFF);
+
+		domains[i] = &scmi_pd->genpd;
 	}
 
 	scmi_pd_data->domains = domains;
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DC5548D5D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380237AbiFMOKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382696AbiFMOGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:06:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C40972BB;
        Mon, 13 Jun 2022 04:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40C82612D0;
        Mon, 13 Jun 2022 11:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E80C34114;
        Mon, 13 Jun 2022 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120471;
        bh=KclK8A9MhOsYG/yo+Vlgioldi22Z3Bpk3Q51BGbrmKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FcBs8Gqq6XYlhgmQpGic8/E95c++Zklc+CV8/abLQ7eDFMZyjTp0HDfD1Kwlwr9n
         xMtqMTuQnpiF9AotiOZT2WpnW2iV4y028pNGGe1LK1JaAjGOswnhk6ODIO+IN50Ykr
         XQ6UDNqzndg9l4YC627BHS9VqgQdOpdT6mrmPbeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 045/298] soundwire: intel: prevent pm_runtime resume prior to system suspend
Date:   Mon, 13 Jun 2022 12:08:59 +0200
Message-Id: <20220613094926.311357034@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 6d9f2dadba698114fed97b224578c5338a36b0d9 ]

commit e38f9ff63e6d ("ACPI: scan: Do not add device IDs from _CID if _HID is not valid")
exposes a race condition on a TGL RVP device leading to a timeout.

The detailed analysis shows the RT711 codec driver scheduling a jack
detection workqueue while attaching during a spurious pm_runtime
resume, and the work function happens to be scheduled after the
manager device is suspended.

The direct link between this ACPI patch and a spurious pm_runtime
resume is not obvious; the most likely explanation is that a change in
the ACPI device linked list management modifies the order in which the
pm_runtime device status is checked and exposes a race condition that
was probably present for a very long time, but was not identified.

We already have a check in the .prepare stage, where we will resume to
full power from specific clock-stop modes. In all other cases, we
don't need to resume to full power by default. Adding the
SMART_SUSPEND flag prevents the spurious resume from happening.

BugLink: https://github.com/thesofproject/linux/issues/3459
Fixes: 029bfd1cd53cd ("soundwire: intel: conditionally exit clock stop mode on system suspend")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220420023241.14335-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 63101f1ba271..32e5fdb823c4 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1293,6 +1293,9 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 	/* use generic bandwidth allocation algorithm */
 	sdw->cdns.bus.compute_params = sdw_compute_params;
 
+	/* avoid resuming from pm_runtime suspend if it's not required */
+	dev_pm_set_driver_flags(dev, DPM_FLAG_SMART_SUSPEND);
+
 	ret = sdw_bus_master_add(bus, dev, dev->fwnode);
 	if (ret) {
 		dev_err(dev, "sdw_bus_master_add fail: %d\n", ret);
-- 
2.35.1




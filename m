Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4665836A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiL1Qrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbiL1QrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB7910FE2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84C261563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF2AC433EF;
        Wed, 28 Dec 2022 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245734;
        bh=T1EBcmEjeuHlN8Z2o4YK5ngb+84CoXiUzQ9398MNlQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFjhB37VPA5mJwNgkfQbaAV7E0H0q0bwMbgUXCVGDMNxozPhcTQKowBR/hK+qulMZ
         9LvZ+H7Euc7KWJawD8TUT390FdEFl2r439peJLNYQTWh0kHSmUjrKpfvqj6Amejton
         uUTNmzjyD0eB11jihRzSHbiE5An89jQ7nCjC1U6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0913/1146] igc: allow BaseTime 0 enrollment for Qbv
Date:   Wed, 28 Dec 2022 15:40:52 +0100
Message-Id: <20221228144355.036595660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

[ Upstream commit e17090eb24944fbbe1f24d9f336d7bad4fbe47e8 ]

Introduce qbv_enable flag in igc_adapter struct to store the Qbv on/off.
So this allow the BaseTime to enroll with zero value.

Fixes: 61572d5f8f91 ("igc: Simplify TSN flags handling")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc.h      | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 66a57636d329..df3e26c0cf01 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -184,6 +184,7 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool qbv_enable;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 42386a0eef68..d666b3aab523 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6037,6 +6037,8 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 
+	adapter->qbv_enable = qopt->enable;
+
 	if (!qopt->enable)
 		return igc_tsn_clear_schedule(adapter);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 4a019954cadb..356c7455c5ce 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -36,7 +36,7 @@ static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
 {
 	unsigned int new_flags = adapter->flags & ~IGC_FLAG_TSN_ANY_ENABLED;
 
-	if (adapter->base_time)
+	if (adapter->qbv_enable)
 		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
 
 	if (is_any_launchtime(adapter))
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A654CF8E1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbiCGKCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240028AbiCGKAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB5A7DE02;
        Mon,  7 Mar 2022 01:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A1EF61052;
        Mon,  7 Mar 2022 09:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27947C340E9;
        Mon,  7 Mar 2022 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646403;
        bh=+LFM31gspWtXscCtNJZur9wApwtIRx/5VXXQ3tSM4jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwewKmHn1or4vCi1puRmrogS6oVfqYwigPRJwqwqg0CXFmpTuZ2R6eBaj8iZLruMh
         fOBn1cNbF6ajKoUFNd2oxlKi/qs2cIvQQnXX59ake1PGMXg1ObRksuDaQSO34KaX7Z
         8okGQmnuc4741RSWEzZmemGk32ps/DMmnA0Lb1Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/262] iavf: Fix race in init state
Date:   Mon,  7 Mar 2022 10:19:37 +0100
Message-Id: <20220307091709.849993819@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit a472eb5cbaebb5774672c565e024336c039e9128 ]

When iavf_init_version_check sends VIRTCHNL_OP_GET_VF_RESOURCES
message, the driver will wait for the response after requeueing
the watchdog task in iavf_init_get_resources call stack. The
logic is implemented this way that iavf_init_get_resources has
to be called in order to allocate adapter->vf_res. It is polling
for the AQ response in iavf_get_vf_config function. Expect a
call trace from kernel when adminq_task worker handles this
message first. adapter->vf_res will be NULL in
iavf_virtchnl_completion.

Make the watchdog task not queue the adminq_task if the init
process is not finished yet.

Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d11e172252b4..e23a062dc39c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2125,7 +2125,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
-	queue_work(iavf_wq, &adapter->adminq_task);
+	if (adapter->state >= __IAVF_DOWN)
+		queue_work(iavf_wq, &adapter->adminq_task);
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(20));
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB6B43FC9
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfFMQAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731466AbfFMItG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:49:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9A8120851;
        Thu, 13 Jun 2019 08:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415746;
        bh=XLkufEsEZBuRqb2pPmA7YNzFgIHzzj0W7dsrIzOrwAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdQo7HE+iwe2B3ksMi5GzZa6S1iFxRDxyl76pMsA3fcoemFze23RHixxCafB2JO+l
         sZnrHxOPARnOLFbvTzB6wxpfu4YoiB69JJAE1HTf+ceQ0cPZRAsxmgxz56FwjIjCcc
         eFanqgpW1wCwWTV7pHf3SF4G2ZNMhogYbRZ8CIR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Ludkiewicz <adam.ludkiewicz@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 094/155] i40e: Queues are reserved despite "Invalid argument" error
Date:   Thu, 13 Jun 2019 10:33:26 +0200
Message-Id: <20190613075658.342251502@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3e957b377bf4262aec2dd424f28ece94e36814d4 ]

Added a new local variable in the i40e_setup_tc function named
old_queue_pairs so num_queue_pairs can be restored to the correct
value in case configuring queue channels fails. Additionally, moved
the exit label in the i40e_setup_tc function so the if (need_reset)
block can be executed.
Also, fixed data packing in the i40e_setup_tc function.

Signed-off-by: Adam Ludkiewicz <adam.ludkiewicz@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ac9fcb097689..133f5e008822 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6854,10 +6854,12 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 	struct i40e_pf *pf = vsi->back;
 	u8 enabled_tc = 0, num_tc, hw;
 	bool need_reset = false;
+	int old_queue_pairs;
 	int ret = -EINVAL;
 	u16 mode;
 	int i;
 
+	old_queue_pairs = vsi->num_queue_pairs;
 	num_tc = mqprio_qopt->qopt.num_tc;
 	hw = mqprio_qopt->qopt.hw;
 	mode = mqprio_qopt->mode;
@@ -6958,6 +6960,7 @@ config_tc:
 		}
 		ret = i40e_configure_queue_channels(vsi);
 		if (ret) {
+			vsi->num_queue_pairs = old_queue_pairs;
 			netdev_info(netdev,
 				    "Failed configuring queue channels\n");
 			need_reset = true;
-- 
2.20.1




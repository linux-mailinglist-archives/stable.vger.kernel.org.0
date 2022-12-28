Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862BE657DBB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiL1PqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbiL1PqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:46:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A34FCD8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:46:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11C746154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A46CC433D2;
        Wed, 28 Dec 2022 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242373;
        bh=XcA2ZsjJlxy7qZFuh/l+mK6SP8pgIj4XPvAQroOHx0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xV3BPF+0mqeBq09G15UIU6KB7A5fInQi1OARuOJPX9tEQmShlUFIdaAMsWZL43sdw
         tq1FdATR7m3hEaxhNeB8m0psNVWLhK2IjqoQ2EbnXKkkRv6q7O+oAM218xdaspBaea
         qVqcJgDeJgJXKf1ERNWB5BK9/HMDGw/oalvXgfEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 596/731] igc: Add checking for basetime less than zero
Date:   Wed, 28 Dec 2022 15:41:43 +0100
Message-Id: <20221228144313.817776830@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit 3b61764fb49a6e147ac90d71dccdddc9d5508ba1 ]

Using the tc qdisc command, the user can set basetime to any value.
Checking should be done on the driver's side to prevent registering
basetime values that are less than zero.

Fixes: ec50a9d437f0 ("igc: Add support for taprio offloading")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index af55e2f62e47..26dd710fba8f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5984,6 +5984,9 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	if (!qopt->enable)
 		return igc_tsn_clear_schedule(adapter);
 
+	if (qopt->base_time < 0)
+		return -ERANGE;
+
 	if (adapter->base_time)
 		return -EALREADY;
 
-- 
2.35.1




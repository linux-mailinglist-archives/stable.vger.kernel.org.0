Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7FF537D97
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiE3Nhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbiE3NgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55418980AA;
        Mon, 30 May 2022 06:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 700C360ECB;
        Mon, 30 May 2022 13:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10916C36AE7;
        Mon, 30 May 2022 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917381;
        bh=iKlBYoUEHHSKLj/FQ6yF2o4GA7+S+LJ6Nw0AmRb3NAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8p6XTvXh0WXJ9f/PefAaPKPMalSQ32+OQHURaqQXzabTmorEL5qVsZ/TpMHMg2aH
         vFPhm4jDpK90Dktytu+br8lIfAGtz/LlQbVdZtMRIzZEm+moh4xEc/bagEIcjqEDuC
         oPTs+CpgOhrf9WzkF3+aoiXU95PQneYTPPcjUuXTpM7RPSRcBh3AufHbkL4FdQwtaC
         dM/wV84cqYFOd05d4wu+I7jgYQWSsb8AeQ7p1dmgbIKKqgHKYk+aOXQ/Fe2NyLbng5
         WhHEoUhJWLkO3JPjxqUKNf3epN5VMubc1ng1iv8xuZvoHD61R7oOe9NyL1CBKNIyHB
         UGc73kGsarlng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 115/159] media: ccs-core.c: fix failure to call clk_disable_unprepare
Date:   Mon, 30 May 2022 09:23:40 -0400
Message-Id: <20220530132425.1929512-115-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit eca89cf60b040ee2cae693ea72a0364284f3084c ]

Fixes smatch warning:

drivers/media/i2c/ccs/ccs-core.c:1676 ccs_power_on() warn: 'sensor->ext_clk' from clk_prepare_enable() not released on lines: 1606.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 03e841b8443f..7ae469caf990 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -1602,8 +1602,11 @@ static int ccs_power_on(struct device *dev)
 			usleep_range(1000, 2000);
 		} while (--retry);
 
-		if (!reset)
-			return -EIO;
+		if (!reset) {
+			dev_err(dev, "software reset failed\n");
+			rval = -EIO;
+			goto out_cci_addr_fail;
+		}
 	}
 
 	if (sensor->hwcfg.i2c_addr_alt) {
-- 
2.35.1


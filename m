Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13293541527
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359594AbiFGU3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376913AbiFGU2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9F81D9B7A;
        Tue,  7 Jun 2022 11:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EF9160906;
        Tue,  7 Jun 2022 18:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA03C34115;
        Tue,  7 Jun 2022 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626807;
        bh=/Tu8r2LfOw0CLxiSZGrql0GLd6ZXzzDncyyTCP0+Lc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0nsFaSbehreYEB+AMSusmbOll+5m4X6QXfzmGeRXeruVMW0fmExAIqnIW7pWvWI7
         cST9s/GAXjPQdrqm1b3agAwwqiMCrLgfFc5iwrxQoEPZvvK2sI0LQnVyuEyx49qQFl
         wo315GaKw33XKuKrwmAQRDiz5MeeiDwanUfdLKYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 509/772] firmware: arm_ffa: Remove incorrect assignment of driver_data
Date:   Tue,  7 Jun 2022 19:01:41 +0200
Message-Id: <20220607165003.977213165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 00512d2930b338fdd42bd90bbd1793fe212c2d31 ]

The ffa core driver currently assigns its own driver information
to individual ffa device driver_data which is wrong. Firstly, it leaks
this core driver information to individual ffa_device and hence to
ffa_driver. Secondly the ffa_device driver_data is for use by individual
ffa_driver and not for this core driver managing all those devices.

Link: https://lore.kernel.org/r/20220429113946.2087145-2-sudeep.holla@arm.com
Fixes: d0c0bce83122 ("firmware: arm_ffa: Setup in-kernel users of FFA partitions")
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 8fa1785afd42..44300dbcc643 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -688,8 +688,6 @@ static void ffa_setup_partitions(void)
 			       __func__, tpbuf->id);
 			continue;
 		}
-
-		ffa_dev_set_drvdata(ffa_dev, drv_info);
 	}
 	kfree(pbuf);
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA08541C2B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377170AbiFGV4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384123AbiFGVyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0C4F8E60;
        Tue,  7 Jun 2022 12:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF2D1B81F6D;
        Tue,  7 Jun 2022 19:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23637C385A2;
        Tue,  7 Jun 2022 19:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629180;
        bh=/Tu8r2LfOw0CLxiSZGrql0GLd6ZXzzDncyyTCP0+Lc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHhDvd+7yuFUWMfch2ayVI20zK8G7C5YK1lgGShSHx4ma1nEMBVW+slhuMai6A326
         JWvCJdDLsrh5Jv4mbmCZQ4GZc7wmG7tQpOBBOFPfZ+8ciAWPJlNoxA5Awr+Lizn0Hm
         7gIptAl+nQr7qPa/cY0ECM6xH9LyB+2d5ESG/LEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 599/879] firmware: arm_ffa: Remove incorrect assignment of driver_data
Date:   Tue,  7 Jun 2022 19:01:57 +0200
Message-Id: <20220607165020.238670780@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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




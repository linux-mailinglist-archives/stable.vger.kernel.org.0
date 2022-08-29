Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E105A48B7
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiH2LO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiH2LNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:13:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB7E6FA19;
        Mon, 29 Aug 2022 04:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F106B80FA0;
        Mon, 29 Aug 2022 11:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD529C433C1;
        Mon, 29 Aug 2022 11:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771332;
        bh=6YiDygRTSeeoZVsPA2jsqa1DL2ai+NK4oW7uGgvyOoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIMwm8rRV7cNRIaXRfdrZHW7seWZcGQJlFzGfM2nG8yLZLR2BzmFqBIXmxpDOehMk
         R2HttuU8UOO9U28ye3op/sE1l1hoWFEq1pdmC+ZsgtbXBsiSnScXLsLAoQpbfgaYUy
         to94oCoNCF01ypEKeFElWHVo6qWYAFzQRaUVmGqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/136] ionic: fix up issues with handling EAGAIN on FW cmds
Date:   Mon, 29 Aug 2022 12:59:19 +0200
Message-Id: <20220829105808.442105569@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 0fc4dd452d6c14828eed6369155c75c0ac15bab3 ]

In looping on FW update tests we occasionally see the
FW_ACTIVATE_STATUS command fail while it is in its EAGAIN loop
waiting for the FW activate step to finsh inside the FW.  The
firmware is complaining that the done bit is set when a new
dev_cmd is going to be processed.

Doing a clean on the cmd registers and doorbell before exiting
the wait-for-done and cleaning the done bit before the sleep
prevents this from occurring.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 480f85bc17f99..9ede66842118f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -395,8 +395,8 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 				ionic_opcode_to_str(opcode), opcode,
 				ionic_error_to_str(err), err);
 
-			msleep(1000);
 			iowrite32(0, &idev->dev_cmd_regs->done);
+			msleep(1000);
 			iowrite32(1, &idev->dev_cmd_regs->doorbell);
 			goto try_again;
 		}
@@ -409,6 +409,8 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		return ionic_error_to_errno(err);
 	}
 
+	ionic_dev_cmd_clean(ionic);
+
 	return 0;
 }
 
-- 
2.35.1




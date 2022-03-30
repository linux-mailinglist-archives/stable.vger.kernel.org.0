Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88214EC13B
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244721AbiC3Lzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344348AbiC3Lw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:52:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8C3261307;
        Wed, 30 Mar 2022 04:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B03CB81ACC;
        Wed, 30 Mar 2022 11:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95C2C340EE;
        Wed, 30 Mar 2022 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640920;
        bh=SCgcK3ystEM4p5FUpeXZzCOdyVTPsuyCpDS+LaZ2TR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvR3zT7lBZQwvRUSnAxE1QUiT3KiDLekq2iTOVjyhIpFkC1Pjd6cXrbbaZ1d6dRiA
         CT/+0KxdfPicFyB29zXbT3+X22WKcFzW7ncpOUTJ4DJ3JnaOwIEpj2cGdfe7aLhqFB
         J5AHx0wucrLyk1d5ag5w2SjSknWkhZiExSe7C3o/MjV7joa1lgCbe45Vk736xfj89H
         WMeLSMaON4fO/zUDz6So1ms/dGPsMUdpxpfGQ20ZXXVtCtZ4AOWfgKKWLBwgWISoLw
         XTGt3rcpbJPUG9/S+0Ioae29uVHbnVdIhhax3WFcSVwI5o5L182RRvfn76UmzZXv2T
         hXlqCniLc5ojw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peiwei Hu <jlu.hpw@foxmail.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 05/59] media: ir_toy: free before error exiting
Date:   Wed, 30 Mar 2022 07:47:37 -0400
Message-Id: <20220330114831.1670235-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Peiwei Hu <jlu.hpw@foxmail.com>

[ Upstream commit 52cdb013036391d9d87aba5b4fc49cdfc6ea4b23 ]

Fix leak in error path.

Signed-off-by: Peiwei Hu <jlu.hpw@foxmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 7e98e7e3aace..196806709259 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -458,7 +458,7 @@ static int irtoy_probe(struct usb_interface *intf,
 	err = usb_submit_urb(irtoy->urb_in, GFP_KERNEL);
 	if (err != 0) {
 		dev_err(irtoy->dev, "fail to submit in urb: %d\n", err);
-		return err;
+		goto free_rcdev;
 	}
 
 	err = irtoy_setup(irtoy);
-- 
2.34.1


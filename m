Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E284EC238
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbiC3L6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiC3Lx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAD827F4CF;
        Wed, 30 Mar 2022 04:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A06615E7;
        Wed, 30 Mar 2022 11:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B213C340F3;
        Wed, 30 Mar 2022 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641013;
        bh=AI9DrVufi3MdEFjnhzkWMRlWnmYNO4xCFAbfcOkWUqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPKn0DXFHE8s+YQTqSppJt5KKD27UT8OXm5NjxoCe91IrXHiA8T+NUYNUo5F2Ueer
         9h55h15H7sAnZ8ko04cHEbsV7vn7Q9Nl8u3MOht7FA3hzI6x0tCsuFNTI3hepym7/d
         0zeD6wVcp6Q7yPV56zZUi/0iX7WoeUTIavQ74Tt1UJ9F/2UmkwoP0EdZ/PBdeZYhVF
         bWpVlcy+tpwa4+h1aMy3TziWdYfTXiZVQhShNr9mHWa3uG4xEC/wS28IUwGZxP+tpU
         qk8cIRdSaycKhplnMbkozomXVJeN9GB4xWtl3kJ5Om4o2eyB/WN+xAUj+GhFUDWJWy
         fV0t8EyJVMVOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peiwei Hu <jlu.hpw@foxmail.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/50] media: ir_toy: free before error exiting
Date:   Wed, 30 Mar 2022 07:49:19 -0400
Message-Id: <20220330115005.1671090-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
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
index 1aa7989e756c..7f394277478b 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -429,7 +429,7 @@ static int irtoy_probe(struct usb_interface *intf,
 	err = usb_submit_urb(irtoy->urb_in, GFP_KERNEL);
 	if (err != 0) {
 		dev_err(irtoy->dev, "fail to submit in urb: %d\n", err);
-		return err;
+		goto free_rcdev;
 	}
 
 	err = irtoy_setup(irtoy);
-- 
2.34.1


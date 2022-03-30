Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2E04EC015
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343809AbiC3Lsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343783AbiC3Lsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:48:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A154D25DAAF;
        Wed, 30 Mar 2022 04:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62EF7B81ACC;
        Wed, 30 Mar 2022 11:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77209C3411B;
        Wed, 30 Mar 2022 11:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640815;
        bh=SCgcK3ystEM4p5FUpeXZzCOdyVTPsuyCpDS+LaZ2TR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pntRx0ZeElGMfSNF4Yd1qRqISRN6bKWlFnDmMDjy4opXCAQi1FnYfEi/+Q/hDIpGt
         ViuOtaXDqKm+E8Bxgqj7wW9Ztr9N3795+8Rmf2tJH25b+1TmOwygjW1Ln/F/0Mz8vO
         tmSetsyOfXeSt8XJEG6E2kBw3+IsXxoA/IKaadsiFBTTxzDmPouEg4EVj6ipcgTiaa
         4qxqVAetVUJwBw5nZ8wvDWfPX3vYosRJbFkPplr5WqyVauPVsALLRMo+KYNIIU9E1D
         lezJSMy7Cf9hqKmBeDGDj3NY3jb93tm3HtgQn6KvnnaGLuvtwQqf6IMdzpZ9KYbxB1
         tuSlMSUDWhwMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peiwei Hu <jlu.hpw@foxmail.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 05/66] media: ir_toy: free before error exiting
Date:   Wed, 30 Mar 2022 07:45:44 -0400
Message-Id: <20220330114646.1669334-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
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


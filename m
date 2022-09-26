Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3343C5EA1C6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiIZK46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbiIZKzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:55:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B305A8BD;
        Mon, 26 Sep 2022 03:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFD6460AD6;
        Mon, 26 Sep 2022 10:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2265C433D6;
        Mon, 26 Sep 2022 10:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188153;
        bh=51LroLd0n2kkSnbQaeOumEoNu+EqencrziWglWY9DEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEyD/4sjFv4jq6SddX/BHab2GFb5Bo0Xl2miDloIr6ENyuoOoxPx4hE5RR9YbcReB
         wlSI9MSaaC6HxTINkdfOZVipEiovM0AoUqLAl4Knxu2KKBx7dNnlBXmq4GmDZnpoqz
         jSYFZi5+3QLwdEcRqF3doPeJKB2sp9szWSy7VWNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/141] usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer
Date:   Mon, 26 Sep 2022 12:10:53 +0200
Message-Id: <20220926100755.512020196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit d5dcc33677d7415c5f23b3c052f9e80cbab9ea4e ]

The TRB_SMM flag indicates that DMA has completed the TD service with
this TRB. Usually it’s a last TRB in TD. In case of ISOC transfer for
bInterval > 1 each ISOC transfer contains more than one TD associated
with usb request (one TD per ITP). In such case the TRB_SMM flag will
be set in every TD and driver will recognize the end of transfer after
processing the first TD with TRB_SMM. In result driver stops updating
request->actual and returns incorrect actual length.
To fix this issue driver additionally must check TRB_CHAIN which is not
used for isochronous transfers.

Fixes: 249f0a25e8be ("usb: cdns3: gadget: handle sg list use case at completion correctly")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20220825062207.5824-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index c6fc14b169da..d0d4de80680f 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1531,7 +1531,8 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
 						TRB_LEN(le32_to_cpu(trb->length));
 
 				if (priv_req->num_of_trb > 1 &&
-					le32_to_cpu(trb->control) & TRB_SMM)
+					le32_to_cpu(trb->control) & TRB_SMM &&
+					le32_to_cpu(trb->control) & TRB_CHAIN)
 					transfer_end = true;
 
 				cdns3_ep_inc_deq(priv_ep);
-- 
2.35.1




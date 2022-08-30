Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19E35A64DB
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiH3NeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiH3Nd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:33:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87335D7D04
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 142506132D
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 13:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32A7C433C1;
        Tue, 30 Aug 2022 13:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661866435;
        bh=g3h2+lsVoPRL5opMD5114knvaNtd187crM9frgl/KhQ=;
        h=Subject:To:From:Date:From;
        b=2ZJWrGWxQJ0gv65FhaCJUrzSir/j9DCOyqKnaj3wV3sO2//cyreqaM7yV3hXG09e6
         YxocK3ivzdNa7v76chaDojhjWdDLOzWiULdwsSTCHqw7yJtjPRFIp1UstJs+I36MV2
         W13p97rrQXQQb5nWFkHz9gr/qbJWNK+RBjv0CjWQ=
Subject: patch "usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 30 Aug 2022 15:33:41 +0200
Message-ID: <1661866421239145@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d5dcc33677d7415c5f23b3c052f9e80cbab9ea4e Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Thu, 25 Aug 2022 08:22:07 +0200
Subject: usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 drivers/usb/cdns3/cdns3-gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index d21b69997e75..4f11c311acaf 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1530,7 +1530,8 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
 						TRB_LEN(le32_to_cpu(trb->length));
 
 				if (priv_req->num_of_trb > 1 &&
-					le32_to_cpu(trb->control) & TRB_SMM)
+					le32_to_cpu(trb->control) & TRB_SMM &&
+					le32_to_cpu(trb->control) & TRB_CHAIN)
 					transfer_end = true;
 
 				cdns3_ep_inc_deq(priv_ep);
-- 
2.37.2



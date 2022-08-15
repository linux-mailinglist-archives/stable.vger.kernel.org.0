Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E7A594357
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347940AbiHOWWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349770AbiHOWVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:21:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B9FB5A55;
        Mon, 15 Aug 2022 12:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B77B80EA9;
        Mon, 15 Aug 2022 19:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14837C433D7;
        Mon, 15 Aug 2022 19:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592623;
        bh=qVsnoEGnc5qFPD1U5EZTUH1PL3z3jAHDLEAbNbMTyz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v12fKWm+5LN8Qq/hl1Grvfg8wQHNwWI6kCQNxocNic2gKiMeJLkf7Cu9/nskcvi/l
         78l2ISy9SjSSfcrR3mVBPeYZzHw7psUsDAL/GnLnQynS+STw9Fjv4FaIYJZ4tIwUzi
         cTaoa39DvE88B09CBDBFjPsqPKuV199AC7d0jjus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 5.19 0139/1157] usb: dwc3: gadget: fix high speed multiplier setting
Date:   Mon, 15 Aug 2022 19:51:35 +0200
Message-Id: <20220815180445.188777902@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 8affe37c525d800a2628c4ecfaed13b77dc5634a upstream.

For High-Speed Transfers the prepare_one_trb function is calculating the
multiplier setting for the trb based on the length parameter of the trb
currently prepared. This assumption is wrong. For trbs with a sg list,
the length of the actual request has to be taken instead.

Fixes: 40d829fb2ec6 ("usb: dwc3: gadget: Correct ISOC DATA PIDs for short packets")
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220704141812.1532306-3-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1264,10 +1264,10 @@ static void dwc3_prepare_one_trb(struct
 				unsigned int mult = 2;
 				unsigned int maxp = usb_endpoint_maxp(ep->desc);
 
-				if (trb_length <= (2 * maxp))
+				if (req->request.length <= (2 * maxp))
 					mult--;
 
-				if (trb_length <= maxp)
+				if (req->request.length <= maxp)
 					mult--;
 
 				trb->size |= DWC3_TRB_SIZE_PCM1(mult);



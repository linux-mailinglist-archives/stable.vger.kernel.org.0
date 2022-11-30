Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9463DFBB
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiK3SuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiK3Stz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42659FEC8
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70C4961B9D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818FEC433D6;
        Wed, 30 Nov 2022 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834193;
        bh=1D4f8fUU4CIABjMo6IeZN+Z7Fi+qbxtxwOrDsACa/W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=seKTX+t2haStO/buLAwqazguHfsTW3sazunjPM4gUJGorofLsLX3bXx39758ZlBHo
         AtvySVRJmeLZSCXDz9xTyynylBalsUSc+y2OOxS19Qs08IJ99Nl395HjZvJOueikVx
         7nhCPNq2uCq3e8ag/izTGWMAPY6tBazLjzBXom6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.0 163/289] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
Date:   Wed, 30 Nov 2022 19:22:28 +0100
Message-Id: <20221130180547.829165697@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit b25264f22b498dff3fa5c70c9bea840e83fff0d1 upstream.

During handling Clear Halt Endpoint Feature request, driver invokes
Reset Endpoint command. Because this command has some issue with
transition endpoint from Running to Idle state the driver must
stop the endpoint by using Stop Endpoint command.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20221110063005.370656-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |   12 ++++--------
 drivers/usb/cdns3/cdnsp-ring.c   |    3 ++-
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_dev
 
 	trace_cdnsp_ep_halt(value ? "Set" : "Clear");
 
-	if (value) {
-		ret = cdnsp_cmd_stop_ep(pdev, pep);
-		if (ret)
-			return ret;
+	ret = cdnsp_cmd_stop_ep(pdev, pep);
+	if (ret)
+		return ret;
 
+	if (value) {
 		if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_STOPPED) {
 			cdnsp_queue_halt_endpoint(pdev, pep->idx);
 			cdnsp_ring_cmd_db(pdev);
@@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_dev
 
 		pep->ep_state |= EP_HALTED;
 	} else {
-		/*
-		 * In device mode driver can call reset endpoint command
-		 * from any endpoint state.
-		 */
 		cdnsp_queue_reset_ep(pdev, pep->idx);
 		cdnsp_ring_cmd_db(pdev);
 		ret = cdnsp_wait_for_cmd_compl(pdev);
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2076,7 +2076,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_devic
 	u32 ep_state = GET_EP_CTX_STATE(pep->out_ctx);
 	int ret = 0;
 
-	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED) {
+	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED ||
+	    ep_state == EP_STATE_HALTED) {
 		trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
 		goto ep_stopped;
 	}



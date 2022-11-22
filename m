Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D87634095
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 16:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiKVPwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 10:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKVPwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 10:52:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B775FD2
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 07:52:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91EFBB81BF7
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 15:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7569C433D7;
        Tue, 22 Nov 2022 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669132351;
        bh=2OMw8YuS5yGTvGtiAq+EWYmKpcyflIK3A26etRQoHpU=;
        h=Subject:To:From:Date:From;
        b=0OEc4MvmOfq/O96JfN8jZS3bDvAW5O9gC7TuVkeJY5+8ES1HtwloQ9z24YAX5OJDl
         noKxT2n923lOpZAprxOnDc0+7dneWu5agW6g2MKdlASJCZXHysRFunRK3oaQkJkVb2
         0MXeYOiJbg4+yvrHpNfYQqoVSTLGYlMor7AkDJaQ=
Subject: patch "usb: cdnsp: Fix issue with Clear Feature Halt Endpoint" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Nov 2022 16:52:14 +0100
Message-ID: <16691323342819@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fix issue with Clear Feature Halt Endpoint

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b25264f22b498dff3fa5c70c9bea840e83fff0d1 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Thu, 10 Nov 2022 01:30:05 -0500
Subject: usb: cdnsp: Fix issue with Clear Feature Halt Endpoint

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
 drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++--------
 drivers/usb/cdns3/cdnsp-ring.c   |  3 ++-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index c67715f6f756..f9aa50ff14d4 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
 
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
@@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
 
 		pep->ep_state |= EP_HALTED;
 	} else {
-		/*
-		 * In device mode driver can call reset endpoint command
-		 * from any endpoint state.
-		 */
 		cdnsp_queue_reset_ep(pdev, pep->idx);
 		cdnsp_ring_cmd_db(pdev);
 		ret = cdnsp_wait_for_cmd_compl(pdev);
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 794e413800ae..04dfcaa08dc4 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2076,7 +2076,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep)
 	u32 ep_state = GET_EP_CTX_STATE(pep->out_ctx);
 	int ret = 0;
 
-	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED) {
+	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED ||
+	    ep_state == EP_STATE_HALTED) {
 		trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
 		goto ep_stopped;
 	}
-- 
2.38.1



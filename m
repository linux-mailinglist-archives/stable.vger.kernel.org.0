Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F97603827
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 04:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJSCjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 22:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJSCjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 22:39:10 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3CCE4E5D;
        Tue, 18 Oct 2022 19:39:10 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29INjnfi024169;
        Tue, 18 Oct 2022 19:39:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=dj9mD1bvepHzuV6Pg+BqbGv5Ek2OIjw1CCfN+3OxF+4=;
 b=D6ZPZF5LmjcykVTeOt+KWj9P2PsaML9m6ApywPBah2q99lHS/ZrJUcb59L23cGtOZZYe
 wYY7eWIF3VCyt0xpBMOPEtz+eQb1iXHFEFViuMOJWp++resoH4ToDLSMpLy4Fa/A5Q0t
 fh9kfhelQKVqh5jSePQ9fvzd9ycU0BJNkrje3b9LgAZMk+Nlc6UuEOQsGz6LTYcf6uwr
 5AWj7adZiDEvJd1SG9Ra6gd5N8PZvPidOB3CqMlxXl1tQ025x8Zh7eduYzLE/ZQqGO2W
 gHCYKu8UgFqHKK+IJhn2RTqyRvwwXgmVuJlCSxZ9GNJaVXU81cMoWRLCfl/dpRDh5SaF Kw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7uvncyty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 19:39:04 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 60FA7C00FA;
        Wed, 19 Oct 2022 02:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666147143; bh=tNelLWL7QXJkCEyzfBCRTxhNyWwWhSpAzVYCk1jL6aI=;
        h=Date:From:Subject:To:Cc:From;
        b=Y3VjDiT6Ho5dA1OfYMGrYr4UotoSP/OlIzKpFhRSrq7+mEog8O++NlKtQ/BO/HTS6
         kYjYFnv+FPdKnirlgzBaRBeeQUhS9H88B/ctiWg6MuwTNXhTsu9lqtMWL6xDoN+uXZ
         PUc6xEDHqcVCvVadl8A6tLgurpr3l/shlLMWgUKnUBLcr2N9d4Lyd0Hd/XB8oUEHdH
         uHxbIRb93dZTPzTbfqLE+QM8TKTguIDsEvrJ8jLnNzp9UvtKSBxY1pmoFNhdtC9Fmm
         RY75ceUzJYKiqPPwXXNffijFR7brY1PvDFXtoC+JWNn8mDw3flI57GkSwmAvbFGTFu
         /hbgsIiQS2aPw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 227CEA007F;
        Wed, 19 Oct 2022 02:39:02 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Tue, 18 Oct 2022 19:39:01 -0700
Date:   Tue, 18 Oct 2022 19:39:01 -0700
Message-Id: <3f9f59e5d74efcbaee444cf4b30ef639cc7b124e.1666146954.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2] usb: dwc3: gadget: Don't delay End Transfer on delayed_status
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>
Cc:     John Youn <John.Youn@synopsys.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
X-Proofpoint-ORIG-GUID: -XyR_I40rs6i-xJssBmBjdIY01ytCdmY
X-Proofpoint-GUID: -XyR_I40rs6i-xJssBmBjdIY01ytCdmY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_10,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210190013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The gadget driver may wait on the request completion when it sets the
USB_GADGET_DELAYED_STATUS. Make sure that the End Transfer command can
go through if the dwc->delayed_status is set so that the request can
complete. When the delayed_status is set, the Setup packet is already
processed, and the next phase should be either Data or Status. It's
unlikely that the host would cancel the control transfer and send a new
Setup packet during End Transfer command. But if that's the case, we can
try again when ep0state returns to EP0_SETUP_PHASE.

Fixes: e1ee843488d5 ("usb: dwc3: gadget: Force sending delayed status during soft disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 Changes in v2:
 - Fix build issue due to cherry-picking...

 drivers/usb/dwc3/gadget.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 079cd333632e..dd8ecbe61bec 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1698,6 +1698,16 @@ static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool int
 	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
 	memset(&params, 0, sizeof(params));
 	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	/*
+	 * If the End Transfer command was timed out while the device is
+	 * not in SETUP phase, it's possible that an incoming Setup packet
+	 * may prevent the command's completion. Let's retry when the
+	 * ep0state returns to EP0_SETUP_PHASE.
+	 */
+	if (ret == -ETIMEDOUT && dep->dwc->ep0state != EP0_SETUP_PHASE) {
+		dep->flags |= DWC3_EP_DELAY_STOP;
+		return 0;
+	}
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
@@ -3719,7 +3729,7 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
 	 * prepared.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
+	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return;
 	}

base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.28.0


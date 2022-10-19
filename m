Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C46037A0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 03:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJSBpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 21:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJSBpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 21:45:07 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D51A5280B;
        Tue, 18 Oct 2022 18:45:04 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29INjrlB004153;
        Tue, 18 Oct 2022 18:44:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=PY9z5u+IIp0AjMCL7fqPKYidMU1QKnim8kIkKGFmWJY=;
 b=ThEu9b7qO6rbzxVZZj1wHG+tzQwgLVmOhfNJH8wO02dLtaA8dAKd9xAXqe9Vnrncqy9q
 IP5X+6HAXleAZOpYIyTnNyXrQoPe9vfnT+2/BowppuuPVPM7Qlxup8n2f5/8Wl2tX/G3
 x8a+8nfIHU3Sxza2b+BuqZ7Ny1bgRNAIG4iwj161LiduAddL9R82RqYo3U/SgqFmZd0s
 QH+U8tKN2KRxUu/Vau4J+6IgvBbGQpYuIuHNBYoc4Xs3jdd80a9vPn5ugwIfbd26SXvx
 yDDZH/eGthzoA4TA0DEvKjmEyH2HACUzTnQat2wRsToRIRdI+CQ/cRNA1LaMcPfgYpE0 bw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7usuvu4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 18:44:57 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8FDD9400B4;
        Wed, 19 Oct 2022 01:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666143896; bh=ij1nw1XyiPn1tOxKJPdxHD3wEUwe64fph1HdAsBgq3M=;
        h=Date:From:Subject:To:Cc:From;
        b=CRQzaw0dtD3PydQXHgVmcxaxyqzZ2LhI7bJDS0xAOjz6jBxevgnFS5/36M62ye/KW
         LOXt18HnbhY8YO5N3eooLSZeS+aYoiYUprfcWb1HU+pQZdPF94KZtoXiSYRQJ8ViWl
         zU+maSx4QH+lbByNtTw4SiuPdaUKBO9UuOueTwG9pp0tdKNzXTOkgtQpwbq0d5QVSz
         v+xAVcUiGxV8jIDuIAQsox7YxUHKCOVyvNaBx2xHOCU4wZes+PZ1orrn/4xbk4lw82
         GF+pBuYWHBVze/plVOVbNwG77SswqAlldeFC2RvmpgY3039kV2aI+vWS4BKmiRC72H
         yzpEhQ4I1BqPA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 21A7CA007F;
        Wed, 19 Oct 2022 01:44:54 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Tue, 18 Oct 2022 18:44:54 -0700
Date:   Tue, 18 Oct 2022 18:44:54 -0700
Message-Id: <ab9600e9ea96d7eb94d23f9986c00b40903a95af.1666143657.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Don't delay End Transfer on delayed_status
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>
Cc:     John Youn <John.Youn@synopsys.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
X-Proofpoint-ORIG-GUID: gQ9Jj8VqnaFhQdr-TXFU5mP2QklZz2GA
X-Proofpoint-GUID: gQ9Jj8VqnaFhQdr-TXFU5mP2QklZz2GA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_10,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=933 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210190007
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
 drivers/usb/dwc3/gadget.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 079cd333632e..f4fe6ba3dd83 100644
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
+	if (ret == -ETIMEDOUT && dwc->ep0state != EP0_SETUP_PHASE) {
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


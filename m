Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6394B62B083
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 02:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiKPBZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 20:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiKPBZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 20:25:54 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4432A707;
        Tue, 15 Nov 2022 17:25:50 -0800 (PST)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AG1P9YW030685;
        Tue, 15 Nov 2022 17:25:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=sN6xRg1gGQcy+lcGu6LurD+0vKXQ6WrkwOSGjw06NDI=;
 b=MRZK0pF5oRoQMOrhCXnbqhTT6hvzjlffuniSM7LG2XCIj62ZejOI7I6UfIHRVh+n+oBu
 pRCOax1mak7T7brodeL0tXYRLObNquA0nH3+kr9RM7yacePlLG+PWH94lSBmC81+zVGf
 PhDjXoV8s8vu8OFabTRaumkcJTysCBJDTP0+sXolImIPP8r+AIAWcoJf0FRNfHgOqQf3
 5fQ4q8oCRPcbGzdGBFhB+txeWUrue0v/KRIAN15M2tOduUM9x8ZqJ38MicXy5+Siew1T
 oZ2/PoLrW+R/FTSw638PD+WVI6rbs4mkfwxjBdBEOeBeTRIbCVQ4itd7cCWbdM0Cg08Q UQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kvp6a801a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 17:25:14 -0800
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 895C9C082E;
        Wed, 16 Nov 2022 01:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1668561587; bh=Vkn2e1iD1zvr/Sp/hx/F26fC83fY0daJVNAzsV6WJEU=;
        h=Date:From:Subject:To:Cc:From;
        b=AANWRgP5dbCTyK8UT08IUxHp32bEedEWQaE62w5V9x0TTVGh54qSC0mUZa4NLPH/B
         XBW/V5BhQxS8G1F/A0glKK5PoiMQCPFdR96I79XXYmpiw6fGZYo+XG/LeiutV7vb41
         mOgbFsoLDpYH4rq1ktJDsKN0tYFJhwoCh7jRwQgxR8wfHqOh2RaofTltFLTLP3JS9W
         Zc6hiM1JgQCyZqKJ+UZuSyUmFldXKdisGvtPAFFnfhmKr96sCiJV+ao+bgpGX6hjN+
         V03VAWHceDTZd1eLoImVsgmeUBVNUBNIyrmYH0SCdgwRqAqQ1mapzkSZ5iqn0CigZM
         MLGEODQV5a2BA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id BCF97A007E;
        Wed, 16 Nov 2022 01:19:44 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Tue, 15 Nov 2022 17:19:43 -0800
Date:   Tue, 15 Nov 2022 17:19:43 -0800
Message-Id: <45db7c83b209259115bf652af210f8b2b3b1a383.1668561364.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Clear ep descriptor last
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable <stable@vger.kernel.org>
X-Proofpoint-ORIG-GUID: X8XtuBBAhFVX7gQ7tyWVnIjcQRaVnRxU
X-Proofpoint-GUID: X8XtuBBAhFVX7gQ7tyWVnIjcQRaVnRxU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 suspectscore=0
 lowpriorityscore=0 mlxlogscore=338 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211160008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Until the endpoint is disabled, its descriptors should remain valid.
When its requests are removed from ep disable, the request completion
routine may attempt to access the endpoint's descriptor. Don't clear the
descriptors before that.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 026d4029bda6..bfd8c1a5410a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1023,12 +1023,6 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	/* Clear out the ep descriptors for non-ep0 */
-	if (dep->number > 1) {
-		dep->endpoint.comp_desc = NULL;
-		dep->endpoint.desc = NULL;
-	}
-
 	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
@@ -1043,6 +1037,12 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		mask |= (DWC3_EP_DELAY_STOP | DWC3_EP_TRANSFER_STARTED);
 	dep->flags &= mask;
 
+	/* Clear out the ep descriptors for non-ep0 */
+	if (dep->number > 1) {
+		dep->endpoint.comp_desc = NULL;
+		dep->endpoint.desc = NULL;
+	}
+
 	return 0;
 }
 

base-commit: 181135bb20dcb184edd89817831b888eb8132741
-- 
2.28.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15F2647AF8
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 01:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIAuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 19:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLIAuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 19:50:50 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A26DA5056;
        Thu,  8 Dec 2022 16:50:49 -0800 (PST)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8NoQf2031204;
        Thu, 8 Dec 2022 16:50:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=NwxTP8BCUknxg0e/18KEFhJI5Ag2UYeYT3eMlESu0FE=;
 b=tfZW5JEEcqudOMMyo55egaKGQvhV9xmrdKGb7Jv7No5OwtwLe0BvRETSXYjchUJ847kT
 XUjlHgxUh6OKmqdrGpsa8DtbzGLyUGybnufOlncJS3wvWYxZ+uEqcgv1JVvfFD0RPQkB
 yAcSrlAQVRiMTY5ufPt22aXw0psX4ogHjV3hqcqtSbexJNVStqOqkCV9JTZBh6kMUsUj
 5ljdi9lwE8FECgFwXcdqYPEZ0sLfzOTCJucfMVzgYZij8M8+x9M0MST0JsnJDYbu8eYV
 N64XusmMJWUKv9J5U+SwgZ9Rg71Cuwt6YN5kNwxR3P2mnIavhv1kcEZ+o8di1/GwVC6H aA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3m86bt41pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 16:50:38 -0800
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4E262C00B5;
        Fri,  9 Dec 2022 00:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1670547037; bh=EnNPRA5kDPL/NdNJEzZZK4h6K/E8moDCzW1UXkmCfuQ=;
        h=Date:From:Subject:To:Cc:From;
        b=iU+zb57eH7iXJivxv0Kwkyz7e86FvNALzXJt1aBIVk8Y9I14ZYtpK8MgL1BhGf2ZJ
         ETrZWGrgG+t+k7FKp0rQZOGvEqwWgp+pyyGOYqcQw7mEe1KlyZ0+7Ezj8LcU7H/HCP
         WUdQrmsr8xhS5n2wARQY57H+dn722CSj68y4kO6auwauq7sGDzpd/j4rS9MwbKkvxp
         yfAHcnvhwGQBtuGIgAhQ59ReLB5wId8TlO5MIVqfC9JlfY5Y+ed4ewWp2nXAHOhzeS
         lXNiRU9flw3FHxZYVdfAWtYWqG4jwWH7RbLZ7LyGrBYBR0SrwOGmZie6fD8NRucdo5
         QloB3KZcnUfYw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 811CAA0073;
        Fri,  9 Dec 2022 00:50:35 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Thu, 08 Dec 2022 16:50:35 -0800
Date:   Thu, 08 Dec 2022 16:50:35 -0800
Message-Id: <f1617a323e190b9cc408fb8b65456e32b5814113.1670546756.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Ignore End Transfer delay on teardown
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Dan Scally <dan.scally@ideasonboard.com>
X-Proofpoint-ORIG-GUID: brbFyxB85t1UzdkS6Qi8xuwsPyuUZ-hE
X-Proofpoint-GUID: brbFyxB85t1UzdkS6Qi8xuwsPyuUZ-hE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_12,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 clxscore=1015 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=726 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212090005
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we delay sending End Transfer for Setup TRB to be prepared, we need
to check if the End Transfer was in preparation for a driver
teardown/soft-disconnect. In those cases, just send the End Transfer
command without delay.

In the case of soft-disconnect, there's a very small chance the command
may not go through immediately. But should it happen, the Setup TRB will
be prepared during the polling of the controller halted state, allowing
the command to go through then.

In the case of disabling endpoint due to reconfiguration (e.g.
set_interface(alt-setting) or usb reset), then it's driven by the host.
Typically the host wouldn't immediately cancel the control request and
send another control transfer to trigger the End Transfer command
timeout.

Fixes: 4db0fbb60136 ("usb: dwc3: gadget: Don't delay End Transfer on delayed_status")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 789976567f9f..89dcfac01235 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1727,6 +1727,7 @@ static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool int
 	else if (!ret)
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
 
+	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	return ret;
 }
 
@@ -3732,8 +3733,10 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	if (dep->number <= 1 && dwc->ep0state != EP0_DATA_PHASE)
 		return;
 
+	if (interrupt && (dep->flags & DWC3_EP_DELAY_STOP))
+		return;
+
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
-	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
 

base-commit: 81c25247a2a03a0f97e4805d7aff7541ccff6baa
-- 
2.28.0


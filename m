Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C00C6206EF
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 03:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiKHCqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 21:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKHCp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 21:45:57 -0500
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4462E6AC;
        Mon,  7 Nov 2022 18:45:56 -0800 (PST)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A82C8we023278;
        Mon, 7 Nov 2022 18:45:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=TqzLKH76Zqq6Q5Rw+ueeiEiqiFsefTQugN9X6IWAGEU=;
 b=vVamYg0khl4AGnYtsQDgeRm/hF/Qf2To/t8pkT1/M1nbVni6e5XyBIeC00gtb5bmywSv
 4DPdHKmPPcbZjaGuS+vZzlqy/l1a5XDapVA+DVz/PQvQ5ZI5PCmn0+cZW++KTEpRLwYc
 x4CdxkOvrM7FhmBDbZstBTIHPhn3mQheYnuvVKRU8zB0Z/uiKbEti8qDSKo0Pr6HvLqw
 YYRyBYnfS3iPsyQ9lCEPJ4unUtYFhA2yOgjw/kPaR7XVcHFBSlR57Y0jQJKMQvKWIu8U
 ygwSLug+lMPOs7cf2DTk0KH1xAMo6jZP5CamzBY48+UGAk4BiOXh1yGjvDDhm7KuqCim Dg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3knprukrmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 18:45:47 -0800
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 335B940133;
        Tue,  8 Nov 2022 02:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1667875546; bh=NFW5CphxACF8dTMW7zJzXJW7DfXWvvU2QzJ2c92fsvY=;
        h=Date:From:Subject:To:Cc:From;
        b=aBQ9VpIwZmnyjKuFHRPYruofY43hC51Tc/UFeG0AKywjxrC+SYDfZxuFsVdm4e+vy
         Wl0+NHxME+Cw/+T6wFPegCkqK/xj7O/LyXmEqe6KDfzm0Lih9oHH6oRB1B5Dw8n5cd
         gNpl7p4o5rHaDHc7IuyXAC38n/rVrudkSbV7FdYswlZZ73DwLmdVdlk3qZtqBjujcb
         icKdTMveQ1WSno2Jx+YrzkeN3NpIcATyF91ih6Fkn7i8zA3L10qZP6UbMYYEO9jtCU
         IQnmBQCt8F1eGbjQx9GlQNZpVGBTyiI9dup3ySDwbUTyUAa99diGds8Ts3axWg4RnB
         /gYQcwR38XSmw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 6EF58A00B6;
        Tue,  8 Nov 2022 02:45:44 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 07 Nov 2022 18:45:44 -0800
Date:   Mon, 07 Nov 2022 18:45:44 -0800
Message-Id: <3421859485cb32d77e2068549679a6c07a7797bc.1667875427.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Return -ESHUTDOWN on ep disable
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
X-Proofpoint-ORIG-GUID: vQJbCgciC6XR47Z9tbzPNObC6F2J-pBk
X-Proofpoint-GUID: vQJbCgciC6XR47Z9tbzPNObC6F2J-pBk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0 mlxlogscore=612
 lowpriorityscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The usb_request API clearly noted that removed requests due to disabled
endpoint should have -ESHUTDOWN status returned. Don't change this
behavior.

Fixes: b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
Note: Patch revert have conflicts, so let's do this instead of a revert.

 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5fe2d136dff5..026d4029bda6 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1029,7 +1029,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
-	dwc3_remove_requests(dwc, dep, -ECONNRESET);
+	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
 	dep->type = 0;

base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.28.0


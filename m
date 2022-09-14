Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0EE5B7ECE
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 04:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiINCDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 22:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiINCDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 22:03:46 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C826F58F
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 19:03:45 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28E0tKBY016295;
        Wed, 14 Sep 2022 02:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=2v2kb1HQ7RRYdlWUY6l/FY0+5Hsh7ZKaxKkZocx29ek=;
 b=iUWKWmEPwrnfZ9JAbnEUNSjj4t8MtrCr7pxtoYxsahPPwFtMWj0yGtX2B8FkNwykYODP
 PrNkzY+QMfo4B5gKquLz2fH5+4UirkhZ7gywgIcYlFtGXeCVB8GanoH6dtmcT9zgRdK3
 3oGyH/ZK6NwOS7aTHcYwnr/mSUrYcKfdpMAxaMsP5sWumgtP6By/15kLmDLoL0nGcL10
 yHo83N7ptR75PUNQN5/qRsCD9oc/Aw2RJcUmqcfXFULZvluguOg6c9ZqOXKgsiTrne6b
 yRygSfO9BQce0WssaSE6rqFjgSSKn32YKsyMcPgG4EhkKhWg8r/pXc8OCWJIfaqw11x8 cg== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjy0b8qct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 02:03:40 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28E23drv001325
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 02:03:39 GMT
Received: from jackp-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 13 Sep 2022 19:03:38 -0700
From:   Jack Pham <quic_jackp@quicinc.com>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Jing Leng <jleng@ambarella.com>, stable <stable@kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>
Subject: [PATCH 5.15 2/2] usb: gadget: f_uac2: fix superspeed transfer
Date:   Tue, 13 Sep 2022 19:03:13 -0700
Message-ID: <20220914020313.3187-2-quic_jackp@quicinc.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20220914020313.3187-1-quic_jackp@quicinc.com>
References: <20220914020313.3187-1-quic_jackp@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: _ek8aFKVhUT9lv0eBnfAkeTugLKBANxo
X-Proofpoint-ORIG-GUID: _ek8aFKVhUT9lv0eBnfAkeTugLKBANxo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_12,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=616
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140008
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Leng <jleng@ambarella.com>

commit f511aef2ebe5377d4c263842f2e0c0b8e274e8e5 upstream.

On page 362 of the USB3.2 specification (
https://usb.org/sites/default/files/usb_32_20210125.zip),
The 'SuperSpeed Endpoint Companion Descriptor' shall only be returned
by Enhanced SuperSpeed devices that are operating at Gen X speed.
Each endpoint described in an interface is followed by a 'SuperSpeed
Endpoint Companion Descriptor'.

If users use SuperSpeed UDC, host can't recognize the device if endpoint
doesn't have 'SuperSpeed Endpoint Companion Descriptor' followed.

Currently in the uac2 driver code:
1. ss_epout_desc_comp follows ss_epout_desc;
2. ss_epin_fback_desc_comp follows ss_epin_fback_desc;
3. ss_epin_desc_comp follows ss_epin_desc;
4. Only ss_ep_int_desc endpoint doesn't have 'SuperSpeed Endpoint
Companion Descriptor' followed, so we should add it.

Fixes: eaf6cbe09920 ("usb: gadget: f_uac2: add volume and mute support")
Cc: stable <stable@kernel.org>
Signed-off-by: Jing Leng <jleng@ambarella.com>
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
Link: https://lore.kernel.org/r/20220721014815.14453-1-quic_jackp@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
---
 drivers/usb/gadget/function/f_uac2.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 4072cde4f0c9..885a7f593d85 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -281,6 +281,12 @@ static struct usb_endpoint_descriptor ss_ep_int_desc = {
 	.bInterval = 4,
 };
 
+static struct usb_ss_ep_comp_descriptor ss_ep_int_desc_comp = {
+	.bLength = sizeof(ss_ep_int_desc_comp),
+	.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
+	.wBytesPerInterval = cpu_to_le16(6),
+};
+
 /* Audio Streaming OUT Interface - Alt0 */
 static struct usb_interface_descriptor std_as_out_if0_desc = {
 	.bLength = sizeof std_as_out_if0_desc,
@@ -594,7 +600,8 @@ static struct usb_descriptor_header *ss_audio_desc[] = {
 	(struct usb_descriptor_header *)&in_feature_unit_desc,
 	(struct usb_descriptor_header *)&io_out_ot_desc,
 
-  (struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc_comp,
 
 	(struct usb_descriptor_header *)&std_as_out_if0_desc,
 	(struct usb_descriptor_header *)&std_as_out_if1_desc,
@@ -721,6 +728,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 	struct usb_ss_ep_comp_descriptor *epout_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_fback_desc_comp = NULL;
+	struct usb_ss_ep_comp_descriptor *ep_int_desc_comp = NULL;
 	struct usb_endpoint_descriptor *epout_desc;
 	struct usb_endpoint_descriptor *epin_desc;
 	struct usb_endpoint_descriptor *epin_fback_desc;
@@ -748,6 +756,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 		epin_fback_desc = &ss_epin_fback_desc;
 		epin_fback_desc_comp = &ss_epin_fback_desc_comp;
 		ep_int_desc = &ss_ep_int_desc;
+		ep_int_desc_comp = &ss_ep_int_desc_comp;
 	}
 
 	i = 0;
@@ -776,8 +785,11 @@ static void setup_headers(struct f_uac2_opts *opts,
 	if (EPOUT_EN(opts))
 		headers[i++] = USBDHDR(&io_out_ot_desc);
 
-	if (FUOUT_EN(opts) || FUIN_EN(opts))
+	if (FUOUT_EN(opts) || FUIN_EN(opts)) {
 		headers[i++] = USBDHDR(ep_int_desc);
+		if (ep_int_desc_comp)
+			headers[i++] = USBDHDR(ep_int_desc_comp);
+	}
 
 	if (EPOUT_EN(opts)) {
 		headers[i++] = USBDHDR(&std_as_out_if0_desc);
-- 
2.24.0


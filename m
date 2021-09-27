Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB04198AF
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 18:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhI0QQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 12:16:10 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:29487 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235315AbhI0QQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 12:16:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632759270; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=6YTmKUwFqR+9Nk+RNyu4Wg+QL+GPDNenVjMrbE8By7k=; b=kwQn2tF3EbOVvYzdOlVmnczMT6DGWyWAAEg8YKvKniM/fbNvKSf4oO7z6PQ4fgsIG7fVZPzW
 400kPqtamJeUw7RxR8pzlDnPalzV3JZOPfqtk8xacBgNbFvtRUtbdOmFFbFUFTqjYB9/pY50
 EMzmBbXPANO2sUgTOAwJeGylGsw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 6151edae3cc3a01f266572f0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 27 Sep 2021 16:13:34
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 942A9C4360D; Mon, 27 Sep 2021 16:13:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DFC93C4338F;
        Mon, 27 Sep 2021 16:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org DFC93C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Jack Pham <jackp@codeaurora.org>
To:     stable@vger.kernel.org
Cc:     Jack Pham <jackp@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable-5.14 1/2] usb: gadget: f_uac2: Add missing companion descriptor for feedback EP
Date:   Mon, 27 Sep 2021 09:12:52 -0700
Message-Id: <20210927161253.10977-1-jackp@codeaurora.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 595091a1426a3b2625dad322f69fe569dc9d8943 upstream.

The f_uac2 function fails to enumerate when connected in SuperSpeed
due to the feedback endpoint missing the companion descriptor.
Add a new ss_epin_fback_desc_comp descriptor and append it behind the
ss_epin_fback_desc both in the static definition of the ss_audio_desc
structure as well as its dynamic construction in setup_headers().

Fixes: 24f779dac8f3 ("usb: gadget: f_uac2/u_audio: add feedback endpoint support")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210909174811.12534-2-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jackp: Backport to 5.14 with minor conflict resolution]
Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
 drivers/usb/gadget/function/f_uac2.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index ae29ff2b2b68..0bc3e68cae31 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -348,6 +348,14 @@ static struct usb_endpoint_descriptor ss_epin_fback_desc = {
 	.bInterval = 4,
 };
 
+static struct usb_ss_ep_comp_descriptor ss_epin_fback_desc_comp = {
+	.bLength		= sizeof(ss_epin_fback_desc_comp),
+	.bDescriptorType	= USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst		= 0,
+	.bmAttributes		= 0,
+	.wBytesPerInterval	= cpu_to_le16(4),
+};
+
 
 /* Audio Streaming IN Interface - Alt0 */
 static struct usb_interface_descriptor std_as_in_if0_desc = {
@@ -527,6 +535,7 @@ static struct usb_descriptor_header *ss_audio_desc[] = {
 	(struct usb_descriptor_header *)&ss_epout_desc_comp,
 	(struct usb_descriptor_header *)&as_iso_out_desc,
 	(struct usb_descriptor_header *)&ss_epin_fback_desc,
+	(struct usb_descriptor_header *)&ss_epin_fback_desc_comp,
 
 	(struct usb_descriptor_header *)&std_as_in_if0_desc,
 	(struct usb_descriptor_header *)&std_as_in_if1_desc,
@@ -604,6 +613,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 {
 	struct usb_ss_ep_comp_descriptor *epout_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_desc_comp = NULL;
+	struct usb_ss_ep_comp_descriptor *epin_fback_desc_comp = NULL;
 	struct usb_endpoint_descriptor *epout_desc;
 	struct usb_endpoint_descriptor *epin_desc;
 	struct usb_endpoint_descriptor *epin_fback_desc;
@@ -626,6 +636,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 		epout_desc_comp = &ss_epout_desc_comp;
 		epin_desc_comp = &ss_epin_desc_comp;
 		epin_fback_desc = &ss_epin_fback_desc;
+		epin_fback_desc_comp = &ss_epin_fback_desc_comp;
 	}
 
 	i = 0;
@@ -654,8 +665,11 @@ static void setup_headers(struct f_uac2_opts *opts,
 
 		headers[i++] = USBDHDR(&as_iso_out_desc);
 
-		if (EPOUT_FBACK_IN_EN(opts))
+		if (EPOUT_FBACK_IN_EN(opts)) {
 			headers[i++] = USBDHDR(epin_fback_desc);
+			if (epin_fback_desc_comp)
+				headers[i++] = USBDHDR(epin_fback_desc_comp);
+		}
 	}
 	if (EPIN_EN(opts)) {
 		headers[i++] = USBDHDR(&std_as_in_if0_desc);
-- 
2.24.0


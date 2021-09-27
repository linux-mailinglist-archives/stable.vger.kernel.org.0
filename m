Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97074198AE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhI0QPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 12:15:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:29487 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235370AbhI0QPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 12:15:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632759252; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=+Ot7E9V3VT48Lq4tZNpJsBObPu9ec6wxQbM7PTAqefA=; b=e9kJgBs2T/AOuN9QCEkAffj+yg0iMHSV0/5c/iFvy2R4B3bm2/Hia/MqvFPoOrab352WsIIT
 ztXP/Sp48cd3a1ziT09dhDfMz7XiUFgBtlq3Wg9dW0g77X/9fH+UV9o81I7yDH4uDl1OsU9P
 dbgFJl8RRwzVKPxBb643MvmpepE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6151edb3a5a9bab6e87dea2f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 27 Sep 2021 16:13:39
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E72A4C43460; Mon, 27 Sep 2021 16:13:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4E151C4338F;
        Mon, 27 Sep 2021 16:13:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 4E151C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Jack Pham <jackp@codeaurora.org>
To:     stable@vger.kernel.org
Cc:     Jack Pham <jackp@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable-5.14 2/2] usb: gadget: f_uac2: Populate SS descriptors' wBytesPerInterval
Date:   Mon, 27 Sep 2021 09:12:53 -0700
Message-Id: <20210927161253.10977-2-jackp@codeaurora.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20210927161253.10977-1-jackp@codeaurora.org>
References: <20210927161253.10977-1-jackp@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f0e8a206a2a53a919e1709c654cb65d519f7befb upstream.

For Isochronous endpoints, the SS companion descriptor's
wBytesPerInterval field is required to reserve bus time in order
to transmit the required payload during the service interval.
If left at 0, the UAC2 function is unable to transact data on its
playback or capture endpoints in SuperSpeed mode.

Since f_uac2 currently does not support any bursting this value can
be exactly equal to the calculated wMaxPacketSize.

Tested with Windows 10 as a host.

Fixes: f8cb3d556be3 ("usb: f_uac2: adds support for SS and SSP")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210909174811.12534-3-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jackp: Backport to 5.14 with minor conflict resolution]
Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
 drivers/usb/gadget/function/f_uac2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 0bc3e68cae31..37c94031af1e 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -951,6 +951,9 @@ afunc_bind(struct usb_configuration *cfg, struct usb_function *fn)
 	agdev->out_ep_maxpsize = max_t(u16, agdev->out_ep_maxpsize,
 				le16_to_cpu(ss_epout_desc.wMaxPacketSize));
 
+	ss_epin_desc_comp.wBytesPerInterval = ss_epin_desc.wMaxPacketSize;
+	ss_epout_desc_comp.wBytesPerInterval = ss_epout_desc.wMaxPacketSize;
+
 	hs_epout_desc.bEndpointAddress = fs_epout_desc.bEndpointAddress;
 	hs_epin_fback_desc.bEndpointAddress = fs_epin_fback_desc.bEndpointAddress;
 	hs_epin_desc.bEndpointAddress = fs_epin_desc.bEndpointAddress;
-- 
2.24.0


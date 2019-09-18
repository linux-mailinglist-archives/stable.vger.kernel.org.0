Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8CDB5CBB
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfIRG1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbfIRG1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42ECE21927;
        Wed, 18 Sep 2019 06:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788019;
        bh=+T3wbGfUfO1KDJmhoXMvj8J+SomGDiGX9P1fUHrAiHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cD+ORg+rja2/2ZJ+q4BDg8YcVRUb3T9zY+a+stxnuDSk7XJhbq7vrAXGLDNM6RD3Z
         8/6tN7z8rFOiWLT0LiMsNglHvokn6XTyJd3iJcsbZwoj0cvLr5NxofPbwwLlEGu3J0
         HIHUgR4ymBFcyYSKCaU02aKYiJ2hHpqQ/eh8EIoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Andrew F. Davis" <afd@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Alejandro Hernandez <ajhernandez@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: [PATCH 5.2 69/85] firmware: ti_sci: Always request response from firmware
Date:   Wed, 18 Sep 2019 08:19:27 +0200
Message-Id: <20190918061237.594658723@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew F. Davis <afd@ti.com>

commit 66f030eac257a572fbedab3d9646d87d647351fd upstream.

TI-SCI firmware will only respond to messages when the
TI_SCI_FLAG_REQ_ACK_ON_PROCESSED flag is set. Most messages already do
this, set this for the ones that do not.

This will be enforced in future firmware that better match the TI-SCI
specifications, this patch will not break users of existing firmware.

Fixes: aa276781a64a ("firmware: Add basic support for TI System Control Interface (TI-SCI) protocol")
Signed-off-by: Andrew F. Davis <afd@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Tested-by: Alejandro Hernandez <ajhernandez@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/ti_sci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/firmware/ti_sci.c
+++ b/drivers/firmware/ti_sci.c
@@ -466,9 +466,9 @@ static int ti_sci_cmd_get_revision(struc
 	struct ti_sci_xfer *xfer;
 	int ret;
 
-	/* No need to setup flags since it is expected to respond */
 	xfer = ti_sci_get_one_xfer(info, TI_SCI_MSG_VERSION,
-				   0x0, sizeof(struct ti_sci_msg_hdr),
+				   TI_SCI_FLAG_REQ_ACK_ON_PROCESSED,
+				   sizeof(struct ti_sci_msg_hdr),
 				   sizeof(*rev_info));
 	if (IS_ERR(xfer)) {
 		ret = PTR_ERR(xfer);
@@ -596,9 +596,9 @@ static int ti_sci_get_device_state(const
 	info = handle_to_ti_sci_info(handle);
 	dev = info->dev;
 
-	/* Response is expected, so need of any flags */
 	xfer = ti_sci_get_one_xfer(info, TI_SCI_MSG_GET_DEVICE_STATE,
-				   0, sizeof(*req), sizeof(*resp));
+				   TI_SCI_FLAG_REQ_ACK_ON_PROCESSED,
+				   sizeof(*req), sizeof(*resp));
 	if (IS_ERR(xfer)) {
 		ret = PTR_ERR(xfer);
 		dev_err(dev, "Message alloc failed(%d)\n", ret);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62978B5D0C
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfIRGXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbfIRGXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BB6E21925;
        Wed, 18 Sep 2019 06:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787802;
        bh=Pp3nDBeY+qGfyEIy4vUl2zcr6NCJzZ1+TtephsJC88o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A59puAEGe7AnZRjB6wk9eS2qy8QAl5Df+3hIEYVxpDQZHCkSWq7HWIAMh99yvVZvq
         6YZ0W5HwmoCHTS+UgHKHZKQq6gEkd6xGqeuzv9/ns7QlFGk1DNbTi+FD1CuJwhLhQb
         To1CbLBWAfzg2iT6Z3rXVeaid+y5RKUElr5m8blI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Andrew F. Davis" <afd@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Alejandro Hernandez <ajhernandez@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: [PATCH 4.19 40/50] firmware: ti_sci: Always request response from firmware
Date:   Wed, 18 Sep 2019 08:19:23 +0200
Message-Id: <20190918061227.800697762@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
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
@@ -463,9 +463,9 @@ static int ti_sci_cmd_get_revision(struc
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
@@ -593,9 +593,9 @@ static int ti_sci_get_device_state(const
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



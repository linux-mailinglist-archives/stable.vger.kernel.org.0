Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A19C5AEC4C
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbiIFOUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242074AbiIFOTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:19:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA578A7EC;
        Tue,  6 Sep 2022 06:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D743B81633;
        Tue,  6 Sep 2022 13:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E86C433C1;
        Tue,  6 Sep 2022 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662472155;
        bh=6DAkq7iQ7tCJ0q+KIEGziZiVYdN2cdYJzvu00FR63+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7l4tHfYjRRsaGsGKdGNTEUVgkqsBJVMsH8qe6Fv+SjWp8+mkH8k+Nmo24nyK0I5Q
         NxEGEbprW/hJ1q2Gzhos9p6Tw6VLVgtdGik8TLh34mapDljG/3ikPSCe2hOMCFQQTu
         xa0RigwIdZwM6c2665Dmo09QYZ7INkRPhtDpIM2yXLvYsl2BdviN30K8thX6OaiBRy
         qaGfKFpbKqq5WfS3e5Xw7bVXEyosKsLLsH8fPw/XUvfCaxNT/5YI3nP6UwtXtF1hyZ
         5Y5HB456uP1+fKoZRg9Vt9CXpHK5YnjpKGCyELUgRDO7WcooUP6/vmZchC907vTjzw
         mDR+FLnMH2Flg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVYx5-00050V-Ij; Tue, 06 Sep 2022 15:49:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Subject: [PATCH stable-4.19 3/4] USB: serial: ch341: fix lost character on LCR updates
Date:   Tue,  6 Sep 2022 15:49:14 +0200
Message-Id: <20220906134915.19225-4-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906134915.19225-1-johan@kernel.org>
References: <20220906134915.19225-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8e83622ae7ca481c76c8fd9579877f6abae64ca2 upstream.

Disable LCR updates for pre-0x30 devices which use a different (unknown)
protocol for line control and where the current register write causes
the next received character to be lost.

Note that updating LCR using the INIT command has no effect on these
devices either.

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Tested-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
Fixes: 55fa15b5987d ("USB: serial: ch341: fix baud rate and line-control handling")
Cc: stable@vger.kernel.org      # 4.10
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: adjust context to 4.19 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index f789b60ed8c1..58b5fd95b29f 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -96,6 +96,8 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
+	u8 version;
 };
 
 static void ch341_set_termios(struct tty_struct *tty,
@@ -181,6 +183,9 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	if (r)
 		return r;
 
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 0x2518, lcr);
 	if (r)
 		return r;
@@ -232,7 +237,9 @@ static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
 	r = ch341_control_in(dev, CH341_REQ_READ_VERSION, 0, 0, buffer, size);
 	if (r < 0)
 		goto out;
-	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", buffer[0]);
+
+	priv->version = buffer[0];
+	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", priv->version);
 
 	r = ch341_control_out(dev, CH341_REQ_SERIAL_INIT, 0, 0);
 	if (r < 0)
-- 
2.35.1


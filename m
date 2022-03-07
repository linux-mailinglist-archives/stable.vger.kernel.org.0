Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D054CF78C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbiCGJqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241177AbiCGJl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2D1DE8A;
        Mon,  7 Mar 2022 01:41:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98ABFB810C6;
        Mon,  7 Mar 2022 09:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA89FC340E9;
        Mon,  7 Mar 2022 09:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645763;
        bh=stdlv2J1UkzSjlsuBLGDoszBpm+lXxb2VHMR9D1vs1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCK73jG/EYtxYCdpOSeHC9GVTZLgqKZuL76YENH5zteWdtNGLKrypV2ZaHVyWwtXK
         6zWX8ls1sxetRwcq0lbVawA7HwuvYnMNpnE3Jgxm1cjOFM8K2YomKLo9pI9R19R0Fp
         gQhWEyIHAsjsl/wJZ4RJREAX05iwOjUnigTSy8HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 5.15 028/262] usb: gadget: clear related members when goto fail
Date:   Mon,  7 Mar 2022 10:16:12 +0100
Message-Id: <20220307091703.163852605@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit 501e38a5531efbd77d5c73c0ba838a889bfc1d74 upstream.

dev->config and dev->hs_config and dev->dev need to be cleaned if
dev_config fails to avoid UAF.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211231172138.7993-3-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1878,8 +1878,8 @@ dev_config (struct file *fd, const char
 
 	value = usb_gadget_probe_driver(&gadgetfs_driver);
 	if (value != 0) {
-		kfree (dev->buf);
-		dev->buf = NULL;
+		spin_lock_irq(&dev->lock);
+		goto fail;
 	} else {
 		/* at this point "good" hardware has for the first time
 		 * let the USB the host see us.  alternatively, if users
@@ -1896,6 +1896,9 @@ dev_config (struct file *fd, const char
 	return value;
 
 fail:
+	dev->config = NULL;
+	dev->hs_config = NULL;
+	dev->dev = NULL;
 	spin_unlock_irq (&dev->lock);
 	pr_debug ("%s: %s fail %zd, %p\n", shortname, __func__, value, dev);
 	kfree (dev->buf);



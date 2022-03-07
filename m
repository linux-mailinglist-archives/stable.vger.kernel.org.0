Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61144CF62D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbiCGJd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbiCGJdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:33:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBEB62112;
        Mon,  7 Mar 2022 01:29:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC7A361140;
        Mon,  7 Mar 2022 09:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B492DC340E9;
        Mon,  7 Mar 2022 09:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645394;
        bh=jo5Gvut9YDqJqTgsI46hJz07obo5/+wBj08YYrZKZRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoA8FZ/w/NVlt0FyWrMbaZEXOUA4TNiPxhR5p6l8dcaMw4mnROfjMpW7wvJhV3j1A
         CSI2gEbYU9Q3wJdLxXUGHVMdbVaT/4F8rdRGXJeYkpeySKWgUk8yXRgr9feeA6LsLN
         mqoDJObYtHrbexYeTxVPj7T1EJt/1IJ8BMkIUTOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 5.10 017/105] usb: gadget: clear related members when goto fail
Date:   Mon,  7 Mar 2022 10:18:20 +0100
Message-Id: <20220307091644.668479890@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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
@@ -1877,8 +1877,8 @@ dev_config (struct file *fd, const char
 
 	value = usb_gadget_probe_driver(&gadgetfs_driver);
 	if (value != 0) {
-		kfree (dev->buf);
-		dev->buf = NULL;
+		spin_lock_irq(&dev->lock);
+		goto fail;
 	} else {
 		/* at this point "good" hardware has for the first time
 		 * let the USB the host see us.  alternatively, if users
@@ -1895,6 +1895,9 @@ dev_config (struct file *fd, const char
 	return value;
 
 fail:
+	dev->config = NULL;
+	dev->hs_config = NULL;
+	dev->dev = NULL;
 	spin_unlock_irq (&dev->lock);
 	pr_debug ("%s: %s fail %zd, %p\n", shortname, __func__, value, dev);
 	kfree (dev->buf);



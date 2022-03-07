Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BABC4CF5FE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbiCGJau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbiCGJ3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22E660D8;
        Mon,  7 Mar 2022 01:28:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94FFCB80F9F;
        Mon,  7 Mar 2022 09:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1410C340E9;
        Mon,  7 Mar 2022 09:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645308;
        bh=GU1qZ8dbEsL6J9ZZT5ufr9ok5ZV+KF9ztqFDg6yIkCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0K2cNbrbuUlcS3HUMSABkdjzk3ApRDWAVnC2di/IxwmLNQ3S4OPl7O7VTQxW+Joh
         7ES6ALK+QPLUEflbQ+r6/vdIktPbQd5KTXfa5+9xDer2s0lWY/5G8z6JncqHc/bIDH
         KUA88WOCUfWi9a7A85vimwqv6dv96kwGB/MMjVL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 5.4 12/64] usb: gadget: dont release an existing dev->buf
Date:   Mon,  7 Mar 2022 10:18:45 +0100
Message-Id: <20220307091639.492236845@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
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

commit 89f3594d0de58e8a57d92d497dea9fee3d4b9cda upstream.

dev->buf does not need to be released if it already exists before
executing dev_config.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211231172138.7993-2-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1829,8 +1829,9 @@ dev_config (struct file *fd, const char
 	spin_lock_irq (&dev->lock);
 	value = -EINVAL;
 	if (dev->buf) {
+		spin_unlock_irq(&dev->lock);
 		kfree(kbuf);
-		goto fail;
+		return value;
 	}
 	dev->buf = kbuf;
 



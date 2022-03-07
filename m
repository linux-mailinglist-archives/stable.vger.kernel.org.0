Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A834CF502
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiCGJY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiCGJXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:23:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606D865794;
        Mon,  7 Mar 2022 01:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 154F6B810BC;
        Mon,  7 Mar 2022 09:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622ECC340E9;
        Mon,  7 Mar 2022 09:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644882;
        bh=rEQmAFSM5skYf2Cxsh8HavJvc5jurQZGsLq/sl+SbUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8uuX6T/vCWB9HZim4GRQs/PMf2LoH4j1ZZZL8cAOoiHvu23CcZFHTNYi7sQlNtIY
         ogaUhdRaKtLq/Yvh6pv9UYWuZXz2wmwt3qbBOFVYRsVzNi6ZMeZIjJjdv1bnuwH61h
         Sq0cl3eFO61Ya/86386HiwxP3DpLPc29cUCp+WnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 4.14 10/42] usb: gadget: dont release an existing dev->buf
Date:   Mon,  7 Mar 2022 10:18:44 +0100
Message-Id: <20220307091636.450594266@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
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
@@ -1833,8 +1833,9 @@ dev_config (struct file *fd, const char
 	spin_lock_irq (&dev->lock);
 	value = -EINVAL;
 	if (dev->buf) {
+		spin_unlock_irq(&dev->lock);
 		kfree(kbuf);
-		goto fail;
+		return value;
 	}
 	dev->buf = kbuf;
 



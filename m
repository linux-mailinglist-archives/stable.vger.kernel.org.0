Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4BD2C9A5C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbgLAI47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387722AbgLAI4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:56:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF7221D7A;
        Tue,  1 Dec 2020 08:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812966;
        bh=fjdm9nEuyx3eUE4CIIz03DRjZavEIKOwneaHpAD36cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJ/uLmqg2Tb++Ldc5XsS4FqwniJ3ug0g8ZsXiCUbIgwHR+FwNjtU0zma69kL5dwDo
         fFiHNVuAQr15Y161w//LZVQhd9/9ddow+S6br/Vpj6IGLb54aGXk2TH7evC+E0lOaE
         8z1LYKuDK07/QNlAhywmbSw8qrteqPPfEmAVADkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 4.9 37/42] usb: gadget: Fix memleak in gadgetfs_fill_super
Date:   Tue,  1 Dec 2020 09:53:35 +0100
Message-Id: <20201201084645.477134828@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

commit 87bed3d7d26c974948a3d6e7176f304b2d41272b upstream.

usb_get_gadget_udc_name will alloc memory for CHIP
in "Enomem" branch. we should free it before error
returns to prevent memleak.

Fixes: 175f712119c57 ("usb: gadget: provide interface for legacy gadgets to get UDC name")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201117021629.1470544-3-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/legacy/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -2045,6 +2045,9 @@ gadgetfs_fill_super (struct super_block
 	return 0;
 
 Enomem:
+	kfree(CHIP);
+	CHIP = NULL;
+
 	return -ENOMEM;
 }
 



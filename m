Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10DB2C9C1F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390420AbgLAJPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390414AbgLAJPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:15:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD67422249;
        Tue,  1 Dec 2020 09:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814069;
        bh=fHnMDH/BKoPrPOz3tNksVyh8B69y5tsRkOc8SW/M4Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFFU85M1XlbMkD2soeREBSXU3NZQSAjP30Q19GYrw051TRnnSbgN8sYreGbgExl13
         c7y4IeSSGylNUFMiIxIelY9Pdyl6wxZsLUi4w/rwsnPktwLUgmjRZhMhs0vUO7estn
         7paGi14k/y33BgxkhbBr9cQbkWoBzVtTNHw87bR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 5.9 146/152] usb: gadget: Fix memleak in gadgetfs_fill_super
Date:   Tue,  1 Dec 2020 09:54:21 +0100
Message-Id: <20201201084730.978685467@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
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
@@ -2039,6 +2039,9 @@ gadgetfs_fill_super (struct super_block
 	return 0;
 
 Enomem:
+	kfree(CHIP);
+	CHIP = NULL;
+
 	return -ENOMEM;
 }
 



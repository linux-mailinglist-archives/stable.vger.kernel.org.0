Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7FB66E0F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfGLMdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfGLMdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:33:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B2F21019;
        Fri, 12 Jul 2019 12:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934780;
        bh=bOSHJRD+yncBX5fw/6Yk1AQF+h2Hxgw71ox8mXIVFeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yU10yG2wMrIoKlQfNOczgrTiAVz6CZJ9AcUDK7LTJ1YuSe1ZUnfYMx7LM2UJ6KFc
         kMbXbmJadZ6iUpOkD0rcNYVP3IUxGdH0q5Lho5968X12oDtjkMiB2jfJe1GY8YsPUz
         cpsdElbtOMopR69qdtf6Q4igNJ9R/ZeE7zjU69Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.2 28/61] usb: gadget: f_fs: data_len used before properly set
Date:   Fri, 12 Jul 2019 14:19:41 +0200
Message-Id: <20190712121622.138400980@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Yang <fei.yang@intel.com>

commit 4833a94eb383f5b22775077ff92ddaae90440921 upstream.

The following line of code in function ffs_epfile_io is trying to set
flag io_data->use_sg in case buffer required is larger than one page.

    io_data->use_sg = gadget->sg_supported && data_len > PAGE_SIZE;

However at this point of time the variable data_len has not been set
to the proper buffer size yet. The consequence is that io_data->use_sg
is always set regardless what buffer size really is, because the condition
(data_len > PAGE_SIZE) is effectively an unsigned comparison between
-EINVAL and PAGE_SIZE which would always result in TRUE.

Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
Signed-off-by: Fei Yang <fei.yang@intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -997,7 +997,6 @@ static ssize_t ffs_epfile_io(struct file
 		 * earlier
 		 */
 		gadget = epfile->ffs->gadget;
-		io_data->use_sg = gadget->sg_supported && data_len > PAGE_SIZE;
 
 		spin_lock_irq(&epfile->ffs->eps_lock);
 		/* In the meantime, endpoint got disabled or changed. */
@@ -1012,6 +1011,8 @@ static ssize_t ffs_epfile_io(struct file
 		 */
 		if (io_data->read)
 			data_len = usb_ep_align_maybe(gadget, ep->ep, data_len);
+
+		io_data->use_sg = gadget->sg_supported && data_len > PAGE_SIZE;
 		spin_unlock_irq(&epfile->ffs->eps_lock);
 
 		data = ffs_alloc_buffer(io_data, data_len);



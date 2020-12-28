Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8352E3734
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbgL1MwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgL1MwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:52:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 537AB2245C;
        Mon, 28 Dec 2020 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159896;
        bh=3b41thYAONDglUo3QhFt3AC3Irrdt/NOex5xJYTSwi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrlHg77g7jPcvGDowJM871+thtOHLMMW7fLrp+483TeoHTn0IF9tz/rr2qaIouKVD
         /vGm8BaIjzAlXfTcqpuqVVHzZBu3XRNZy6wkceTzCudC3qPbDaspgRs54oJGzqErX6
         cpiNdV+zNNDXFLFk8Bii09Riq7F4j+at3kXFydD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bui Quang Minh <minhquangbui99@gmail.com>
Subject: [PATCH 4.4 013/132] USB: dummy-hcd: Fix uninitialized array use in init()
Date:   Mon, 28 Dec 2020 13:48:17 +0100
Message-Id: <20201228124847.039350869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bui Quang Minh <minhquangbui99@gmail.com>

commit e90cfa813da7a527785033a0b247594c2de93dd8 upstream.

This error path

	err_add_pdata:
		for (i = 0; i < mod_data.num; i++)
			kfree(dum[i]);

can be triggered when not all dum's elements are initialized.

Fix this by initializing all dum's elements to NULL.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/1607063090-3426-1-git-send-email-minhquangbui99@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/dummy_hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2741,7 +2741,7 @@ static int __init init(void)
 {
 	int	retval = -ENOMEM;
 	int	i;
-	struct	dummy *dum[MAX_NUM_UDC];
+	struct	dummy *dum[MAX_NUM_UDC] = {};
 
 	if (usb_disabled())
 		return -ENODEV;



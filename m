Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2335D2E37BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgL1M7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgL1M7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A60D207C9;
        Mon, 28 Dec 2020 12:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160339;
        bh=HLbvT0t5lTNvAq8/yQSXy/x+6NeyQHXLhVSTO0F0GQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHk/Y+R+5W89Pg1SiMTVdmLwfDY5zBW5a7FT4Hvlgt5Eb8YbfGu+Av0MZ8v4k7NDt
         9Ks+n1COqlGY+AG3x08MSdBxuJo+IAUl7P1m6Us++rt156zTrxfCgqPU2Ke5+gPLFn
         8m+tbTr4pcr+6JJa/4pCSZfOsVIjuDUMJZ8QHskE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bui Quang Minh <minhquangbui99@gmail.com>
Subject: [PATCH 4.9 018/175] USB: dummy-hcd: Fix uninitialized array use in init()
Date:   Mon, 28 Dec 2020 13:47:51 +0100
Message-Id: <20201228124854.146729305@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
@@ -2736,7 +2736,7 @@ static int __init init(void)
 {
 	int	retval = -ENOMEM;
 	int	i;
-	struct	dummy *dum[MAX_NUM_UDC];
+	struct	dummy *dum[MAX_NUM_UDC] = {};
 
 	if (usb_disabled())
 		return -ENODEV;



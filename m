Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978993AA3D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbfFIQwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbfFIQwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0CBF205ED;
        Sun,  9 Jun 2019 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099160;
        bh=QwMPYowNbNSmctDkS8RVw0Gpc7vhQN6OyjlLIbb6GPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uS0pT6jD85Akq1cC6CfdvzlPg5vbEquv1itHJs325BAWeoLT4u+je6xnVIIoaPFYf
         vTn7D8SUEaVpacUFeUYBB6szijlOQ/ea8Z1o+a7vrQ3plm40mmnT4M/8AKvCTA+uow
         gZ0M+IyNNMsBkDXzo6txoITCuQ9rrERewQFYzpvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH 4.9 32/83] media: usb: siano: Fix false-positive "uninitialized variable" warning
Date:   Sun,  9 Jun 2019 18:42:02 +0200
Message-Id: <20190609164130.425100049@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 45457c01171fd1488a7000d1751c06ed8560ee38 upstream.

GCC complains about an apparently uninitialized variable recently
added to smsusb_init_device().  It's a false positive, but to silence
the warning this patch adds a trivial initialization.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: kbuild test robot <lkp@intel.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/siano/smsusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -402,7 +402,7 @@ static int smsusb_init_device(struct usb
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
-	int in_maxp;
+	int in_maxp = 0;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);



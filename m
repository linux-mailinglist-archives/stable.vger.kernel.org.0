Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131372C9C9C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgLAIzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728985AbgLAIzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:55:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCC02223C;
        Tue,  1 Dec 2020 08:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812845;
        bh=fvR6XWov8DypphIb0Z8ChDOSG2vyMU6R67aQSSW+6z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDESN+E+0HMUKWdeiM8eN0LfsBYJT0MVpAHJ+ycKBPWXaiJRnbsVGPrsD6wi9dXwN
         Lummsr1ZLBgN9Wy0iGbMtlKQsZ6nxcT1DPbllcB8d/ylQatJWHdO7y1xj7zPye/gke
         EUlAx38Pse6AJloyIrhRGXF1qG/Lx9pNEdcRhDhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamsi Krishna Samavedam <vskrishn@codeaurora.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.4 20/24] USB: core: Change %pK for __user pointers to %px
Date:   Tue,  1 Dec 2020 09:53:26 +0100
Message-Id: <20201201084638.765195922@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit f3bc432aa8a7a2bfe9ebb432502be5c5d979d7fe upstream.

Commit 2f964780c03b ("USB: core: replace %p with %pK") used the %pK
format specifier for a bunch of __user pointers.  But as the 'K' in
the specifier indicates, it is meant for kernel pointers.  The reason
for the %pK specifier is to avoid leaks of kernel addresses, but when
the pointer is to an address in userspace the security implications
are minimal.  In particular, no kernel information is leaked.

This patch changes the __user %pK specifiers (used in a bunch of
debugging output lines) to %px, which will always print the actual
address with no mangling.  (Notably, there is no printk format
specifier particularly intended for __user pointers.)

Fixes: 2f964780c03b ("USB: core: replace %p with %pK")
CC: Vamsi Krishna Samavedam <vskrishn@codeaurora.org>
CC: <stable@vger.kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201119170228.GB576844@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -369,11 +369,11 @@ static void snoop_urb(struct usb_device
 
 	if (userurb) {		/* Async */
 		if (when == SUBMIT)
-			dev_info(&udev->dev, "userurb %pK, ep%d %s-%s, "
+			dev_info(&udev->dev, "userurb %px, ep%d %s-%s, "
 					"length %u\n",
 					userurb, ep, t, d, length);
 		else
-			dev_info(&udev->dev, "userurb %pK, ep%d %s-%s, "
+			dev_info(&udev->dev, "userurb %px, ep%d %s-%s, "
 					"actual_length %u status %d\n",
 					userurb, ep, t, d, length,
 					timeout_or_status);



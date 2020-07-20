Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E78226BFC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgGTPjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgGTPjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:39:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27C1722CB2;
        Mon, 20 Jul 2020 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259578;
        bh=Zr7p3Ul/aFedOfHDFZhKZYtxges4GwoHHWtfyuMiZkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqQGulnrZLszzuEZmqiChoRTSB8V6rtWBy8Lrijj2qIuNNUtQ4cau9mZk0121c2Y3
         eyT0LYG/DSnIRlQUYuZHnXvkru6mdhZRYq+BOj8kQFnhFsSOw+5B/l59VNJaCgYSRD
         6ZKg6eaQNhDZvPiZbuHZVNRDV01o28TtLcSjekDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH 4.4 41/58] USB: c67x00: fix use after free in c67x00_giveback_urb
Date:   Mon, 20 Jul 2020 17:36:57 +0200
Message-Id: <20200720152749.277319149@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 211f08347355cba1f769bbf3355816a12b3ddd55 upstream.

clang static analysis flags this error

c67x00-sched.c:489:55: warning: Use of memory after it is freed [unix.Malloc]
        usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, urbp->status);
                                                             ^~~~~~~~~~~~
Problem happens in this block of code

	c67x00_release_urb(c67x00, urb);
	usb_hcd_unlink_urb_from_ep(c67x00_hcd_to_hcd(c67x00), urb);
	spin_unlock(&c67x00->lock);
	usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, urbp->status);

In the call to c67x00_release_urb has this freeing of urbp

	urbp = urb->hcpriv;
	urb->hcpriv = NULL;
	list_del(&urbp->hep_node);
	kfree(urbp);

And so urbp is freed before usb_hcd_giveback_urb uses it as its 3rd
parameter.

Since all is required is the status, pass the status directly as is
done in c64x00_urb_dequeue

Fixes: e9b29ffc519b ("USB: add Cypress c67x00 OTG controller HCD driver")
Signed-off-by: Tom Rix <trix@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200708131243.24336-1-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/c67x00/c67x00-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -500,7 +500,7 @@ c67x00_giveback_urb(struct c67x00_hcd *c
 	c67x00_release_urb(c67x00, urb);
 	usb_hcd_unlink_urb_from_ep(c67x00_hcd_to_hcd(c67x00), urb);
 	spin_unlock(&c67x00->lock);
-	usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, urbp->status);
+	usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, status);
 	spin_lock(&c67x00->lock);
 }
 



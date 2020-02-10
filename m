Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A338515788C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbgBJNId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbgBJMjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:31 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FE32051A;
        Mon, 10 Feb 2020 12:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338371;
        bh=LvXdFRpwAxoMEMynk7tGA+7ZJOj3yuRAZnrI8ID4qVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGmlA9veT8Q+wJT+8XDYN562SqLbpoposmEYFCY3W732E+iKos1SP1wWCi93OXI5i
         uYR1OC52VJI3Qpk3EWuUEfTWDjl1CT5cliPsba8SM1OHHTnl5kkdhkoBqdJULTUHGc
         O3FXi0Q9m4flK4GctHBHEvQt7ip/e8+z1Piv0ttE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.5 042/367] brcmfmac: Fix memory leak in brcmf_usbdev_qinit
Date:   Mon, 10 Feb 2020 04:29:15 -0800
Message-Id: <20200210122427.887070258@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 4282dc057d750c6a7dd92953564b15c26b54c22c upstream.

In the implementation of brcmf_usbdev_qinit() the allocated memory for
reqs is leaking if usb_alloc_urb() fails. Release reqs in the error
handling path.

Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -430,6 +430,7 @@ fail:
 			usb_free_urb(req->urb);
 		list_del(q->next);
 	}
+	kfree(reqs);
 	return NULL;
 
 }



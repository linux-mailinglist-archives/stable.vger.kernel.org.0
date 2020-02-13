Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A112115C685
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgBMQBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728753AbgBMPYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:39 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C66A1246A3;
        Thu, 13 Feb 2020 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607478;
        bh=GXinBSpBqSY7GqT/NaS7EridjFozm3hsbg2xH/NR7hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqMptW+oeq8Pq7N4Pfd4ze2VnOsyvCbEwEho+bcJ/HOp2aVTdcucwj7T4NI+uKtC4
         XhhzzpKK687MnlZdGunlx0yVdJFAlNdvzW+EK4lvLvlavy3SE52LbsoMt+fS2b8SG6
         S/5K2ww38WrUYlC+aEDxRyK8361+NwPtng5XB/nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 021/173] brcmfmac: Fix memory leak in brcmf_usbdev_qinit
Date:   Thu, 13 Feb 2020 07:18:44 -0800
Message-Id: <20200213151938.511935277@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
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
@@ -441,6 +441,7 @@ fail:
 			usb_free_urb(req->urb);
 		list_del(q->next);
 	}
+	kfree(reqs);
 	return NULL;
 
 }



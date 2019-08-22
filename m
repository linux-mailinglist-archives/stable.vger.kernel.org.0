Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF5799DBD
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392894AbfHVRpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403826AbfHVRXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:11 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25D5C23407;
        Thu, 22 Aug 2019 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494590;
        bh=YLrwVatPL9+gX9zHsjW8OKCQyEPKpL14pEZk8waVw5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhEqwaxF4V96I/z4Vc3aH174YxrYcp47HatTiWMXM/ZOMN8YU4b/ayv39t8c8aK4s
         gjb3qZM9zGz0l0T8kObep7B1urzlvBGwNB0yq2RmAuvNv2wT43ph9arEuyYCduKBUI
         rCcW44gEsVYMWFKozROL9XNbNeTaySmDdx14k4M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Li <git@thegavinli.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.9 001/103] usb: usbfs: fix double-free of usb memory upon submiturb error
Date:   Thu, 22 Aug 2019 10:17:49 -0700
Message-Id: <20190822171728.499909862@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Li <git@thegavinli.com>

commit c43f28dfdc4654e738aa6d3fd08a105b2bee758d upstream.

Upon an error within proc_do_submiturb(), dec_usb_memory_use_count()
gets called once by the error handling tail and again by free_async().
Remove the first call.

Signed-off-by: Gavin Li <git@thegavinli.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190804235044.22327-1-gavinli@thegavinli.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1810,8 +1810,6 @@ static int proc_do_submiturb(struct usb_
 	return 0;
 
  error:
-	if (as && as->usbm)
-		dec_usb_memory_use_count(as->usbm, &as->usbm->urb_use_count);
 	kfree(isopkt);
 	kfree(dr);
 	if (as)



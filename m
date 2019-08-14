Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10748DAED
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfHNRJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbfHNRJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F9B6214DA;
        Wed, 14 Aug 2019 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802582;
        bh=uZx/YxYl0pu1bln3sAog1+mlRjc9Q0jlUpMBSFc9XU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBPorsrP0zt/cKa4Npe/v0hUT8GdHQkXkXX3Vl1eRY2gDatggSX3gsbRCtym4ZCra
         nU4fLQfAWScNd5V8D0U2VTOno/tg9P+F8mZWnVS+cQzfaTkXjqVscTRoB1WG4m41kC
         FT9YHmlTBx4fmP/lJ8jaKP0gIlCpokdwh15IvVPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Li <git@thegavinli.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.19 08/91] usb: usbfs: fix double-free of usb memory upon submiturb error
Date:   Wed, 14 Aug 2019 19:00:31 +0200
Message-Id: <20190814165749.494054788@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -1792,8 +1792,6 @@ static int proc_do_submiturb(struct usb_
 	return 0;
 
  error:
-	if (as && as->usbm)
-		dec_usb_memory_use_count(as->usbm, &as->usbm->urb_use_count);
 	kfree(isopkt);
 	kfree(dr);
 	if (as)



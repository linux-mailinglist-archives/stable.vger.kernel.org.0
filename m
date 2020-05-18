Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F981D865F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgERRpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgERRpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:45:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56C020715;
        Mon, 18 May 2020 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823900;
        bh=IQGRJknKyaZjCOxSLRNNYP/kisqa8Fs/sQW+wF75x1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2YqUTA2p35SA8/PwF4yu+SyXLZymX50JTb+9klpAFaem88GtJw4OYfrFSI9B8zOW
         Kbd/sqcLPUFhKCK7d8vBQv6Dkqqmb4ee0VV0oMd0TuGQDV9qZr3GtRRWnO8FBlJuKm
         5hNBDF5YOgqF6mWHgutcniT93jTiMBXquIY89dsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.9 82/90] usb: gadget: net2272: Fix a memory leak in an error handling path in net2272_plat_probe()
Date:   Mon, 18 May 2020 19:37:00 +0200
Message-Id: <20200518173507.888495926@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit ccaef7e6e354fb65758eaddd3eae8065a8b3e295 upstream.

'dev' is allocated in 'net2272_probe_init()'. It must be freed in the error
handling path, as already done in the remove function (i.e.
'net2272_plat_remove()')

Fixes: 90fccb529d24 ("usb: gadget: Gadget directory cleanup - group UDC drivers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/net2272.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/udc/net2272.c
+++ b/drivers/usb/gadget/udc/net2272.c
@@ -2666,6 +2666,8 @@ net2272_plat_probe(struct platform_devic
  err_req:
 	release_mem_region(base, len);
  err:
+	kfree(dev);
+
 	return ret;
 }
 



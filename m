Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B561C15C2
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgEANdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbgEANdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:33:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14DAB208C3;
        Fri,  1 May 2020 13:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340011;
        bh=f/fwzZFg0f1HI+4wKwzeOAmlMY6UcodpWxR9NRYIXsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlCfgXiwWDeXEMsaitUKI+DT7aqA74EthUBIqNh7Gy+Y/jlYBsnb7qo806sTLaJBr
         Gfs0WPZMtqkRRBZcvHCJXmfEUIC0abcQjaLXRhnWwgqzv41JzN3odQzUfwI0B1Nl70
         EfwJdJDGFCPG+VVf3sOVhc8rwNv+kW6n0lRAk1Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 070/117] staging: comedi: Fix comedi_device refcnt leak in comedi_open
Date:   Fri,  1 May 2020 15:21:46 +0200
Message-Id: <20200501131553.439947944@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 332e0e17ad49e084b7db670ef43b5eb59abd9e34 upstream.

comedi_open() invokes comedi_dev_get_from_minor(), which returns a
reference of the COMEDI device to "dev" with increased refcount.

When comedi_open() returns, "dev" becomes invalid, so the refcount
should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
comedi_open(). When "cfp" allocation is failed, the refcnt increased by
comedi_dev_get_from_minor() is not decreased, causing a refcnt leak.

Fix this issue by calling comedi_dev_put() on this error path when "cfp"
allocation is failed.

Fixes: 20f083c07565 ("staging: comedi: prepare support for per-file read and write subdevices")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/1587361459-83622-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2603,8 +2603,10 @@ static int comedi_open(struct inode *ino
 	}
 
 	cfp = kzalloc(sizeof(*cfp), GFP_KERNEL);
-	if (!cfp)
+	if (!cfp) {
+		comedi_dev_put(dev);
 		return -ENOMEM;
+	}
 
 	cfp->dev = dev;
 



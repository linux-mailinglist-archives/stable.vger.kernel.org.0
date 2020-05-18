Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9111D85B2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbgERSUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729761AbgERRwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:52:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00A9207F5;
        Mon, 18 May 2020 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824366;
        bh=yrAxux62RVSsRCz4EE8zavy7cKRxl0L7f3iPoXjbJqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxXbeUomTWkCYGWy2feLzLDNlzNoa/tI9vtPX194MTGXFV1GbOt6Or791kJ36GdVs
         CI0D2HSAJTlNxiT5T/H58OzVsFtkJIrv9Xvyvo9x411RszR77hjVXaApFz77xydrk1
         +8J0gR6Zy1CYYl/BHRg/smwdUe/cTFWEkSFoeAv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam McCoy <adam@forsedomani.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 4.19 62/80] cifs: fix leaked reference on requeued write
Date:   Mon, 18 May 2020 19:37:20 +0200
Message-Id: <20200518173502.930083151@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam McCoy <adam@forsedomani.com>

commit a48137996063d22ffba77e077425f49873856ca5 upstream.

Failed async writes that are requeued may not clean up a refcount
on the file, which can result in a leaked open. This scenario arises
very reliably when using persistent handles and a reconnect occurs
while writing.

cifs_writev_requeue only releases the reference if the write fails
(rc != 0). The server->ops->async_writev operation will take its own
reference, so the initial reference can always be released.

Signed-off-by: Adam McCoy <adam@forsedomani.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifssmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2051,8 +2051,8 @@ cifs_writev_requeue(struct cifs_writedat
 			}
 		}
 
+		kref_put(&wdata2->refcount, cifs_writedata_release);
 		if (rc) {
-			kref_put(&wdata2->refcount, cifs_writedata_release);
 			if (is_retryable_error(rc))
 				continue;
 			i += nr_pages;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DC93D6284
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbhGZPgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236870AbhGZPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9499960F5A;
        Mon, 26 Jul 2021 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316162;
        bh=GFJfpjeCaH1H7dygZftxr7fcI9EruZcOqtrO2cFt02E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWKGdC7fFHf3mPrCcGHk/AfWFBOndFcTVKyB5lswZlXbOwCGw5ne9roFVuhcQTsdg
         G9azXoRy921zdyZ8F2CKum1xVHZtYYaaPuHTcQj+WmhUPtlOC0UCJ+Caj0V8gJCWI1
         QIf2SqkDjr589rIqEtGmM2JlWxKM0lAFvemNRgN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Subject: [PATCH 5.13 186/223] driver core: auxiliary bus: Fix memory leak when driver_register() fail
Date:   Mon, 26 Jul 2021 17:39:38 +0200
Message-Id: <20210726153852.280096999@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 4afa0c22eed33cfe0c590742387f0d16f32412f3 upstream.

If driver_register() returns with error we need to free the memory
allocated for auxdrv->driver.name before returning from
__auxiliary_driver_register()

Fixes: 7de3697e9cbd4 ("Add auxiliary bus support")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20210713093438.3173-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/auxiliary.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -231,6 +231,8 @@ EXPORT_SYMBOL_GPL(auxiliary_find_device)
 int __auxiliary_driver_register(struct auxiliary_driver *auxdrv,
 				struct module *owner, const char *modname)
 {
+	int ret;
+
 	if (WARN_ON(!auxdrv->probe) || WARN_ON(!auxdrv->id_table))
 		return -EINVAL;
 
@@ -246,7 +248,11 @@ int __auxiliary_driver_register(struct a
 	auxdrv->driver.bus = &auxiliary_bus_type;
 	auxdrv->driver.mod_name = modname;
 
-	return driver_register(&auxdrv->driver);
+	ret = driver_register(&auxdrv->driver);
+	if (ret)
+		kfree(auxdrv->driver.name);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__auxiliary_driver_register);
 



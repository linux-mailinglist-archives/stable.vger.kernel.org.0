Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB155261A22
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbgIHSav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731380AbgIHQJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B88222463F;
        Tue,  8 Sep 2020 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580204;
        bh=a/0utpbekIn7tOkcbHZ+dGokUhYv1MTxnUVOIa07WYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDuLThEmcaJCNV2nfeS9utpwA3AaokpCkl5mW/pBCqblqsojxP54ywIVTisdTK37o
         CzyWOuhzTq8M/ZyHv3d88G8prPsp8TSTwmNsBUYBFwEZv40rJuNbR/qdE1Y0oDesiT
         4jzkKfGD765NFTLxmXBjp8Xt9+xDS/TY3jNEnQY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 71/88] media: rc: do not access device via sysfs after rc_unregister_device()
Date:   Tue,  8 Sep 2020 17:26:12 +0200
Message-Id: <20200908152224.731943085@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit a2e2d73fa28136598e84db9d021091f1b98cbb1a upstream.

Device drivers do not expect to have change_protocol or wakeup
re-programming to be accesed after rc_unregister_device(). This can
cause the device driver to access deallocated resources.

Cc: <stable@vger.kernel.org> # 4.16+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/rc-main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1245,6 +1245,10 @@ static ssize_t store_protocols(struct de
 	}
 
 	mutex_lock(&dev->lock);
+	if (!dev->registered) {
+		mutex_unlock(&dev->lock);
+		return -ENODEV;
+	}
 
 	old_protocols = *current_protocols;
 	new_protocols = old_protocols;
@@ -1383,6 +1387,10 @@ static ssize_t store_filter(struct devic
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
+	if (!dev->registered) {
+		mutex_unlock(&dev->lock);
+		return -ENODEV;
+	}
 
 	new_filter = *filter;
 	if (fattr->mask)
@@ -1497,6 +1505,10 @@ static ssize_t store_wakeup_protocols(st
 	int i;
 
 	mutex_lock(&dev->lock);
+	if (!dev->registered) {
+		mutex_unlock(&dev->lock);
+		return -ENODEV;
+	}
 
 	allowed = dev->allowed_wakeup_protocols;
 



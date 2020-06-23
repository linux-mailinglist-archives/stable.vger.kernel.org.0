Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652D32063D3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403817AbgFWVLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391012AbgFWUcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5681B20723;
        Tue, 23 Jun 2020 20:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944327;
        bh=76AYprGS4xOcYibcpWPdXZ7BtMA5jqXnRLPjojXgwGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tz0Nj0QfZmLkq+imlnwDTN83wXq8cjhgmLbZfspgdzR5cemAEpzKrhImrUn1XkIKv
         eSzexjja14uuQEgsqaRg3W61yTLKb9ORkfMnb1QW80P75/Mzu2FODAmfjA9nTG0iGR
         EfUh6dY1g3gNDyaAeMX138j7pAgWYzvK9ePLFLh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 260/314] usb/xhci-plat: Set PM runtime as active on resume
Date:   Tue, 23 Jun 2020 21:57:35 +0200
Message-Id: <20200623195351.375876600@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 79112cc3c29f4a8c73a21428fbcbcb0afb005e3e ]

Follow suit of ohci-platform.c and perform pm_runtime_set_active() on
resume.

ohci-platform.c had a warning reported due to the missing
pm_runtime_set_active() [1].

[1] https://lore.kernel.org/lkml/20200323143857.db5zphxhq4hz3hmd@e107158-lin.cambridge.arm.com/

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
CC: Tony Prisk <linux@prisktech.co.nz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mathias Nyman <mathias.nyman@intel.com>
CC: Oliver Neukum <oneukum@suse.de>
CC: linux-arm-kernel@lists.infradead.org
CC: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20200518154931.6144-2-qais.yousef@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 52c625c023410..60d06e9b600f8 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -410,7 +410,15 @@ static int __maybe_unused xhci_plat_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	return xhci_resume(xhci, 0);
+	ret = xhci_resume(xhci, 0);
+	if (ret)
+		return ret;
+
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	return 0;
 }
 
 static int __maybe_unused xhci_plat_runtime_suspend(struct device *dev)
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E78390D6
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbfFGPp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730874AbfFGPpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 680912147A;
        Fri,  7 Jun 2019 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922354;
        bh=IH42kK0pM6mKM6+D0dw5afG5V8kpzrd86yBmMIwqO40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8TrSpMyZjj+6NmANMuNH2rbYN7IW74AP9NYvyxY4yTrClAGYXc8xRBtDtk5Dxljy
         tleMgNJnk2AN3BNQMl6eDmtZoh1HD8uFWk57Ro9aGpkGya9jIOvRkwbfJsvLPSKKA6
         CV55oOtjwLbymPkfP3sR5YwYpoyi75bC5BDlxV68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Deepak Rawat <drawat@vmware.com>
Subject: [PATCH 4.19 57/73] drm/vmwgfx: Dont send drm sysfs hotplug events on initial master set
Date:   Fri,  7 Jun 2019 17:39:44 +0200
Message-Id: <20190607153855.391005820@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 63cb44441826e842b7285575b96db631cc9f2505 upstream.

This may confuse user-space clients like plymouth that opens a drm
file descriptor as a result of a hotplug event and then generates a
new event...

Cc: <stable@vger.kernel.org>
Fixes: 5ea1734827bb ("drm/vmwgfx: Send a hotplug event at master_set")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1291,7 +1291,13 @@ static int vmw_master_set(struct drm_dev
 	}
 
 	dev_priv->active_master = vmaster;
-	drm_sysfs_hotplug_event(dev);
+
+	/*
+	 * Inform a new master that the layout may have changed while
+	 * it was gone.
+	 */
+	if (!from_open)
+		drm_sysfs_hotplug_event(dev);
 
 	return 0;
 }



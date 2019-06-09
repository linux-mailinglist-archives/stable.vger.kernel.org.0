Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01D63AA30
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfFIRQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732404AbfFIQx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE43A206DF;
        Sun,  9 Jun 2019 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099208;
        bh=4dRqwOCNbDrUOH84RUkkjW9jPHaTGW3Y2CIITnQ3V0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S806TS6Kqe8r13/Vx+1j42apCkm/UB4Qcs7g9c/QxhUGUbRUFKF9k9WNnHuphgf19
         7oyyLDOFV4SBpdHrg4SI2AW8EE8iGx/zo6lRnBvxSbISvbzKL9b1p8R/2CO4nFcEoT
         ZbPBUE22H+DFeREwnsz2UHNTuyI/pEektOFjUDr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Deepak Rawat <drawat@vmware.com>
Subject: [PATCH 4.9 48/83] drm/vmwgfx: Dont send drm sysfs hotplug events on initial master set
Date:   Sun,  9 Jun 2019 18:42:18 +0200
Message-Id: <20190609164132.030491942@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
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
@@ -1245,7 +1245,13 @@ static int vmw_master_set(struct drm_dev
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



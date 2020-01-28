Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFD714BB5F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgA1OJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgA1OJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:09:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 468552468A;
        Tue, 28 Jan 2020 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220541;
        bh=jI+YicMQN6RgKFZTPOi1pQ0Rp9DsZyiNeEI2BC3Qvrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoZ0NRlyYvt+vppN2szctH6fKTv/ZU71zBmSdmMx1G7UMdv8qFX3A+8YDavzCUVcV
         Uf9rRB1fNxChe28T5hoUj28t9lDXHioqQUqg1kk+Z75u9HnD817DlqMJoHCjzjlOYj
         qYFKEkXJxHms9/pXoFaZ5OVfzHdh+JJGC1d/+cCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 049/183] cdc-wdm: pass return value of recover_from_urb_loss
Date:   Tue, 28 Jan 2020 15:04:28 +0100
Message-Id: <20200128135834.853941225@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0742a338f5b3446a26de551ad8273fb41b2787f2 ]

'rv' is the correct return value, pass it upstream instead of 0

Fixes: 17d80d562fd7 ("USB: autosuspend for cdc-wdm")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-wdm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 71ad04d542128..1a1d1cfc3704c 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -1098,7 +1098,7 @@ static int wdm_post_reset(struct usb_interface *intf)
 	rv = recover_from_urb_loss(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
-	return 0;
+	return rv;
 }
 
 static struct usb_driver wdm_driver = {
-- 
2.20.1




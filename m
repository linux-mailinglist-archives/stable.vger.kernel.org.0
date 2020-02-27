Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434A0172090
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgB0NsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730514AbgB0NsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:48:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C318E20578;
        Thu, 27 Feb 2020 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811300;
        bh=QF+GM9/wVb1HaoupTgbLeTFq/iwqSRZpYgfw/Bq0fhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dpp9lgRgsl/jCmdFlhZXcDJmUW0CYR7o5VAkWv9Reen3PJYKARDJQc9CujBi2mgNB
         9BnZPpEdkPFWyIWfAsDxyiFd9KTyo5pHd9TqxC1hi+yNruSNkY+vBcQXs3CzlagY7y
         m0TeJPGCcaJYrTgfwAc/Qacm6M4/bbVNvOlpYKYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 078/165] driver core: Print device when resources present in really_probe()
Date:   Thu, 27 Feb 2020 14:35:52 +0100
Message-Id: <20200227132242.780012307@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7c35e699c88bd60734277b26962783c60e04b494 ]

If a device already has devres items attached before probing, a warning
backtrace is printed.  However, this backtrace does not reveal the
offending device, leaving the user uninformed.  Furthermore, using
WARN_ON() causes systems with panic-on-warn to reboot.

Fix this by replacing the WARN_ON() by a dev_crit() message.
Abort probing the device, to prevent doing more damage to the device's
resources.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191206132219.28908-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index ee25a69630c3a..854d218ea76ac 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -341,7 +341,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
-	WARN_ON(!list_empty(&dev->devres_head));
+	if (!list_empty(&dev->devres_head)) {
+		dev_crit(dev, "Resources present before probing\n");
+		return -EBUSY;
+	}
 
 re_probe:
 	dev->driver = drv;
-- 
2.20.1




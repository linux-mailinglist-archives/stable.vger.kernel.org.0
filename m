Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D621EE51
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbfEOLUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbfEOLUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:20:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE17821473;
        Wed, 15 May 2019 11:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919201;
        bh=fdAxxYuQHXHBmmCsWwGri8WNL8YF7p9yqpkK8dCSjMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBIG9AeEzdZjR3hhfUsuqMRTOdcfZ25vsD605WiPxN4tdPmtRy3FGatymyauFJZyW
         dR6o6lbmofRWAjBp6cx6ntlEW01tgW1euum6Qy3KXjOU7wIE3td3a4QTXfotC4FhqI
         pFFtyII3VOw/T8wXrkLFc9CmoDQdzGCgtoOHlAhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 060/115] scsi: raid_attrs: fix unused variable warning
Date:   Wed, 15 May 2019 12:55:40 +0200
Message-Id: <20190515090703.912770000@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0eeec01488da9b1403c8c29e73eacac8af9e4bf2 ]

I ran into a new warning on randconfig kernels:

drivers/scsi/raid_class.c: In function 'raid_match':
drivers/scsi/raid_class.c:64:24: error: unused variable 'i' [-Werror=unused-variable]

This looks like a very old problem that for some reason was very hard to
run into, but it is very easy to fix, by replacing the incorrect #ifdef
with a simpler IS_ENABLED() check.

Fixes: fac829fdcaf4 ("[SCSI] raid_attrs: fix dependency problems")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/scsi/raid_class.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 2c146b44d95fc..cddd78893b46c 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -63,8 +63,7 @@ static int raid_match(struct attribute_container *cont, struct device *dev)
 	 * emulated RAID devices, so start with SCSI */
 	struct raid_internal *i = ac_to_raid_internal(cont);
 
-#if defined(CONFIG_SCSI) || defined(CONFIG_SCSI_MODULE)
-	if (scsi_is_sdev_device(dev)) {
+	if (IS_ENABLED(CONFIG_SCSI) && scsi_is_sdev_device(dev)) {
 		struct scsi_device *sdev = to_scsi_device(dev);
 
 		if (i->f->cookie != sdev->host->hostt)
@@ -72,7 +71,6 @@ static int raid_match(struct attribute_container *cont, struct device *dev)
 
 		return i->f->is_raid(dev);
 	}
-#endif
 	/* FIXME: look at other subsystems too */
 	return 0;
 }
-- 
2.20.1




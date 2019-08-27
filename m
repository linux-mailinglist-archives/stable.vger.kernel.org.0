Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402259E069
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbfH0IDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732262AbfH0IDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9752186A;
        Tue, 27 Aug 2019 08:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893010;
        bh=Rlkn9OqUpPLD+i1nh7Rz33VsZWnKtp4NRAQDgHStGEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyJAMZY87MQ1TwrpRMBhBRFthywY72LYIZAtMRY2c3NKAs7rz+hBmCPnuqzrGUy28
         VSq2ySrovEnK3gJyttUyCdr1EVsDYmWIIqXmLDm7+vUQpuJAc5m5Nfd+z4owXvazfw
         GcvB+uKjEI+d6EB3qKAFZiQeZM5DFYmCPCoegzbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 088/162] ata: rb532_cf: Fix unused variable warning in rb532_pata_driver_probe
Date:   Tue, 27 Aug 2019 09:50:16 +0200
Message-Id: <20190827072741.214929774@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit db341a049ec7e87053c91008cb452d0bfa6dde72 ]

Fix the following warning (Building: rb532_defconfig mips):

drivers/ata/pata_rb532_cf.c: In function ‘rb532_pata_driver_remove’:
drivers/ata/pata_rb532_cf.c:161:24: warning: unused variable ‘info’ [-Wunused-variable]
  struct rb532_cf_info *info = ah->private_data;
                        ^~~~

Fixes: cd56f35e52d9 ("ata: rb532_cf: Convert to use GPIO descriptors")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_rb532_cf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 7c37f2ff09e41..deae466395de1 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -158,7 +158,6 @@ static int rb532_pata_driver_probe(struct platform_device *pdev)
 static int rb532_pata_driver_remove(struct platform_device *pdev)
 {
 	struct ata_host *ah = platform_get_drvdata(pdev);
-	struct rb532_cf_info *info = ah->private_data;
 
 	ata_host_detach(ah);
 
-- 
2.20.1




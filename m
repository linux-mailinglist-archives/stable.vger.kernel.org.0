Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54DA401414
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241075AbhIFBcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240375AbhIFB3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3887861130;
        Mon,  6 Sep 2021 01:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891390;
        bh=t69di5wsk9zap04vJghr7ora4FQh2E8rzBla83neAiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MF96sIRb4+M0td3N2RHkBGdz7FwTh4cTckqleEeBlgCrUqkz1YlWmpoxWV80wLXOv
         74u5hBj2rRLy1CZU62ip2Utdu53v2br3kRJlIyoTJIVQCepPij7NjDq3V9Tr0S0mer
         bQjaerDVq4T06hMAn88yd+XbKaU/bLnAeC7l3A9wGBp9YFyL7+EI46JloHNdm2QBVE
         xRJfbyG5xxQOjtfdKNVjaTbXh5vdZ/uUdUrcxaazWXvxS1P6hqfNluLTc45FEWDh1o
         krj3yH8ja5hBc4vryd/PS2Lwr3AwOk+0DYvaEsoP5Nk/g1GuZ8rV8SRhKYAwuR9/Fh
         RyU6CuVfYkjKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        kernel test robot <lkp@intel.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/30] libata: fix ata_host_start()
Date:   Sun,  5 Sep 2021 21:22:34 -0400
Message-Id: <20210906012244.930338-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit 355a8031dc174450ccad2a61c513ad7222d87a97 ]

The loop on entry of ata_host_start() may not initialize host->ops to a
non NULL value. The test on the host_stop field of host->ops must then
be preceded by a check that host->ops is not NULL.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20210816014456.2191776-3-damien.lemoal@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f67b3fb33d57..7788af0ca109 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6394,7 +6394,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
-- 
2.30.2


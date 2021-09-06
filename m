Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B43A401478
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351076AbhIFBdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351788AbhIFBbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4325C61220;
        Mon,  6 Sep 2021 01:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891466;
        bh=EH6zae6M1SVc1wJPqjJMdqsFNcQXuxHHyJatFnedv4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYTmyGI73vp23h1lCIzNNSDr+Ldat5Ro5MImAFYMrrldtIq3OBtv6tKuY2UKxx2RV
         Z+SNNR7HYT7CPymTrkHXRg0aWmJ/jWzCTLwVwMTwJeVidDPXxgmfSujkiEhcETqNny
         5Rd0XCHWFt0MmFSdQQzQsJAGnlvvBk6CQbw6QEzFn9UxXf0s7rrfSjfqqXEArES9rk
         tCS78ssxoz8RUbEAWFfXVGp2dylWGfBRxFzgvDvfb/uiwTyeE99HZnKrwPAslVRAEB
         TPvQg9KmkbpjtrUEdLfHZPDcVVCTfC57wcPWJL4QZz0pDvodepA8x8CVB0JFPSFiLu
         Q8o7bciLMY7lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        kernel test robot <lkp@intel.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/14] libata: fix ata_host_start()
Date:   Sun,  5 Sep 2021 21:24:09 -0400
Message-Id: <20210906012415.931147-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012415.931147-1-sashal@kernel.org>
References: <20210906012415.931147-1-sashal@kernel.org>
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
index 228a4cfb0e7d..ea42840575ca 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6213,7 +6213,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
-- 
2.30.2


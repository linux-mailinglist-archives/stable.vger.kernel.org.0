Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E66408E8A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbhIMNfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240679AbhIMNch (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD20661368;
        Mon, 13 Sep 2021 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539552;
        bh=E7xl6sl5aXICv+yvtADSMdwGsKCvfw4DCGPr4TIpfMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKCsGk6W35Y7TMdyz9L2UgvDXvHfYh+d6K4RXJ2EHebKOmTHY6f2xo/yo/fu9on3o
         bayq7sNsoAoLvtoV6v7HlA7UHhLTzqDeqPZuJGV/aat1eENYf6N0ZS7VQOxFAR1p/n
         vAUL5oalN1M6pNn4TppwxUWP/qs4lFm/vvzpknw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/236] libata: fix ata_host_start()
Date:   Mon, 13 Sep 2021 15:12:11 +0200
Message-Id: <20210913131101.239120376@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 61c762961ca8..44f434acfce0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5573,7 +5573,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2C0411F07
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351975AbhITRgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351734AbhITRes (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:34:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DA061B1D;
        Mon, 20 Sep 2021 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157557;
        bh=oTBW6XUuhknbqKs+Jvdfwrz8zVlzu29Nj5RUC1hNxZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKPbfTJkIyvtl9Gi/t9BfVPi0YBXZ7xn9C6zxbjjZF9VI00tWsKnL0q/TVlKznKtb
         k10rFqnfJryZ2Vv9i0KaBwEAfbKfOBnP+ytqDj4iXgFpd/O3l0BQpeEuA92ROnnFhQ
         SQcST0c5LvdGpwSAOZTBefJSQgCFMK/aqaYEK12k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/293] libata: fix ata_host_start()
Date:   Mon, 20 Sep 2021 18:40:08 +0200
Message-Id: <20210920163934.838787604@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index db1d86af21b4..d9b1c3e95592 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6412,7 +6412,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
-- 
2.30.2




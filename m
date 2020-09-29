Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0BA27C491
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgI2LPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729477AbgI2LO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36AC620848;
        Tue, 29 Sep 2020 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378095;
        bh=oqfgm3QiMflCw7HWafNqLL+eZ5LDEC54GAEMgL79QS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRIXf2YgPANAPibCFMAF1PDzrotvJIQdeqQskMHTiB95eqxbh7Nm2JmF25+JYn36o
         qYZC83/7U2JuC2QN8oaEATst3tScpXuxYsXKe8gaeb3JFwdV4VjEoeWT8kAwKgs68F
         jnSoYKro9xtLhVVn3TYMFTnJHwJjqlulp0umIA0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Satish Kharat <satishkh@cisco.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 029/166] scsi: fnic: fix use after free
Date:   Tue, 29 Sep 2020 12:59:01 +0200
Message-Id: <20200929105936.661936933@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit ec990306f77fd4c58c3b27cc3b3c53032d6e6670 ]

The memory chunk io_req is released by mempool_free. Accessing
io_req->start_time will result in a use after free bug. The variable
start_time is a backup of the timestamp. So, use start_time here to
avoid use after free.

Link: https://lore.kernel.org/r/1572881182-37664-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d79ac0b24f5af..04c25ca2be45f 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1034,7 +1034,8 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 
-	io_duration_time = jiffies_to_msecs(jiffies) - jiffies_to_msecs(io_req->start_time);
+	io_duration_time = jiffies_to_msecs(jiffies) -
+						jiffies_to_msecs(start_time);
 
 	if(io_duration_time <= 10)
 		atomic64_inc(&fnic_stats->io_stats.io_btw_0_to_10_msec);
-- 
2.25.1




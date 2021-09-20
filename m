Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C8411BB6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbhITRBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344919AbhITQ7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D9D0613DB;
        Mon, 20 Sep 2021 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156759;
        bh=EH6zae6M1SVc1wJPqjJMdqsFNcQXuxHHyJatFnedv4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1yWuKhbW+ehPstKfXPt7iNmQWtvVp3eR7e1TKJPitc8aUydBf/aWuIstGw0EcIgj
         N3GQD6C2IQhlCY3tggx/OcBhtQ11o+/zdJyQHDLwCd2lr54gR1zBDfI4YR5V3kpTx7
         +zTL+f6Z+A7tM39ol0gS0pZ3yXROkJtq2wysjsrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/175] libata: fix ata_host_start()
Date:   Mon, 20 Sep 2021 18:41:30 +0200
Message-Id: <20210920163919.404031673@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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




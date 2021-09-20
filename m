Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E24D4121BD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358910AbhITSIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358464AbhITSGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:06:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A378D61A0B;
        Mon, 20 Sep 2021 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158280;
        bh=7jspRymjruWv8ZVQQoIyyjjJyKqgfsOq/RILWjA1krM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOkSGxU76kx/sOdP5peqG/azaiCMs3ihCBI+wlhjkdUQuOtodKVDbIsqmROkqLx1n
         lO4g3B5UwmU5Th2Y5UfMVqJpP2UCT1ipQZN7GH/3Mm+YuQr4U5/EpN1KWf+2GGEixK
         FDfrHc3ah6bRo+dItnDFKqR9CFhD9Zs4sjzJN/l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Li <liwei391@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/260] scsi: fdomain: Fix error return code in fdomain_probe()
Date:   Mon, 20 Sep 2021 18:41:09 +0200
Message-Id: <20210920163932.842490887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit 632c4ae6da1d629eddf9da1e692d7617c568c256 ]

If request_region() fails the return value is not set. Return -EBUSY on
error.

Link: https://lore.kernel.org/r/20210715032625.1395495-1-liwei391@huawei.com
Fixes: 8674a8aa2c39 ("scsi: fdomain: Add PCMCIA support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pcmcia/fdomain_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/fdomain_cs.c b/drivers/scsi/pcmcia/fdomain_cs.c
index e42acf314d06..33df6a9ba9b5 100644
--- a/drivers/scsi/pcmcia/fdomain_cs.c
+++ b/drivers/scsi/pcmcia/fdomain_cs.c
@@ -45,8 +45,10 @@ static int fdomain_probe(struct pcmcia_device *link)
 		goto fail_disable;
 
 	if (!request_region(link->resource[0]->start, FDOMAIN_REGION_SIZE,
-			    "fdomain_cs"))
+			    "fdomain_cs")) {
+		ret = -EBUSY;
 		goto fail_disable;
+	}
 
 	sh = fdomain_create(link->resource[0]->start, link->irq, 7, &link->dev);
 	if (!sh) {
-- 
2.30.2




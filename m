Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E173B40E5E2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbhIPRQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349473AbhIPROE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CC1261414;
        Thu, 16 Sep 2021 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810360;
        bh=7jspRymjruWv8ZVQQoIyyjjJyKqgfsOq/RILWjA1krM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3qkpy/JU8QwUNVqZ+2+cr4j0nHpRhoRWY2GwdHvhbyWfL/YLHhIKjE4addEX17LZ
         JPwp5spJ8Gwuw1PMeeeLKpAATNLjtDk8dw3l3MmdquofhIYIxFEOnQDxEiup+jtAaP
         2MC54qXc9DhN8krDNSNqXYliKOA97J7Jb3ckisFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Li <liwei391@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 112/432] scsi: fdomain: Fix error return code in fdomain_probe()
Date:   Thu, 16 Sep 2021 17:57:41 +0200
Message-Id: <20210916155814.567145547@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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




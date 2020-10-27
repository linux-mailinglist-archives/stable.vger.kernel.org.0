Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0748629B8F4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802122AbgJ0Ppl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801072AbgJ0Pil (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853BE207C4;
        Tue, 27 Oct 2020 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813121;
        bh=a7tWooIq1JwVf+nKvVRDjSP9fBHenH+DxoBQ0HKZLSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/tx7ibwudX2Byn4hcpKDP022AjAeVXluD6ermt+4X6Px36ikdexmL+DmwduARoHL
         jRzPzwdzHho4zEsQ9Z1ISkJgfkVTQzAb1lVXkWcIGxtUvE3aHkrYbvd19Q1fP/0fgL
         UBkK9x+N889k0b4HHcLJqBoAbO4WlMI7Eb9ZUHwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 414/757] mtd: mtdoops: Dont write panic data twice
Date:   Tue, 27 Oct 2020 14:51:04 +0100
Message-Id: <20201027135509.997384837@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit c1cf1d57d1492235309111ea6a900940213a9166 ]

If calling mtdoops_write, don't also schedule work to be done later.

Although this appears to not be causing an issue, possibly because the
scheduled work will never get done, it is confusing.

Fixes: 016c1291ce70 ("mtd: mtdoops: do not use mtd->panic_write directly")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200903034217.23079-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdoops.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 4ced68be7ed7e..774970bfcf859 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -279,12 +279,13 @@ static void mtdoops_do_dump(struct kmsg_dumper *dumper,
 	kmsg_dump_get_buffer(dumper, true, cxt->oops_buf + MTDOOPS_HEADER_SIZE,
 			     record_size - MTDOOPS_HEADER_SIZE, NULL);
 
-	/* Panics must be written immediately */
-	if (reason != KMSG_DUMP_OOPS)
+	if (reason != KMSG_DUMP_OOPS) {
+		/* Panics must be written immediately */
 		mtdoops_write(cxt, 1);
-
-	/* For other cases, schedule work to write it "nicely" */
-	schedule_work(&cxt->work_write);
+	} else {
+		/* For other cases, schedule work to write it "nicely" */
+		schedule_work(&cxt->work_write);
+	}
 }
 
 static void mtdoops_notify_add(struct mtd_info *mtd)
-- 
2.25.1




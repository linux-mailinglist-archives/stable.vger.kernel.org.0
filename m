Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5D8148404
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732546AbgAXLj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391302AbgAXLXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:18 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70F8A2075D;
        Fri, 24 Jan 2020 11:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864998;
        bh=YdAfbQfol7iLVmy1tcVmFriFRtKJyYqLD0iEgrL2Xkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKkt3B4v4L4k22rIcE0bj58+0rF16/7sENjVQKbw4yyRUBVqVTiqLA1NVbeqXVNT6
         hGfZqgqkkA4GWvfH5vbEP3nqL7jlFidaewsO24UaNShTv+SJY0v5ck4DKBfBX9G943
         kk//ykEpzkpSU5Cipcb9FvSY1o9gifHCs0ryyQps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 424/639] ntb_hw_switchtec: potential shift wrapping bug in switchtec_ntb_init_sndev()
Date:   Fri, 24 Jan 2020 10:29:54 +0100
Message-Id: <20200124093140.149032964@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ff148d8ac53e59802645bd3200c811620317eb9f ]

This code triggers a Smatch warning:

    drivers/ntb/hw/mscc/ntb_hw_switchtec.c:884 switchtec_ntb_init_sndev()
    warn: should '(1 << sndev->peer_partition)' be a 64 bit type?

The "part_map" and "tpart_vec" variables are u64 type so this seems like
a valid warning.

Fixes: 3df54c870f52 ("ntb_hw_switchtec: Allow using Switchtec NTB in multi-partition setups")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index 9916bc5b6759a..313f6258c4249 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -899,7 +899,7 @@ static int switchtec_ntb_init_sndev(struct switchtec_ntb *sndev)
 		}
 
 		sndev->peer_partition = ffs(tpart_vec) - 1;
-		if (!(part_map & (1 << sndev->peer_partition))) {
+		if (!(part_map & (1ULL << sndev->peer_partition))) {
 			dev_err(&sndev->stdev->dev,
 				"ntb target partition is not NT partition\n");
 			return -ENODEV;
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FFB13F4CE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389438AbgAPSv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388813AbgAPRIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51ED7217F4;
        Thu, 16 Jan 2020 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194516;
        bh=1uCPHsfJfr26GFduXu+QhjfWliFP3cSM3VNE+SKE9mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVe/z2gNIz2GhWettHuIGsPYARs6GAdS48g9vibW3NL65AZfXHqX7dxhCsrEvC2hg
         nI+DjfVVmVSo8Z4/1bM2Ur86iCu/rcfSJbJG1BGx/5A/oJki9eqTZbajP8QyOUAOWV
         C0NwGTzBs/0H7WCYMg/5bfCb2BzWSpvuqBmp0Dy0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org, linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 409/671] ntb_hw_switchtec: potential shift wrapping bug in switchtec_ntb_init_sndev()
Date:   Thu, 16 Jan 2020 12:00:47 -0500
Message-Id: <20200116170509.12787-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9916bc5b6759..313f6258c424 100644
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


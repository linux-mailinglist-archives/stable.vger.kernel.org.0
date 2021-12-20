Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032E247ADA2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbhLTOxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:53:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56306 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbhLTOv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:51:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13ACDB80EA3;
        Mon, 20 Dec 2021 14:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1E5C36AE8;
        Mon, 20 Dec 2021 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011883;
        bh=/THDhsvWfIVPoM3Axdg1QxX3JSh4KL+g2HrU8RCAF/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7ozq+40I+L5ITblqvwqRsnBWuaW1dI0pYLhkxyojJBWE98joHUxNrUBZApWYucoK
         dvNQOOu9ZaU6/uZ8q/KMyZ8VOBAHV9yUoUnqCW6U5s33tD9lL2urgLrAGn58wCQh3+
         JDYp3tp2qUbPh8URyJ3S4oQdlYXHBV/olGSmnA/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.15 001/177] reset: tegra-bpmp: Revert Handle errors in BPMP response
Date:   Mon, 20 Dec 2021 15:32:31 +0100
Message-Id: <20211220143040.108477747@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 69125b4b9440be015783312e1b8753ec96febde0 upstream.

Commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
response") fixed an issue in the Tegra BPMP error handling but has
exposed an issue in the Tegra194 HDA driver and now resetting the
Tegra194 HDA controller is failing. For now revert the commit
c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP response")
while a fix for the Tegra HDA driver is created.

Fixes: c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP response")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20211112112712.21587-1-jonathanh@nvidia.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/tegra/reset-bpmp.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/reset/tegra/reset-bpmp.c
+++ b/drivers/reset/tegra/reset-bpmp.c
@@ -20,7 +20,6 @@ static int tegra_bpmp_reset_common(struc
 	struct tegra_bpmp *bpmp = to_tegra_bpmp(rstc);
 	struct mrq_reset_request request;
 	struct tegra_bpmp_message msg;
-	int err;
 
 	memset(&request, 0, sizeof(request));
 	request.cmd = command;
@@ -31,13 +30,7 @@ static int tegra_bpmp_reset_common(struc
 	msg.tx.data = &request;
 	msg.tx.size = sizeof(request);
 
-	err = tegra_bpmp_transfer(bpmp, &msg);
-	if (err)
-		return err;
-	if (msg.rx.ret)
-		return -EINVAL;
-
-	return 0;
+	return tegra_bpmp_transfer(bpmp, &msg);
 }
 
 static int tegra_bpmp_reset_module(struct reset_controller_dev *rstc,



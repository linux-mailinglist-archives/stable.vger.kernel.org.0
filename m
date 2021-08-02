Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679D63DD989
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbhHBOBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236442AbhHBN7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C02861185;
        Mon,  2 Aug 2021 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912539;
        bh=pla7McmYxp1G0LJaZfhMGfn9YoZxcBk/02lvATrKxxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcUtL9QIbxCe8p3wMnTNyJ+o8GZtiCrFiZLOSsF0H0HmdTYLts2gmjbI1XVJzqpff
         OZ2Bg177rR6hKBeiyh7Smlehe/joQROsR0Jj0mqOBmaprkZRw+eXUSHkXBC+H3hewK
         0qKMn2+mB6WCmUtLBH9PqzvHfDqL/ho4OnQx+yOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 038/104] platform/x86: amd-pmc: Fix missing unlock on error in amd_pmc_send_cmd()
Date:   Mon,  2 Aug 2021 15:44:35 +0200
Message-Id: <20210802134345.273054305@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 95edbbf78c3bdbd1daa921dd4a2e61c751e469ba ]

Add the missing unlock before return from function amd_pmc_send_cmd()
in the error handling case.

Fixes: 95e1b60f8dc8 ("platform/x86: amd-pmc: Fix command completion code")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210715074327.1966083-1-yangyingliang@huawei.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd-pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index b1d6175a13b2..ca95c2a52e26 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -140,7 +140,7 @@ static int amd_pmc_send_cmd(struct amd_pmc_dev *dev, bool set)
 				PMC_MSG_DELAY_MIN_US * RESPONSE_REGISTER_LOOP_MAX);
 	if (rc) {
 		dev_err(dev->dev, "failed to talk to SMU\n");
-		return rc;
+		goto out_unlock;
 	}
 
 	/* Write zero to response register */
-- 
2.30.2




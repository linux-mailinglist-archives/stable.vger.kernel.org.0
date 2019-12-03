Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A757C111D7E
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbfLCWyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbfLCWyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1AA720674;
        Tue,  3 Dec 2019 22:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413645;
        bh=AK+0iL2K88+4zjkWg6cRz/Q8lxIKszoqmc5G3IFXL+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8oQiIuKMuTIIUOJEXpJQp9nVrXkc2OpeVg1Q9Q2ozzyKPT8qgrdBIfpn3n+fopk1
         34KTMIhVErLzdt1siSMOjVeNMgc4x/V50ZEfXYbxx2avCdPE3CzMj5/UGJjGZXtyVs
         23XbTqnC3r3nSIJtex/GxNEisWbEAw4K1cGhV9nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 206/321] firmware: arm_sdei: fix wrong of_node_put() in init function
Date:   Tue,  3 Dec 2019 23:34:32 +0100
Message-Id: <20191203223437.838369982@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit c3790b3799f8d75d93d26f6fd7bb569fc8c8b0cb ]

After finding a "firmware" dt node arm_sdei tries to match it's
compatible string with it. To do so it's calling of_find_matching_node()
which already takes care of decreasing the refcount on the "firmware"
node. We are then incorrectly decreasing the refcount on that node
again.

This patch removes the unwarranted call to of_node_put().

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_sdei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 1ea71640fdc21..dffb47c6b4801 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -1017,7 +1017,6 @@ static bool __init sdei_present_dt(void)
 		return false;
 
 	np = of_find_matching_node(fw_np, sdei_of_match);
-	of_node_put(fw_np);
 	if (!np)
 		return false;
 
-- 
2.20.1




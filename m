Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A622E406F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502014AbgL1OSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501994AbgL1OSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DC120731;
        Mon, 28 Dec 2020 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165107;
        bh=s1oEkqfG9jsu1oDvQlDms4ayNZqjUoDXfzrFZ7EjhZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09t/eTNs739o3ef8DTms2Q+nKNkuzzQd2cb9akmAQzM5DMjmAYc51B71H/cWwSOeF
         0SR5z/7MEUsiUF6Me56VZiNbxPJA2KAmI/yYBaOG1uJQ8rIwwu0hUjN1tZm0SveaSh
         TAj/mg8Y1HM5YReSPoDFIap66sNqTUGDOdguTnH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/717] bus: fsl-mc: fix error return code in fsl_mc_object_allocate()
Date:   Mon, 28 Dec 2020 13:46:22 +0100
Message-Id: <20201228125039.400949280@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 3d70fb03711c37bc64e8e9aea5830f498835f6bf ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 197f4d6a4a00 ("staging: fsl-mc: fsl-mc object allocator driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1607068967-31991-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-allocator.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-allocator.c b/drivers/bus/fsl-mc/fsl-mc-allocator.c
index e71a6f52ea0cf..2d7c764bb7dcf 100644
--- a/drivers/bus/fsl-mc/fsl-mc-allocator.c
+++ b/drivers/bus/fsl-mc/fsl-mc-allocator.c
@@ -292,8 +292,10 @@ int __must_check fsl_mc_object_allocate(struct fsl_mc_device *mc_dev,
 		goto error;
 
 	mc_adev = resource->data;
-	if (!mc_adev)
+	if (!mc_adev) {
+		error = -EINVAL;
 		goto error;
+	}
 
 	mc_adev->consumer_link = device_link_add(&mc_dev->dev,
 						 &mc_adev->dev,
-- 
2.27.0




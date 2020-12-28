Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50522E39E2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390074AbgL1N3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:29:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390071AbgL1N3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B04322582;
        Mon, 28 Dec 2020 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162142;
        bh=xkZ1PEFI5kz0fzas/LW9v4P1MedotAipZm0Cc48zFn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTd+yd+a895O7b4iXS8aUXUVanwW+88S4V2+K/zBPaKiPMOhTELZjcjizTaUQ8T79
         pH1d/d61XsW8+xyGOeRlarPBpmpn2PgHdBoDy6wLvK3zI5bcXnq/iF4yJRIqpQWeBa
         97kgX/qcmuFgVzHmEIrEZhXEpJMAS6ekN8AMkzOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/346] dm ioctl: fix error return code in target_message
Date:   Mon, 28 Dec 2020 13:48:41 +0100
Message-Id: <20201228124929.560391640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 4d7659bfbe277a43399a4a2d90fca141e70f29e1 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 2ca4c92f58f9 ("dm ioctl: prevent empty message")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f666778ad2372..439277f48ff8b 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1575,6 +1575,7 @@ static int target_message(struct file *filp, struct dm_ioctl *param, size_t para
 
 	if (!argc) {
 		DMWARN("Empty message received.");
+		r = -EINVAL;
 		goto out_argv;
 	}
 
-- 
2.27.0




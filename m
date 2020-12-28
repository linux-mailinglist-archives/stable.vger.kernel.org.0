Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C117E2E3B4B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405858AbgL1NsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405848AbgL1NsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F7572063A;
        Mon, 28 Dec 2020 13:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163256;
        bh=DUlG3BMwoXm2Aeu2oI04bS28BlZs6eKXCWDhxWlwD4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfWGWA+nU6RngS1/NsqPZJ14T6HAycyDS1XeZMCz4N7sPY3xBInIbkvzqMMVyriXa
         nPXBxyayAyPrzg6+rg1xHNs4M1nhxL4FGG/aSka2Y5f1oLKfAFTynDiQZrd1ddfuFu
         RMXAwTpWTlbPZ0359JL65cRmUJavBfCAlJGNNNAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/453] dm ioctl: fix error return code in target_message
Date:   Mon, 28 Dec 2020 13:47:39 +0100
Message-Id: <20201228124947.950548514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index ac83f5002ce5f..1c5133f71af39 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1600,6 +1600,7 @@ static int target_message(struct file *filp, struct dm_ioctl *param, size_t para
 
 	if (!argc) {
 		DMWARN("Empty message received.");
+		r = -EINVAL;
 		goto out_argv;
 	}
 
-- 
2.27.0




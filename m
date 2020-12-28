Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE62E37F9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgL1NDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:03:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730225AbgL1NDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:03:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFDF222582;
        Mon, 28 Dec 2020 13:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160570;
        bh=wXBaScD4/w/XArzcbfOiAv5YV72PALyJRo9O6USkGNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkpHp8ob+85qdot2jEYH311ky2T9PD8ROQBfdjJ6eHmbAdnGB9ROdkX22j/T5QZx/
         7H2kyZPEHu3m041oVhRgYO0zMSrvoX6XMGhsz9AwMwU+VAOeGHiKpjyPPHImpPUUA9
         jSfCqb0zCEnpqiq5WXncgZ4WeLFSm7RUWMl5GXZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 096/175] dm ioctl: fix error return code in target_message
Date:   Mon, 28 Dec 2020 13:49:09 +0100
Message-Id: <20201228124857.897615525@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 6964b252952a4..836a2808c0c71 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1549,6 +1549,7 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
 
 	if (!argc) {
 		DMWARN("Empty message received.");
+		r = -EINVAL;
 		goto out_argv;
 	}
 
-- 
2.27.0




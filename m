Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780422E3AED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391447AbgL1Nn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:43:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404439AbgL1NnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6366E20719;
        Mon, 28 Dec 2020 13:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162962;
        bh=HnOhffahLUjkw78ZedWdR3NbMXwGxnTSBqkS1Nm+iwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVu6snvoNjfTIg7cP3igRjhjlZoSTfi0nhuF6p1IqvAs5y1lJBXThR/E1o5OACx3Z
         MZLM5fLzEH5YMn0hoP0b6OLFjvA2HZZvM5qZKkPGAh/0Fr4HHqxKCM8RlwAbG0GhIs
         rwU2gDSpE9r4rOG/hynitGkS5Dteja3eni4R8KmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/453] spi: spi-mem: fix reference leak in spi_mem_access_start
Date:   Mon, 28 Dec 2020 13:45:40 +0100
Message-Id: <20201228124942.224114893@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit c02bb16b0e826bf0e19aa42c3ae60ea339f32cf5 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in spi_mem_access_start, so we should fix it.

Fixes: f86c24f479530 ("spi: spi-mem: Split spi_mem_exec_op() code")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201103140910.3482-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index de0ba3e5449fa..33115bcfc787e 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -237,6 +237,7 @@ static int spi_mem_access_start(struct spi_mem *mem)
 
 		ret = pm_runtime_get_sync(ctlr->dev.parent);
 		if (ret < 0) {
+			pm_runtime_put_noidle(ctlr->dev.parent);
 			dev_err(&ctlr->dev, "Failed to power device: %d\n",
 				ret);
 			return ret;
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377BE148436
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390797AbgAXLlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390276AbgAXLS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:56 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CAA52075D;
        Fri, 24 Jan 2020 11:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864735;
        bh=IIbvXaX8A539yHpVEbWLR+RBbu4LU+EBaZ4KPYSjYVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8cAgEUeF2Mr7nSTFw6bs7HuVWW6wt0bdoWcYdjnf1P0oI4N0SNNAQgw+B9n6XsuI
         eV+Y0HMyT4z/1Kk1SLR/AGZhQ2+qXdCN1JOlqVSuF5oYaO2h2XejRtIzdivpY0gC2R
         uL5N1kwU/l9U2EvHFTLJEXqKrZK2mbvlHzLhqPOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 351/639] mmc: core: fix possible use after free of host
Date:   Fri, 24 Jan 2020 10:28:41 +0100
Message-Id: <20200124093131.087638678@linuxfoundation.org>
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

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 8e1943af2986db42bee2b8dddf49a36cdb2e9219 ]

In the function mmc_alloc_host, the function put_device is called to
release allocated resources when mmc_gpio_alloc fails. Finally, the
function pointed by host->class_dev.class->dev_release (i.e.,
mmc_host_classdev_release) is used to release resources including the
host structure. However, after put_device, host is used and released
again. Resulting in a use-after-free bug.

Fixes: 1ed217194488 ("mmc: core: fix error path in mmc_host_alloc")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/host.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index f57f5de542064..dd1c14d8f6863 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -385,8 +385,6 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
 	if (mmc_gpio_alloc(host)) {
 		put_device(&host->class_dev);
-		ida_simple_remove(&mmc_host_ida, host->index);
-		kfree(host);
 		return NULL;
 	}
 
-- 
2.20.1




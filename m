Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6644147D06
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388452AbgAXJ4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387619AbgAXJ4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:56:19 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A212075D;
        Fri, 24 Jan 2020 09:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859779;
        bh=RaM3AQNDx5keEU/B0Ed8iNvzoZfpatDZnrpwchZzY4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMGlv8HZrd60UZkSiavSowEqvQRXe9/NZZzWJyu3aRfTPQGdmsIrX/RFITk19O+FU
         zCmJ6Jn6hdTuzuf1vvPhYtjfsc4uMIZJoHbPcNpcj3mAIJLLe1M1DiD+t3mSRTrd6a
         aYV3ep5V/1eWxLnoT6X5gzqnoZlPm4bXSbSMEqbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 193/343] mmc: core: fix possible use after free of host
Date:   Fri, 24 Jan 2020 10:30:11 +0100
Message-Id: <20200124092945.367908383@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index ad88deb2e8f3b..3740fb0052a49 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -376,8 +376,6 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
 	if (mmc_gpio_alloc(host)) {
 		put_device(&host->class_dev);
-		ida_simple_remove(&mmc_host_ida, host->index);
-		kfree(host);
 		return NULL;
 	}
 
-- 
2.20.1




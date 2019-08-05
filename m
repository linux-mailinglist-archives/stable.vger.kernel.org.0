Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8A381C71
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbfHENXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730829AbfHENXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 281AC20651;
        Mon,  5 Aug 2019 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011429;
        bh=V2Q70GTfv3oZzNZd5F8MMLlNY9oeJq+bcMPgLj65Nq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wT57fk8b5ZtA0+FcAchO2G1ETX8AquRgnRh6rt4eR+8DyjazsVjUFKIiejgGHDi76
         qyv735LBVXU9IfjvXKq7CYjk2ipgNQ1bXARLp5oUQFG5B4/zOuKVDUuunpG4GNutMQ
         uZuE2efy5I8mW5Wp7VMMnwjX4CPi+hSGdqIrI1dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.2 085/131] mmc: host: sdhci-sprd: Fix the missing pm_runtime_put_noidle()
Date:   Mon,  5 Aug 2019 15:02:52 +0200
Message-Id: <20190805124957.654638392@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linaro.org>

commit fc62113b32c95906b3ea8ba42e91014c7d0c6fa6 upstream.

When the SD host controller tries to probe again due to the derferred
probe mechanism, it will always keep the SD host device as runtime
resume state due to missing the runtime put operation in error path
last time.

Thus add the pm_runtime_put_noidle() in error path to make the PM runtime
counter balance, which can make the SD host device's PM runtime work well.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-sprd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -405,6 +405,7 @@ err_cleanup_host:
 	sdhci_cleanup_host(host);
 
 pm_runtime_disable:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8DF111C6D
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfLCWoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbfLCWoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA5162073C;
        Tue,  3 Dec 2019 22:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413043;
        bh=nAX1jztnTArJns5G3zDXl5/umt/1KT8SVroE95f7pao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUfIx4EbURUmg5rYYkHHxCsK/goKbmUrj5UsqDRZMtZ0Zk1YGnFyoIyJQpJPvrjo5
         cezuLMJpnC4JVeAt4H06wADmscF7WDaYqaA6myzDWtYwK+XsEIOqjnjzI5vyzo0CqW
         ofvHWgnA61iBDuMFRA3qVHWF5ACyJwe8H9zzh+M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 113/135] net: macb: add missed tasklet_kill
Date:   Tue,  3 Dec 2019 23:35:53 +0100
Message-Id: <20191203213042.298448731@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 61183b056b49e2937ff92a1424291ba36a6f6d05 ]

This driver forgets to kill tasklet in remove.
Add the call to fix it.

Fixes: 032dc41ba6e2 ("net: macb: Handle HRESP error")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4393,6 +4393,7 @@ static int macb_remove(struct platform_d
 		mdiobus_free(bp->mii_bus);
 
 		unregister_netdev(dev);
+		tasklet_kill(&bp->hresp_err_tasklet);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		if (!pm_runtime_suspended(&pdev->dev)) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9DF3C4591
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbhGLG0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234750AbhGLGZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C91B361132;
        Mon, 12 Jul 2021 06:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070943;
        bh=C0/WtTy7uGcfywJh/Bg7FSsNQVVNIIPRGXcN/8bDiWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bs2/xuAXMb8mNSPbMC0Z5W9JyKs20cmqWRqibiMRAEL1mgr5loppJ2Pqa2cQ5e0Gi
         e/eEV4l457AX1It34FsROjal7NWausTq7VpM+FjarR3KgT6J6MBVG2izwZJYJjt/10
         y0LN9e7ZqUq8eQKqrXq99qQDfmtjs97QRjH8YLgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/348] ssb: Fix error return code in ssb_bus_scan()
Date:   Mon, 12 Jul 2021 08:09:49 +0200
Message-Id: <20210712060728.752393566@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 77a0989baa427dbd242c5784d05a53ca3d197d43 ]

Fix to return -EINVAL from the error handling case instead of 0, as done
elsewhere in this function.

Fixes: 61e115a56d1a ("[SSB]: add Sonics Silicon Backplane bus support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Michael Büsch <m@bues.ch>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210515072949.7151-1-thunder.leizhen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ssb/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 6ceee98ed6ff..5c7e61cafd19 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -325,6 +325,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 	if (bus->nr_devices > ARRAY_SIZE(bus->devices)) {
 		pr_err("More than %d ssb cores found (%d)\n",
 		       SSB_MAX_NR_CORES, bus->nr_devices);
+		err = -EINVAL;
 		goto err_unmap;
 	}
 	if (bus->bustype == SSB_BUSTYPE_SSB) {
-- 
2.30.2




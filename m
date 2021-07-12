Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84D3C4E18
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243564AbhGLHQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243375AbhGLHPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26A74613EE;
        Mon, 12 Jul 2021 07:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073926;
        bh=HH/oR1MAak1gZXBUdVPQsHiHbw5NhvczZv1qs8GQY2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zB+460lt49bfJCud0GAH/cQjX1FMHoF4PNLbH8hc2epJaDK0yOALcvZg2HizYhX6z
         PsLGe3K11M1MAdH5rRQifQ6KkOrpmKVLvqSo5/7gV6X96faRHAVvSagO98q2P1PZ6r
         kk8Q2t6dBdwGex03OYhIaoetgLdmOJReoV8djxtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 407/700] ssb: Fix error return code in ssb_bus_scan()
Date:   Mon, 12 Jul 2021 08:08:10 +0200
Message-Id: <20210712061019.673555506@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index f49ab1aa2149..4161e5d1f276 100644
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




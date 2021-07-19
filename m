Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A203CDD1A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbhGSO4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238789AbhGSOyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F7D661285;
        Mon, 19 Jul 2021 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708787;
        bh=C0/WtTy7uGcfywJh/Bg7FSsNQVVNIIPRGXcN/8bDiWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YToZWnuTrOs4Y8nHDqW2J6Vj2ISczQGNE2FD6s9cVUjLvn+cSDdsBjpM735waIaFd
         Lj3R+gBprqqJh4AyHI3ZHtydtR5TsxNUR+NNJQjGr30E9F952iBnWqW1t5MdDHeCTK
         dlidLfje8/28uRdcAQzUQMvsjrw0BXrx3dj9+GR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/421] ssb: Fix error return code in ssb_bus_scan()
Date:   Mon, 19 Jul 2021 16:49:01 +0200
Message-Id: <20210719144951.033376112@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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




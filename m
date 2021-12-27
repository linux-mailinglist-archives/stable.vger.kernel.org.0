Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A3B4803B0
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhL0TEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39890 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhL0TEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671716116E;
        Mon, 27 Dec 2021 19:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22341C36AE7;
        Mon, 27 Dec 2021 19:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631875;
        bh=TUmadFdk29V/j4ip7iNaRZQKjQD47/UXTdGrnEcl7YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWgUNWAysH39/7bBhF+2IolWTLueLjA3hj4uiWxVo+ig7K6zvhzUVr7TPeaBvEbhq
         hfzotdkzLGuYYkpOrBvbRwo3Ul98tT3eSJN2oSwRF3G8YoMZt/AipzpIs6yoXoPtxK
         WnBOOHx60RGx/+Od09QEKc0g0qKzfsdKCj+jLKX5zQ4P/x51WGh0ZmEYCx0hBD2/62
         Q2Y97EbLHGKBfQrD6au08Rwxdj0WWW1YuyCaQJzDaJhhkg1hLZT/Am+b2QcqJBBuYB
         yjeucVEah0NQPSwPqgEjz7CNG+BUnkF49a0EtGNMITxWvzFGXc9T+Y/USs1He2ZN5j
         1mavp90MgQ5YQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/26] platform/x86: apple-gmux: use resource_size() with res
Date:   Mon, 27 Dec 2021 14:03:23 -0500
Message-Id: <20211227190327.1042326-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit eb66fb03a727cde0ab9b1a3858de55c26f3007da ]

This should be (res->end - res->start + 1) here actually,
use resource_size() derectly.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Link: https://lore.kernel.org/r/1639484316-75873-1-git-send-email-wangqing@vivo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/apple-gmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 9aae45a452002..57553f9b4d1dc 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -625,7 +625,7 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	}
 
 	gmux_data->iostart = res->start;
-	gmux_data->iolen = res->end - res->start;
+	gmux_data->iolen = resource_size(res);
 
 	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
 		pr_err("gmux I/O region too small (%lu < %u)\n",
-- 
2.34.1


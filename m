Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7710448042F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhL0THv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhL0TGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AB4C061D60;
        Mon, 27 Dec 2021 11:06:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A843B81131;
        Mon, 27 Dec 2021 19:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503C3C36AEC;
        Mon, 27 Dec 2021 19:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640632006;
        bh=rcBFzJiCpsMCVAnHMP3OqwJO1EfdOVbUt3w6i8HljE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1+GSn+BqXskZSba5kfxuBOIMhja0AygHBjkxPTxO45mI3SHmqJkJlx/K+dHM+avA
         GsbKlnKkd4Yksmfdm7mo7fugwcgWxI7nt3RE2NqrfCT5WKtUiQF6PMGJta4ThesiVu
         QEqPXNSWuq6fh6yCbSmO9sKo0RkOKbYor8wekKrqqEaI6EZF5T7b5ovcX5Pt7IueZZ
         p9+WLDTuWxmnE2Hhmt2ihX1ivV/U8zplCpKG5M55AMdZJWxngDSUHh7XxMnDML3KQJ
         ctw99tRK3fMJ1FFU0WaNCsRawdoSt08xOxfpqJFjNoOMRItm2Ur+pQR4dWIawDjf9S
         x5n+uxVl+D9Vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/4] platform/x86: apple-gmux: use resource_size() with res
Date:   Mon, 27 Dec 2021 14:06:29 -0500
Message-Id: <20211227190629.1043445-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190629.1043445-1-sashal@kernel.org>
References: <20211227190629.1043445-1-sashal@kernel.org>
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
index 7c4eb86c851ed..5463d740f3523 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -628,7 +628,7 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	}
 
 	gmux_data->iostart = res->start;
-	gmux_data->iolen = res->end - res->start;
+	gmux_data->iolen = resource_size(res);
 
 	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
 		pr_err("gmux I/O region too small (%lu < %u)\n",
-- 
2.34.1


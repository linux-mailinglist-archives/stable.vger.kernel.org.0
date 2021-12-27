Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9143D480413
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhL0THL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:07:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42856 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhL0TGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 037FFB8114B;
        Mon, 27 Dec 2021 19:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23217C36AEA;
        Mon, 27 Dec 2021 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631968;
        bh=8rDkRL47WMlHdIagHXZwKR3Pclr3OqxqXZVbc6O+kOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHUXobQ6PWbcYMVejvx9Kyn7SQ7QUZ951MluJ7JlvVMi4d1yNRaDTvnD1mstC+t6i
         qIcgBTT97Kr6uBKEQj3YocZH9vy7l6oN589UQG0buduORD75krBtl6F+jTRi+HIFwU
         Yio54SePbmhRiZwkR7c10QBfAFhCxzKkRx/o0vEyJtdtFg2HUHQLPGRbL87IFhbX5E
         PTI9dtwNTpM8ej/0E3u/1TclmeBzB/7LqGYxf4XegM2I/GcNMJfSZ93DYzytc5C565
         y4AARTAzW9nwF+RDFW3tmbJuETU7V0abCT0vjvOPT1NXu3vTKrlf/t/YI+LFlkBNZ4
         iNiIoUXZKdFaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 8/9] platform/x86: apple-gmux: use resource_size() with res
Date:   Mon, 27 Dec 2021 14:05:35 -0500
Message-Id: <20211227190536.1042975-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190536.1042975-1-sashal@kernel.org>
References: <20211227190536.1042975-1-sashal@kernel.org>
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
index 7e3083deb1c5d..1b86005c0f5f4 100644
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


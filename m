Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA0480445
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhL0TIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhL0THL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:07:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED98C0698C8;
        Mon, 27 Dec 2021 11:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E8EE1CE1153;
        Mon, 27 Dec 2021 19:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9052FC36AED;
        Mon, 27 Dec 2021 19:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640632013;
        bh=RbbBhYv7tJD/nX0IphEc7Q9+M0qPa5iA4CJGq0LLQN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbyTAWtc7/b0pfp4RFNN93wE4cp9HKkdsqzBYW4eOO3BwnYVBub1B7Ji37O5hg7lo
         3pkNGBhde3HMn7sqYhN4FzTHfu57RbgIfeBxJQmGHxTB+U+05TtGW5ZnjUYa0jZ4Ro
         sqNTbBgf7jCIDh00WzigPTb6cec52oLDyF1Zdkp92KMQ/yh5r30lZu2vdgC1vgJK1P
         zRWssxkzUF4ISauqMCK8BZJ7O18mdAWpr79q/cKP762rthVM4Rt+gDHcrpiUJOe6oo
         AMyXBNTAaojrXb8uFAbz3gulVMaI9gMlfUy0X1U+uebvFp5xRGdthI42KivtQbZjr+
         Y0g75EEAzLcsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/4] platform/x86: apple-gmux: use resource_size() with res
Date:   Mon, 27 Dec 2021 14:06:46 -0500
Message-Id: <20211227190647.1043514-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190647.1043514-1-sashal@kernel.org>
References: <20211227190647.1043514-1-sashal@kernel.org>
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
index a66be137324c0..76f5703bc4f65 100644
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


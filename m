Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C9A29AEC7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754057AbgJ0OD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754049AbgJ0ODy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:03:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 287DC22281;
        Tue, 27 Oct 2020 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807433;
        bh=TqZIMtcPRGxicGhzsyZKtIsWlsRediNHd8EMURjpfJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzwRLSkyorW9N6xLZYbuYCe7QU0fEjHwiz/W+h8uR7fjHEQpKlAIvAq4Tnk6gzG+M
         l65YoaDlPDMVRlSVPhK6bb6UfqBIPvpn7NAkRe84ERLgSG2xe6Qo46YSGKCFoCrfiF
         5d+jtIPGeMOlboE7zumdsfK78GhMzEyvC5dEFz+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 034/139] backlight: sky81452-backlight: Fix refcount imbalance on error
Date:   Tue, 27 Oct 2020 14:48:48 +0100
Message-Id: <20201027134903.763670810@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dinghao.liu@zju.edu.cn <dinghao.liu@zju.edu.cn>

[ Upstream commit b7a4f80bc316a56d6ec8750e93e66f42431ed960 ]

When of_property_read_u32_array() returns an error code, a
pairing refcount decrement is needed to keep np's refcount
balanced.

Fixes: f705806c9f355 ("backlight: Add support Skyworks SKY81452 backlight driver")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/sky81452-backlight.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
index d414c7a3acf5a..a2f77625b7170 100644
--- a/drivers/video/backlight/sky81452-backlight.c
+++ b/drivers/video/backlight/sky81452-backlight.c
@@ -207,6 +207,7 @@ static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
 					num_entry);
 		if (ret < 0) {
 			dev_err(dev, "led-sources node is invalid.\n");
+			of_node_put(np);
 			return ERR_PTR(-EINVAL);
 		}
 
-- 
2.25.1




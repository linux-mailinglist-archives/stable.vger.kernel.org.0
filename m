Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EEA29C29E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820754AbgJ0Rh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760574AbgJ0OfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FC7207BB;
        Tue, 27 Oct 2020 14:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809315;
        bh=jk++oXg9ZuIaZJ4ij8Qs7cweRKYW8CKYUpAEO/LCNbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bO5o2/1smxRXxdhr4hiNj70IXIcw/EK1vZJ7AbVLBA96JM1l9nEG/ZybO9vzdL4t+
         SaS9oN66DNhEsKvWViXcdsobk6Lv1phpO8m+HIuVpy0vGAx7oyMtvf3NL0SG32oIte
         fzasQVvwibbdbzh5TBtnvZ6dTLlssQKSngxE7e+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/408] backlight: sky81452-backlight: Fix refcount imbalance on error
Date:   Tue, 27 Oct 2020 14:51:00 +0100
Message-Id: <20201027135500.768910201@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 2355f00f57732..1f6301375fd33 100644
--- a/drivers/video/backlight/sky81452-backlight.c
+++ b/drivers/video/backlight/sky81452-backlight.c
@@ -196,6 +196,7 @@ static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
 					num_entry);
 		if (ret < 0) {
 			dev_err(dev, "led-sources node is invalid.\n");
+			of_node_put(np);
 			return ERR_PTR(-EINVAL);
 		}
 
-- 
2.25.1




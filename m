Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3614F67
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfEFOfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbfEFOe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECDAC204EC;
        Mon,  6 May 2019 14:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153298;
        bh=PuL3a0B9fgKz9ClSWerIzJ28wEGAGiOI9Ak3uVJSAKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjhmIQROwZYP/msLfBM1hz7c53HrJbJDK9JwAspvUCjUqRLOJ2sbzsnP5X7UfbBre
         13W9KWkBuOqcGpd4yeZxrEOU0TdD0P19xDa+YoUawzl10SgpnZkBrQrNq5M9cZavw0
         lGYSrtwyQR8QnnSr3lYvZ6wWwJylOoI1pz1l7EaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 037/122] reset: meson-audio-arb: Fix missing .owner setting of reset_controller_dev
Date:   Mon,  6 May 2019 16:31:35 +0200
Message-Id: <20190506143058.220264188@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 13e8a05b922457761ddef39cfff6231bd4ed9eef ]

Set .owner to prevent module unloading while being used.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Fixes: d903779b58be ("reset: meson: add meson audio arb driver")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/reset/reset-meson-audio-arb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/reset-meson-audio-arb.c b/drivers/reset/reset-meson-audio-arb.c
index 91751617b37a..c53a2185a039 100644
--- a/drivers/reset/reset-meson-audio-arb.c
+++ b/drivers/reset/reset-meson-audio-arb.c
@@ -130,6 +130,7 @@ static int meson_audio_arb_probe(struct platform_device *pdev)
 	arb->rstc.nr_resets = ARRAY_SIZE(axg_audio_arb_reset_bits);
 	arb->rstc.ops = &meson_audio_arb_rstc_ops;
 	arb->rstc.of_node = dev->of_node;
+	arb->rstc.owner = THIS_MODULE;
 
 	/*
 	 * Enable general :
-- 
2.20.1




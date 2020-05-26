Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C531E2E12
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390931AbgEZTEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390046AbgEZTEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:04:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25DDF2086A;
        Tue, 26 May 2020 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519872;
        bh=fpAopg94cQ1HN7cQwkhltWI4ZSP8d8nqZTOwX4niM2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz7xgS93u2lS9msFUKZM4H3gpAQskUlD7bCcSKLulWgt6lfGgB9/WYFwgb42HLmTb
         XTaTgCXjJmy6NS0bvY+8Wf+kn3bFAz+2GKrpk+16AT0CZzX+KNzkaVflX9ZpbgyLAA
         u9v6+5Bwej/6QbapmHp4Je+d/jTxhpYkwq+vjiKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/81] i2c: mux: demux-pinctrl: Fix an error handling path in i2c_demux_pinctrl_probe()
Date:   Tue, 26 May 2020 20:52:48 +0200
Message-Id: <20200526183927.685548579@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e9d1a0a41d4486955e96552293c1fcf1fce61602 ]

A call to 'i2c_demux_deactivate_master()' is missing in the error handling
path, as already done in the remove function.

Fixes: 50a5ba876908 ("i2c: mux: demux-pinctrl: add driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index 035032e20327..9ba9ce5696e1 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -273,6 +273,7 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 err_rollback_available:
 	device_remove_file(&pdev->dev, &dev_attr_available_masters);
 err_rollback:
+	i2c_demux_deactivate_master(priv);
 	for (j = 0; j < i; j++) {
 		of_node_put(priv->chan[j].parent_np);
 		of_changeset_destroy(&priv->chan[j].chgset);
-- 
2.25.1




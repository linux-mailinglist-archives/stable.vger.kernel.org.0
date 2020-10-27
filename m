Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F80129BEBF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814532AbgJ0Q4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794133AbgJ0PKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20DBA206F4;
        Tue, 27 Oct 2020 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811405;
        bh=FSvAIpnhNCNuGvMx00olHNgd0THutUntu+SxvBB86PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwJ/Ic9NjzcQmSua8I0JvPbtWcyrJ5qCckDOTdAv2nv0fbuRGzvmwMV2iYV+hbH5G
         3ELCRTLHGYL4+4UsKmrMHx1d1WQ6QSHM3gIL7ZmNnTudcKrKc3JIcL2fqlgxWguEQc
         gnHoEXBso8wz+kAOee7ptBcPf3u7UB0NxzGlSNX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 451/633] clk: bcm2835: add missing release if devm_clk_hw_register fails
Date:   Tue, 27 Oct 2020 14:53:14 +0100
Message-Id: <20201027135543.871854857@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit f6c992ca7dd4f49042eec61f3fb426c94d901675 ]

In the implementation of bcm2835_register_pll(), the allocated pll is
leaked if devm_clk_hw_register() fails to register hw. Release pll if
devm_clk_hw_register() fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20200809231202.15811-1-navid.emamdoost@gmail.com
Fixes: 41691b8862e2 ("clk: bcm2835: Add support for programming the audio domain clocks")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 011802f1a6df9..f18b4d9e9455b 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1337,8 +1337,10 @@ static struct clk_hw *bcm2835_register_pll(struct bcm2835_cprman *cprman,
 	pll->hw.init = &init;
 
 	ret = devm_clk_hw_register(cprman->dev, &pll->hw);
-	if (ret)
+	if (ret) {
+		kfree(pll);
 		return NULL;
+	}
 	return &pll->hw;
 }
 
-- 
2.25.1




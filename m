Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2713B205CDD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbgFWUGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388434AbgFWUGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F7182064B;
        Tue, 23 Jun 2020 20:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942767;
        bh=YQzDgZMPbzczhG4i5DdTEFSE2uOTgTBDkfVfUpFdBcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUov1h1vSPMG5sBt2T2Rux2DR9TmU3g3yc5WhojFIxPsgDY4058T7UDsJ9FGTpT2l
         3gqwv+PMWkPDRYrXf9NBKRGkDJSJ0FJYae/H/5VQa8KzSZptYxDs0klERw47ZPfxGB
         GdGzbDAuPVKFqFoDsatZDLsso5ELuLAubW6LyLeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 127/477] pinctrl: rza1: Fix wrong array assignment of rza1l_swio_entries
Date:   Tue, 23 Jun 2020 21:52:04 +0200
Message-Id: <20200623195413.610762143@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit 4b4e8e93eccc2abc4209fe226ec89e7fbe9f3c61 ]

The rza1l_swio_entries referred to the wrong array rza1h_swio_pins,
which was intended to be rza1l_swio_pins. So let's fix it.

This is detected by the following gcc warning:

drivers/pinctrl/pinctrl-rza1.c:401:35: warning: ‘rza1l_swio_pins’
defined but not used [-Wunused-const-variable=]
 static const struct rza1_swio_pin rza1l_swio_pins[] = {
                                   ^~~~~~~~~~~~~~~

Fixes: 039bc58e73b77723 ("pinctrl: rza1: Add support for RZ/A1L")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20200417111604.19143-1-yanaijie@huawei.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rza1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rza1.c b/drivers/pinctrl/pinctrl-rza1.c
index da2d8365c690e..ff4a7fb518bb3 100644
--- a/drivers/pinctrl/pinctrl-rza1.c
+++ b/drivers/pinctrl/pinctrl-rza1.c
@@ -418,7 +418,7 @@ static const struct rza1_bidir_entry rza1l_bidir_entries[RZA1_NPORTS] = {
 };
 
 static const struct rza1_swio_entry rza1l_swio_entries[] = {
-	[0] = { ARRAY_SIZE(rza1h_swio_pins), rza1h_swio_pins },
+	[0] = { ARRAY_SIZE(rza1l_swio_pins), rza1l_swio_pins },
 };
 
 /* RZ/A1L (r7s72102x) pinmux flags table */
-- 
2.25.1




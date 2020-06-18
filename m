Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012BD1FE2A6
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732309AbgFRCDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731027AbgFRBXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F104F214DB;
        Thu, 18 Jun 2020 01:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443418;
        bh=OUWjkozM3sAKULP9nNpNr0tWDlusZ8MW5m5GDzWq7TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8v4tBTmjpijQbMWUMxmBd3LG/DdNlmdT6IOoUnlEds+vF41JYMnZjEop933Ghhzf
         aLXduPFGQILOdg8m9bwIBrez8aUj34SJ4dOmv/LaVsheCgNKBnadkLz0fRQN/2G4Qp
         MJSGLij8wN1nh3KHOewlJGMNF/rYY9yy9pxkv9Yg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 060/172] pinctrl: rza1: Fix wrong array assignment of rza1l_swio_entries
Date:   Wed, 17 Jun 2020 21:20:26 -0400
Message-Id: <20200618012218.607130-60-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index f76edf664539..021c19eaf12d 100644
--- a/drivers/pinctrl/pinctrl-rza1.c
+++ b/drivers/pinctrl/pinctrl-rza1.c
@@ -421,7 +421,7 @@ static const struct rza1_bidir_entry rza1l_bidir_entries[RZA1_NPORTS] = {
 };
 
 static const struct rza1_swio_entry rza1l_swio_entries[] = {
-	[0] = { ARRAY_SIZE(rza1h_swio_pins), rza1h_swio_pins },
+	[0] = { ARRAY_SIZE(rza1l_swio_pins), rza1l_swio_pins },
 };
 
 /* RZ/A1L (r7s72102x) pinmux flags table */
-- 
2.25.1


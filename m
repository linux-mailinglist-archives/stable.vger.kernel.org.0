Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48F2E3D0E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439045AbgL1OKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439036AbgL1OKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C5020731;
        Mon, 28 Dec 2020 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164590;
        bh=S8sMrHdDg2ydeurMPLXxMaseCJmh6DdF930ZHZWsMPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=di/xp2N7cseM3NjIStmZ94TXKO+5A5zxao6r1Tpy7RjvjE3ut9EZV3X28u/qZ2+Nh
         Ei/eDskj9SwqCs2HOjSVZLx5+ZIvRVOC7qL/8AAGdD0RmkgIdmadxtzEBlazeFQUzx
         KoXO9ffIqmTWf+F5jyhQf8+AHJthZjTmuOfYn2qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/717] power: supply: bq25890: Use the correct range for IILIM register
Date:   Mon, 28 Dec 2020 13:43:46 +0100
Message-Id: <20201228125031.911777430@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit d4e9e7b6f7ae37a99bc11ce9efe6e8bdc711362f ]

I've checked bq25890, bq25892, bq25895 and bq25896 datasheets and
they all define IILIM to be between 100mA-3.25A with 50mA steps.

Fixes: 478efc79ee32 ("power: bq25890: implement INPUT_CURRENT_LIMIT property")
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index 34c21c51bac10..945c3257ca931 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -299,7 +299,7 @@ static const union {
 	/* TODO: BQ25896 has max ICHG 3008 mA */
 	[TBL_ICHG] =	{ .rt = {0,	  5056000, 64000} },	 /* uA */
 	[TBL_ITERM] =	{ .rt = {64000,   1024000, 64000} },	 /* uA */
-	[TBL_IILIM] =   { .rt = {50000,   3200000, 50000} },	 /* uA */
+	[TBL_IILIM] =   { .rt = {100000,  3250000, 50000} },	 /* uA */
 	[TBL_VREG] =	{ .rt = {3840000, 4608000, 16000} },	 /* uV */
 	[TBL_BOOSTV] =	{ .rt = {4550000, 5510000, 64000} },	 /* uV */
 	[TBL_SYSVMIN] = { .rt = {3000000, 3700000, 100000} },	 /* uV */
-- 
2.27.0




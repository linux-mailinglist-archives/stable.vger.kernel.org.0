Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE7A14BA77
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbgA1Oi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbgA1OR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:17:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8623B2071E;
        Tue, 28 Jan 2020 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221077;
        bh=qmJjiJ99+W8iC6cIjfFZaHyJJ4qyWKtTW8YYhpJqQdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsGVwpXBUPkD/8t+1h2eVgMNN1T4+F/AYjOP3Pn+sHphWvpG9quGt3+yuAnxeDw7f
         GUg7lmfIGQ6VkezoEaKJjIHS7V6jgSEpRJ/2/Gyi3rocJpMW0tawtaPA+BtYeexEc+
         ZivpbnyZhAknptYVtZqRXMa7icJNX4RebkKSPCJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 080/271] regulator: pv88090: Fix array out-of-bounds access
Date:   Tue, 28 Jan 2020 15:03:49 +0100
Message-Id: <20200128135858.510377269@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit a5455c9159414748bed4678184bf69989a4f7ba3 ]

Fix off-by-one while iterating current_limits array.
The valid index should be 0 ~ n_current_limits -1.

Fixes: c90456e36d9c ("regulator: pv88090: new regulator driver")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pv88090-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pv88090-regulator.c b/drivers/regulator/pv88090-regulator.c
index 4216411753529..789652c9b0142 100644
--- a/drivers/regulator/pv88090-regulator.c
+++ b/drivers/regulator/pv88090-regulator.c
@@ -157,7 +157,7 @@ static int pv88090_set_current_limit(struct regulator_dev *rdev, int min,
 	int i;
 
 	/* search for closest to maximum */
-	for (i = info->n_current_limits; i >= 0; i--) {
+	for (i = info->n_current_limits - 1; i >= 0; i--) {
 		if (min <= info->current_limits[i]
 			&& max >= info->current_limits[i]) {
 			return regmap_update_bits(rdev->regmap,
-- 
2.20.1




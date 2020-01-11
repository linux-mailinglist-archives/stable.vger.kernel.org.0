Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B321137FED
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbgAKKW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbgAKKW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:22:59 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C780205F4;
        Sat, 11 Jan 2020 10:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738178;
        bh=5+KBnVdLRuk87lNb6TdfP6q2MkTmfaix4p79kTqEKBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUefFcL5vGsi+8Tl2kdHN0WFvOQC0Ijtz/9q9aHZVdNn+6QlCt/bhcCdHOEJrCire
         E2vcfiVFdE9g3VtrEiCPDVAjCZGNm5nQU72Em3MspXO1bB/EY6BvV23/emdYaA1z1d
         nddqHyiPN0AkWgj5iw9YR0/ssKFKpcQzSQdblLdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/165] reset: Do not register resource data for missing resets
Date:   Sat, 11 Jan 2020 10:49:23 +0100
Message-Id: <20200111094924.584538805@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit db23808615e29d9a04f96806cac56f78b0fee0ef ]

When an optional reset is not present, __devm_reset_control_get() and
devm_reset_control_array_get() still register resource data to release
the non-existing reset on cleanup, which is futile.

Fix this by skipping NULL reset control pointers.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 3c9a64c1b7a8..f343bd814d32 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -787,7 +787,7 @@ struct reset_control *__devm_reset_control_get(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	rstc = __reset_control_get(dev, id, index, shared, optional, acquired);
-	if (!IS_ERR(rstc)) {
+	if (!IS_ERR_OR_NULL(rstc)) {
 		*ptr = rstc;
 		devres_add(dev, ptr);
 	} else {
@@ -930,7 +930,7 @@ devm_reset_control_array_get(struct device *dev, bool shared, bool optional)
 		return ERR_PTR(-ENOMEM);
 
 	rstc = of_reset_control_array_get(dev->of_node, shared, optional, true);
-	if (IS_ERR(rstc)) {
+	if (IS_ERR_OR_NULL(rstc)) {
 		devres_free(devres);
 		return rstc;
 	}
-- 
2.20.1




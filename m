Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFB122EED0
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgG0OLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729439AbgG0OK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:10:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C81BF208E4;
        Mon, 27 Jul 2020 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859058;
        bh=xAwsdarEG2CBrklf9ot9VZhvrow2vneesuNuCyiKZP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPDOtVnfgKP1Fq30y340Hm9YewH/sAD/KVIf+rQ827/6VFY3AZ3fUSxzHePzlkXej
         dmEih1wKe5LS03CZFpurE/Kv5GdxAZZvKAGQfYrJ3Fn9pg1g8GG1eb2ISbgmiGGruA
         emTPG/crhqe5ju2V9LdnaGViSIgJWqg4huESCmEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/86] regmap: dev_get_regmap_match(): fix string comparison
Date:   Mon, 27 Jul 2020 16:04:24 +0200
Message-Id: <20200727134916.919700195@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit e84861fec32dee8a2e62bbaa52cded6b05a2a456 ]

This function is used by dev_get_regmap() to retrieve a regmap for the
specified device. If the device has more than one regmap, the name parameter
can be used to specify one.

The code here uses a pointer comparison to check for equal strings. This
however will probably always fail, as the regmap->name is allocated via
kstrdup_const() from the regmap's config->name.

Fix this by using strcmp() instead.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20200703103315.267996-1-mkl@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c7d946b745efe..d26b485ccc7d0 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1343,7 +1343,7 @@ static int dev_get_regmap_match(struct device *dev, void *res, void *data)
 
 	/* If the user didn't specify a name match any */
 	if (data)
-		return (*r)->name == data;
+		return !strcmp((*r)->name, data);
 	else
 		return 1;
 }
-- 
2.25.1




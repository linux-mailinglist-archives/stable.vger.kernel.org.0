Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609F42E41E6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438168AbgL1POo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438027AbgL1OGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 305CC20791;
        Mon, 28 Dec 2020 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164386;
        bh=5Yj+Icl0cTkfiOcHrsPRlfV0BgvmHbw5Ijx5i1JtqAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLCWEbf2DZlcpaEn+MJ+7azK7JVUsFGtF/ln7kzxYsQxHBkwwnmOIYfDapdhmRkFx
         M8dVilCKok2Z27bVytcu/EF38AwQrOm3JyRAu0O/VwimIvy2yXaCx7IGNGzDmBnSwM
         V0JIPmrgGBRVrywa3SucWvL3TsO836HMwCtnRRfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/717] mfd: stmfx: Fix dev_err_probe() call in stmfx_chip_init()
Date:   Mon, 28 Dec 2020 13:42:40 +0100
Message-Id: <20201228125028.718295346@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit d75846ed08e6f4135ec73778575c34d9c0ace993 ]

'ret' may be 0 so, dev_err_probe() should be called only when 'ret' is
an error code.

Fixes: 41c9c06c491a ("mfd: stmfx: Simplify with dev_err_probe()")
Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmfx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/stmfx.c b/drivers/mfd/stmfx.c
index 5e680bfdf5c90..988e2ba6dd0f3 100644
--- a/drivers/mfd/stmfx.c
+++ b/drivers/mfd/stmfx.c
@@ -329,11 +329,11 @@ static int stmfx_chip_init(struct i2c_client *client)
 
 	stmfx->vdd = devm_regulator_get_optional(&client->dev, "vdd");
 	ret = PTR_ERR_OR_ZERO(stmfx->vdd);
-	if (ret == -ENODEV) {
-		stmfx->vdd = NULL;
-	} else {
-		return dev_err_probe(&client->dev, ret,
-				     "Failed to get VDD regulator\n");
+	if (ret) {
+		if (ret == -ENODEV)
+			stmfx->vdd = NULL;
+		else
+			return dev_err_probe(&client->dev, ret, "Failed to get VDD regulator\n");
 	}
 
 	if (stmfx->vdd) {
-- 
2.27.0




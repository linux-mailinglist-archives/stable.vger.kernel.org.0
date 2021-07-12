Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560F73C52B8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbhGLHs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244622AbhGLHql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC7061179;
        Mon, 12 Jul 2021 07:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075731;
        bh=8W3RUkEHB4v2frl4OKWOZaffvM2a+5owA7ywGcAXGqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvr3miI4GWmfnsVPvRJiO5Zw/iwO1QGWar4NMCK1EUcfLqk5zXfW24j1DcC9ptFeF
         wUYq/jecg824y2DxJYR1fpBn6kBI6X3Oh6kphRdWRqVwH0rpeZAjAFzZnsgRF5EOUH
         x4d9cKLhXQ0u28V1ZdoVt+TMbXJXUFvb9Htp4zwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 288/800] crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()
Date:   Mon, 12 Jul 2021 08:05:11 +0200
Message-Id: <20210712060955.521808241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 5c8552325e013cbdabc443cd1f1b4d03c4a2e64e ]

The pm_runtime APIs added first in commit 7694b6ca649f ("crypto: sa2ul -
Add crypto driver") are not unwound properly and was fixed up partially
in commit 13343badae09 ("crypto: sa2ul - Fix PM reference leak in
sa_ul_probe()"). This fixed up the pm_runtime usage count but not the
state. Fix this properly.

Fixes: 13343badae09 ("crypto: sa2ul - Fix PM reference leak in sa_ul_probe()")
Signed-off-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Tero Kristo <kristo@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 3d6f0af2f938..a215daedf78a 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2411,6 +2411,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "%s: failed to get sync: %d\n", __func__,
 			ret);
+		pm_runtime_disable(dev);
 		return ret;
 	}
 
-- 
2.30.2




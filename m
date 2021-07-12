Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A33C48BC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhGLGks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238268AbhGLGkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9254261004;
        Mon, 12 Jul 2021 06:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071805;
        bh=NAktyUN9j26p8yi015dYrs/ZVMHrynn/pCaN5d/a0kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LgHXztm6Px7GBj1Ip7hFszc6p60Z+zlu9jvSSUvT3HofxNCcWM0z3MMasYL5L23+
         rDKF9QPc8GC1Jg7K1w+B2BB/lkN6hhA3V00dFBoXTMgPyf3vmYC8beYo1E/63B6k/f
         zPNn93sOGE0JQws2F92ro+YOcFkfi36cHtd7kSfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/593] crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()
Date:   Mon, 12 Jul 2021 08:06:27 +0200
Message-Id: <20210712060907.915227931@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index fdc844363f02..f15fc1fb3707 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2356,6 +2356,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "%s: failed to get sync: %d\n", __func__,
 			ret);
+		pm_runtime_disable(dev);
 		return ret;
 	}
 
-- 
2.30.2




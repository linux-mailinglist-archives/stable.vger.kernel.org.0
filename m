Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C297328D64
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbhCATJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241046AbhCATFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:05:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CDFF65305;
        Mon,  1 Mar 2021 17:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620511;
        bh=HuvaGODZbp3hurLAhBmhqPUiJR9JIRrXi8xF1vFELTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFa6V3QX7Vq+ceXN6E/QLulyeILuinK8+CrNy+IkWmKmZml5dPwG0o2sBidNkn201
         mYKd5c80azuidDFy1SVxJciegGoVmhReHEgqs6vqgPFqPX8cx8FsuJPWuOk0wmlIQo
         F6hSJey4MENE01D3w1D0VZPTjI3+j98zyLlP5BQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 180/775] hwrng: ingenic - Fix a resource leak in an error handling path
Date:   Mon,  1 Mar 2021 17:05:48 +0100
Message-Id: <20210301161210.526712977@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c4ff41b93d1f10d1b8be258c31a0436c5769fc00 ]

In case of error, we should call 'clk_disable_unprepare()' to undo a
previous 'clk_prepare_enable()' call, as already done in the remove
function.

Fixes: 406346d22278 ("hwrng: ingenic - Add hardware TRNG for Ingenic X1830")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ingenic-trng.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ingenic-trng.c b/drivers/char/hw_random/ingenic-trng.c
index 954a8411d67d2..0eb80f786f4dd 100644
--- a/drivers/char/hw_random/ingenic-trng.c
+++ b/drivers/char/hw_random/ingenic-trng.c
@@ -113,13 +113,17 @@ static int ingenic_trng_probe(struct platform_device *pdev)
 	ret = hwrng_register(&trng->rng);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register hwrng\n");
-		return ret;
+		goto err_unprepare_clk;
 	}
 
 	platform_set_drvdata(pdev, trng);
 
 	dev_info(&pdev->dev, "Ingenic DTRNG driver registered\n");
 	return 0;
+
+err_unprepare_clk:
+	clk_disable_unprepare(trng->clk);
+	return ret;
 }
 
 static int ingenic_trng_remove(struct platform_device *pdev)
-- 
2.27.0




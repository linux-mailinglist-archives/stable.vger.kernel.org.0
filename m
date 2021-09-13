Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DECA40940C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345833AbhIMO1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241377AbhIMOZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F55361B4E;
        Mon, 13 Sep 2021 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540929;
        bh=nIyUI+QqX2rUHWQesdYJXYi01xir+nzDH0SyBxhYbTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWrv+BQqxEpGp15M8eA3AD6fM+q5byrZaC990LFwERAj8LdFCLLWy5QielmS/xmcL
         nq22UMCze+ib//lxrp+EVIDlWIvF3DQW32ULYb5YgHOZNZX4RzIkT7Lb/WkXcVKdj3
         w+8qzTnDNJvB64KOMQYmgLvTUVaCnyQ5lwWQZFEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 091/334] media: cxd2880-spi: Fix an error handling path
Date:   Mon, 13 Sep 2021 15:12:25 +0200
Message-Id: <20210913131116.463215848@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit dcb0145821017e929a733e2271c85c6f82b9c9f8 ]

If an error occurs after a successful 'regulator_enable()' call,
'regulator_disable()' must be called.

Fix the error handling path of the probe accordingly.

Fixes: cb496cd472af ("media: cxd2880-spi: Add optional vcc regulator")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/spi/cxd2880-spi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index e5094fff04c5..b91a1e845b97 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -524,13 +524,13 @@ cxd2880_spi_probe(struct spi_device *spi)
 	if (IS_ERR(dvb_spi->vcc_supply)) {
 		if (PTR_ERR(dvb_spi->vcc_supply) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
-			goto fail_adapter;
+			goto fail_regulator;
 		}
 		dvb_spi->vcc_supply = NULL;
 	} else {
 		ret = regulator_enable(dvb_spi->vcc_supply);
 		if (ret)
-			goto fail_adapter;
+			goto fail_regulator;
 	}
 
 	dvb_spi->spi = spi;
@@ -618,6 +618,9 @@ fail_frontend:
 fail_attach:
 	dvb_unregister_adapter(&dvb_spi->adapter);
 fail_adapter:
+	if (!dvb_spi->vcc_supply)
+		regulator_disable(dvb_spi->vcc_supply);
+fail_regulator:
 	kfree(dvb_spi);
 	return ret;
 }
-- 
2.30.2




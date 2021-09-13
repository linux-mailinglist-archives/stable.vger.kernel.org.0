Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0379B408EB7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbhIMNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240288AbhIMNcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:32:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7406861381;
        Mon, 13 Sep 2021 13:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539568;
        bh=QlaMXaMRG+4kSqbA/r2yAL3RAmk/iIhRCJraJNbA25A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcuGjleXNJyy8VbCrBRd71BDTmQtMU3D9loGGc/0QAPX0uo71HiYSvceMJeyi0AUh
         OlXFB5RFyo1T7G2b6ZIZ5lheq4qxrFDU9waCcRu26IqscndOE33Wz2zzkzfeuSHJM+
         zm3gjrAGa68nJLUoHV0k/nXP3jWmWd452Y/+7lwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/236] media: cxd2880-spi: Fix an error handling path
Date:   Mon, 13 Sep 2021 15:13:00 +0200
Message-Id: <20210913131102.917636134@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 4077217777f9..93194f03764d 100644
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




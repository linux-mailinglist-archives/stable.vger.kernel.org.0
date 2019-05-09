Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5AF19221
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfEISsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfEISsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:48:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 736F320578;
        Thu,  9 May 2019 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427696;
        bh=O4EPrr34U2tRAfhad++Hrv38U/CglpjqXgiIyrFJ74o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpPjTKpxlT9xKpxG5quaPNNl0V/7LYuwLu79lcXHAVOqbTJuVREOSZlfCydUO7sKy
         ZwXxYyQ2I7ugSk41lxKyqEiwdLwXhlCNbSKheGDMGD0lRpl0/cUnFiJVJea73NiHCV
         iAIbLgGcBIjglGEnBWjZaT9eF8muzB4I0HuHg1XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/66] ASoC: cs35l35: Disable regulators on driver removal
Date:   Thu,  9 May 2019 20:42:10 +0200
Message-Id: <20190509181305.727470185@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 47c4cc08cb5b34e93ab337b924c5ede77ca3c936 ]

The chips main power supplies VA and VP are enabled during probe but
then never disabled, this will cause warnings from the regulator
framework on driver removal. Fix this by adding a remove callback and
disabling the supplies, whilst doing so follow best practice and put the
chip back into reset as well.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l35.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/cs35l35.c b/sound/soc/codecs/cs35l35.c
index bd6226bde45f6..17e0101081ef6 100644
--- a/sound/soc/codecs/cs35l35.c
+++ b/sound/soc/codecs/cs35l35.c
@@ -1634,6 +1634,16 @@ static int cs35l35_i2c_probe(struct i2c_client *i2c_client,
 	return ret;
 }
 
+static int cs35l35_i2c_remove(struct i2c_client *i2c_client)
+{
+	struct cs35l35_private *cs35l35 = i2c_get_clientdata(i2c_client);
+
+	regulator_bulk_disable(cs35l35->num_supplies, cs35l35->supplies);
+	gpiod_set_value_cansleep(cs35l35->reset_gpio, 0);
+
+	return 0;
+}
+
 static const struct of_device_id cs35l35_of_match[] = {
 	{.compatible = "cirrus,cs35l35"},
 	{},
@@ -1654,6 +1664,7 @@ static struct i2c_driver cs35l35_i2c_driver = {
 	},
 	.id_table = cs35l35_id,
 	.probe = cs35l35_i2c_probe,
+	.remove = cs35l35_i2c_remove,
 };
 
 module_i2c_driver(cs35l35_i2c_driver);
-- 
2.20.1




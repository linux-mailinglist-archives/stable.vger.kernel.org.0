Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13A1328D83
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241156AbhCATMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236872AbhCATG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0CD64E74;
        Mon,  1 Mar 2021 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620666;
        bh=A4FxdFWPrYxuw0ZA0y+Nuq0y2ShyTdCD2qRkgY5rB3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvCKa3yAJzDpGNllsgx1NGWrscoZp7daLhldo09wBjDPnUkhvRoy1zi1te1VG0J3T
         m3U3QWj/QouMRpnNeuEB1OZT+zOg0NOsDZBBOKDcWi6yMUmJRddhC0bfkk0XRQa5C3
         31UZ+PC2OkFiK7ao5G5lhoK5YnDaXrtyJzTCJl38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 205/775] ASoC: cs42l56: fix up error handling in probe
Date:   Mon,  1 Mar 2021 17:06:13 +0100
Message-Id: <20210301161211.772386779@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 856fe64da84c95a1d415564b981ae3908eea2a76 ]

There are two issues with this code.  The first error path forgot to set
the error code and instead returns success.  The second error path
doesn't clean up.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X9NE/9nK9/TuxuL+@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index bb9599cc832bc..c44a5cdb796ec 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -1250,6 +1250,7 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 		dev_err(&i2c_client->dev,
 			"CS42L56 Device ID (%X). Expected %X\n",
 			devid, CS42L56_DEVID);
+		ret = -EINVAL;
 		goto err_enable;
 	}
 	alpha_rev = reg & CS42L56_AREV_MASK;
@@ -1307,7 +1308,7 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 	ret =  devm_snd_soc_register_component(&i2c_client->dev,
 			&soc_component_dev_cs42l56, &cs42l56_dai, 1);
 	if (ret < 0)
-		return ret;
+		goto err_enable;
 
 	return 0;
 
-- 
2.27.0




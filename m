Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAD5395D7A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhEaNqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhEaNob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:44:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3215D61574;
        Mon, 31 May 2021 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467760;
        bh=eT6wWRN516WVE+D+zEmmOZl6GD11Ltv5a0ObWmY9kj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhPMfashK+7SKAeBApq6lntO2dqpYa30ZIOmfCDYV/uZfrHzjwl5UCwr27u6JtVQn
         HUkPnssq+H5DeY4J+P/OPff6cGDZGpmFGyd8o6XwMjJHyZ1BVj8IEDCQAn1HzlpUBU
         JEzRgOOhB9DfYdfSWzvVQGlz/tAuzAtKPT5fcjDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 69/79] ASoC: cs35l33: fix an error code in probe()
Date:   Mon, 31 May 2021 15:14:54 +0200
Message-Id: <20210531130638.197242432@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 833bc4cf9754643acc69b3c6b65988ca78df4460 ]

This error path returns zero (success) but it should return -EINVAL.

Fixes: 3333cb7187b9 ("ASoC: cs35l33: Initial commit of the cs35l33 CODEC driver.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/YKXuyGEzhPT35R3G@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l33.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs35l33.c b/sound/soc/codecs/cs35l33.c
index 854cf8f27605..e2c1194ea61a 100644
--- a/sound/soc/codecs/cs35l33.c
+++ b/sound/soc/codecs/cs35l33.c
@@ -1206,6 +1206,7 @@ static int cs35l33_i2c_probe(struct i2c_client *i2c_client,
 		dev_err(&i2c_client->dev,
 			"CS35L33 Device ID (%X). Expected ID %X\n",
 			devid, CS35L33_CHIP_ID);
+		ret = -EINVAL;
 		goto err_enable;
 	}
 
-- 
2.30.2




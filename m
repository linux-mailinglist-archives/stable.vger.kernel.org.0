Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED6E2E40A1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441374AbgL1ORJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441369AbgL1ORJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7737722AAD;
        Mon, 28 Dec 2020 14:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164989;
        bh=Q60UCZxrw2ozqBbgnzkUMsK84+wPaDDO9eItx9L/cr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbVV/XTJoKT84pcr7yOj4KeMEduRpYI9EXyTl+mh1OlfaA2tAMHZMQGzJW3mc7F89
         dzWkPLXg+s8w9iMybAoX4yLzHmE+Lf9nmA5eXHJQmERii3Zz4I56jsgq7mUQzsY7KD
         a6RvGXjxlFSdvlGG4oJJnoJrh8muGZeWftg6G9BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 370/717] ASoC: max98390: Fix error codes in max98390_dsm_init()
Date:   Mon, 28 Dec 2020 13:46:08 +0100
Message-Id: <20201228125038.733987758@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3cea33b6f2d7782d1be17c71509986f33ee93541 ]

These error paths return success but they should return -EINVAL.

Fixes: 97ed3e509ee6 ("ASoC: max98390: Fix potential crash during param fw loading")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X9B0uz4svyNTqeMb@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98390.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/max98390.c b/sound/soc/codecs/max98390.c
index ff5cc9bbec291..bb736c44e68a3 100644
--- a/sound/soc/codecs/max98390.c
+++ b/sound/soc/codecs/max98390.c
@@ -784,6 +784,7 @@ static int max98390_dsm_init(struct snd_soc_component *component)
 	if (fw->size < MAX98390_DSM_PARAM_MIN_SIZE) {
 		dev_err(component->dev,
 			"param fw is invalid.\n");
+		ret = -EINVAL;
 		goto err_alloc;
 	}
 	dsm_param = (char *)fw->data;
@@ -794,6 +795,7 @@ static int max98390_dsm_init(struct snd_soc_component *component)
 		fw->size < param_size + MAX98390_DSM_PAYLOAD_OFFSET) {
 		dev_err(component->dev,
 			"param fw is invalid.\n");
+		ret = -EINVAL;
 		goto err_alloc;
 	}
 	regmap_write(max98390->regmap, MAX98390_R203A_AMP_EN, 0x80);
-- 
2.27.0




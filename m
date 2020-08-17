Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61652246B2A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbgHQPtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbgHQPt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:49:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80C892065D;
        Mon, 17 Aug 2020 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679369;
        bh=JEA0NdZUgq77O/7u7QLc4RQyD/hHbwBMkh5PrP5MDy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chDlST8b0Pk5Up3RILmvwe9lNz3BR3DOAfWXteDhhB7w5zMlVXlTdfEIINz4LzHqS
         xZsCBLbgeYG7KIsp02cjV0X+svTPUsuzW1MwFmCUSPhMPY9FI7Lev3GklGO9X6nUTM
         wfglOe4U+QWgr2vtT0rdeIRCNi18C8SjyqdY3GaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 157/393] ASoC: SOF: nocodec: add missing .owner field
Date:   Mon, 17 Aug 2020 17:13:27 +0200
Message-Id: <20200817143827.232406803@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 8753889e2720c1ef7ebf03370e384f5bf5ff4fab ]

This field is required for ASoC cards. Not setting it will result in a
module->name pointer being NULL and generate problems such as

cat /proc/asound/modules
 0 (efault)

Fixes: 8017b8fd37bf ('ASoC: SOF: Add Nocodec machine driver support')
Reported-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200625191308.3322-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/nocodec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/nocodec.c b/sound/soc/sof/nocodec.c
index 71cf5f9db79d0..849c3bcdca9ed 100644
--- a/sound/soc/sof/nocodec.c
+++ b/sound/soc/sof/nocodec.c
@@ -14,6 +14,7 @@
 
 static struct snd_soc_card sof_nocodec_card = {
 	.name = "nocodec", /* the sof- prefix is added by the core */
+	.owner = THIS_MODULE
 };
 
 static int sof_nocodec_bes_setup(struct device *dev,
-- 
2.25.1




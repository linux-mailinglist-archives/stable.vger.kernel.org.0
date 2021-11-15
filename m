Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820B545146D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349236AbhKOUFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344365AbhKOTYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EBB563672;
        Mon, 15 Nov 2021 18:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002602;
        bh=H0wQT68vi6MYvOemRXBNcnfwJukc5YCMfy6xT2d8qDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHVq8/dQXuk30ANeVGERz1K7Vy1bpU08nyuODa399+jYqQnflv3X/m/zMr306asi8
         jd8EXhzlfKRNmjtdJ/yVxXAYnlHfRD0YA8zEvzQ95NqOLl13gfTOWOMc3L/pDMA8sK
         BafWWUHBkYXLAmiWbUVckh4iPoiBF6sOi0W9esjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yassine Oudjana <y.oudjana@protonmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 596/917] ASoC: wcd9335: Use correct version to initialize Class H
Date:   Mon, 15 Nov 2021 18:01:31 +0100
Message-Id: <20211115165448.975220613@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit a270bd9abdc3cd04ec194f1f3164823cbb5a905c ]

The versioning scheme was changed in an earlier patch, which caused the version
being used to initialize WCD9335 to be interpreted as if it was WCD937X, which
changed code paths causing broken headphones output. Pass WCD9335 instead of
WCD9335_VERSION_2_0 to wcd_clsh_ctrl_alloc to fix it.

Fixes: 19c5d1f6a0c3 ("ASoC: codecs: wcd-clsh: add new version support")
Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210925022339.786296-1-y.oudjana@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index d885ced34f606..bc5d68c53e5ab 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -4859,7 +4859,7 @@ static int wcd9335_codec_probe(struct snd_soc_component *component)
 
 	snd_soc_component_init_regmap(component, wcd->regmap);
 	/* Class-H Init*/
-	wcd->clsh_ctrl = wcd_clsh_ctrl_alloc(component, wcd->version);
+	wcd->clsh_ctrl = wcd_clsh_ctrl_alloc(component, WCD9335);
 	if (IS_ERR(wcd->clsh_ctrl))
 		return PTR_ERR(wcd->clsh_ctrl);
 
-- 
2.33.0




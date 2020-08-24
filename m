Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B42824F8CE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgHXIrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbgHXIri (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:47:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43EA2206F0;
        Mon, 24 Aug 2020 08:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258857;
        bh=3Ej3eCQIkCDj0Or2d/txWft1A60P9a7pdqb2Z6788GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbhUijaQbEhA4gG1b1QvJQ48COVzkXkQEBrJSA6dvxbsPUVQ98QEjQ6qF19kfnI7Y
         Ma1aEHr9wvtgOz/8nGdWbsJ2UnQeU8SNiTv1oJBmBFBfrehNm77bYx5SfYbdKN1Uph
         CZIcdHgK3KH3zGgsl6F79sXo3jAnPs6VNe5IKgco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/107] ASoC: q6routing: add dummy register read/write function
Date:   Mon, 24 Aug 2020 10:30:34 +0200
Message-Id: <20200824082408.492073736@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 796a58fe2b8c9b6668db00d92512ec84be663027 ]

Most of the DAPM widgets for DSP ASoC components reuse reg field
of the widgets for its internal calculations, however these are not
real registers. So read/writes to these numbers are not really
valid. However ASoC core will read these registers to get default
state during startup.

With recent changes to ASoC core, every register read/write
failures are reported very verbosely. Prior to this fails to reads
are totally ignored, so we never saw any error messages.

To fix this add dummy read/write function to return default value.

Fixes: e3a33673e845 ("ASoC: qdsp6: q6routing: Add q6routing driver")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200811120205.21805-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6routing.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/q6routing.c b/sound/soc/qcom/qdsp6/q6routing.c
index ddcd9978cf57b..745cc9dd14f38 100644
--- a/sound/soc/qcom/qdsp6/q6routing.c
+++ b/sound/soc/qcom/qdsp6/q6routing.c
@@ -996,6 +996,20 @@ static int msm_routing_probe(struct snd_soc_component *c)
 	return 0;
 }
 
+static unsigned int q6routing_reg_read(struct snd_soc_component *component,
+				       unsigned int reg)
+{
+	/* default value */
+	return 0;
+}
+
+static int q6routing_reg_write(struct snd_soc_component *component,
+			       unsigned int reg, unsigned int val)
+{
+	/* dummy */
+	return 0;
+}
+
 static const struct snd_soc_component_driver msm_soc_routing_component = {
 	.ops = &q6pcm_routing_ops,
 	.probe = msm_routing_probe,
@@ -1004,6 +1018,8 @@ static const struct snd_soc_component_driver msm_soc_routing_component = {
 	.num_dapm_widgets = ARRAY_SIZE(msm_qdsp6_widgets),
 	.dapm_routes = intercon,
 	.num_dapm_routes = ARRAY_SIZE(intercon),
+	.read = q6routing_reg_read,
+	.write = q6routing_reg_write,
 };
 
 static int q6pcm_routing_probe(struct platform_device *pdev)
-- 
2.25.1




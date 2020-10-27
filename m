Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2661129B819
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799454AbgJ0Pbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799448AbgJ0Pbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFEB622264;
        Tue, 27 Oct 2020 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812694;
        bh=mhzYQj5KSeDFLRpIDX5A9SUN2fe1XUuYOAmgzmCT5yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzlNCnqjoHceTHb2SdWuwCXD/c/hDJ6LMtkUFBTWqMGReun912jNPBlrfumO4wyYV
         82thFwSTYd7ctGKevgSUAgeD2fegyybKcteVhiGUypVbgSz99FrBFgI+1ztCUrtqYr
         2NpCEiKf8p5qZ+cLd2K1QKOZCWKvdh8+Ae2TOV90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 298/757] ASoC: SOF: control: add size checks for ext_bytes control .put()
Date:   Tue, 27 Oct 2020 14:49:08 +0100
Message-Id: <20201027135504.538721206@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 2ca210112ad91880d2d5a3f85fecc838600afbce ]

Make sure the TLV header and size are consistent before copying from
userspace.

Fixes: c3078f5397046 ('ASoC: SOF: Add Sound Open Firmware KControl support')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200921110814.2910477-4-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/control.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/sof/control.c b/sound/soc/sof/control.c
index 186eea105bb15..009938d45ddd9 100644
--- a/sound/soc/sof/control.c
+++ b/sound/soc/sof/control.c
@@ -298,6 +298,10 @@ int snd_sof_bytes_ext_put(struct snd_kcontrol *kcontrol,
 	const struct snd_ctl_tlv __user *tlvd =
 		(const struct snd_ctl_tlv __user *)binary_data;
 
+	/* make sure we have at least a header */
+	if (size < sizeof(struct snd_ctl_tlv))
+		return -EINVAL;
+
 	/*
 	 * The beginning of bytes data contains a header from where
 	 * the length (as bytes) is needed to know the correct copy
@@ -306,6 +310,13 @@ int snd_sof_bytes_ext_put(struct snd_kcontrol *kcontrol,
 	if (copy_from_user(&header, tlvd, sizeof(const struct snd_ctl_tlv)))
 		return -EFAULT;
 
+	/* make sure TLV info is consistent */
+	if (header.length + sizeof(struct snd_ctl_tlv) > size) {
+		dev_err_ratelimited(scomp->dev, "error: inconsistent TLV, data %d + header %zu > %d\n",
+				    header.length, sizeof(struct snd_ctl_tlv), size);
+		return -EINVAL;
+	}
+
 	/* be->max is coming from topology */
 	if (header.length > be->max) {
 		dev_err_ratelimited(scomp->dev, "error: Bytes data size %d exceeds max %d.\n",
-- 
2.25.1




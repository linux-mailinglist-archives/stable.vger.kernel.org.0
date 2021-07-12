Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491C13C5562
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355637AbhGLIKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353582AbhGLICg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE1561CD1;
        Mon, 12 Jul 2021 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076545;
        bh=41AxLvkOm9TRN3+yhjI16yCYcoCNm0OkB6tVeG+rG18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1zi6c3aihDLaCsS0ysa49Y7K5qhkUmC8b6tBD+4ACqAzvP38awpmBfLwhCBcx8u5
         uY2o+eYuuw+Tlyw+EA7z2OS7qzDslOx1XYz8sQ7VxFivPJlVxUF5w4JpNIS4zBhYie
         OhMnEDmKDT+IXk0TnSSvwYJxfRPolVhQHsoLkNBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 688/800] ASoC: rt700-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:51 +0200
Message-Id: <20210712061040.020454955@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a9e54e5fbe396b546771cf77b43ce7c75e212278 ]

The intent of the status check on resume was to verify if a SoundWire
peripheral reported ATTACHED before waiting for the initialization to
complete. This is required to avoid timeouts that will happen with
'ghost' devices that are exposed in the platform firmware but are not
populated in hardware.

Unfortunately we used 'hw_init' instead of 'first_hw_init'. Due to
another error, the resume operation never timed out, but the volume
settings were not properly restored.

BugLink: https://github.com/thesofproject/linux/issues/2908
BugLink: https://github.com/thesofproject/linux/issues/2637
Fixes: 7d2a5f9ae41e3 ('ASoC: rt700: add rt700 codec driver')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt700-sdw.c b/sound/soc/codecs/rt700-sdw.c
index ff9c081fd52a..d1d9c0f455b4 100644
--- a/sound/soc/codecs/rt700-sdw.c
+++ b/sound/soc/codecs/rt700-sdw.c
@@ -498,7 +498,7 @@ static int __maybe_unused rt700_dev_resume(struct device *dev)
 	struct rt700_priv *rt700 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt700->hw_init)
+	if (!rt700->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
-- 
2.30.2




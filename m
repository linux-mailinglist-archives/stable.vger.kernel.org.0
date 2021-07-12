Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BA83C4A85
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhGLGwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239998AbhGLGub (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE8961008;
        Mon, 12 Jul 2021 06:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072453;
        bh=HSZTzq3dV3bOqItXQlTIA3So6cBuND1xxjyZMqB3z7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riCwUe+KDfUoNt7W7UlWOO+aWR2YjbH2mSramXM5roXKvStgfUVPudLQjo2tS2r8X
         5GiLaW1S2lIDNqEHpHSvmeU7Xs3NnkQrJQWTuRBwJORWrFuL8CIRNJONCu6i1DCme0
         5+RyBIhlDlrRAjeGXEjO1+W2bqfES/8+I/BKQsyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 502/593] ASoC: rt1308-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:02 +0200
Message-Id: <20210712060946.848183464@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 30e102dab5fad1db71684f8ac5e1ac74e49da06d ]

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
Fixes: a87a6653a28c0 ('ASoC: rt1308-sdw: add rt1308 SdW amplifier driver')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1308-sdw.c b/sound/soc/codecs/rt1308-sdw.c
index c2621b0afe6c..31daa749c3db 100644
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -709,7 +709,7 @@ static int __maybe_unused rt1308_dev_resume(struct device *dev)
 	struct rt1308_sdw_priv *rt1308 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt1308->hw_init)
+	if (!rt1308->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
-- 
2.30.2




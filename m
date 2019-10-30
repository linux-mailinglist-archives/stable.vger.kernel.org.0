Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC9E9FB4
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfJ3PvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbfJ3PvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:16 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2629320856;
        Wed, 30 Oct 2019 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450675;
        bh=LZ1uuoVZmGLcMHbaav7oEKhJaVPSZG6TswowuEgtj50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YM41UZEVSdpYlS0TKL9viXac3PrQMfp9f1yFI3ASKW81vTAGx97kE4VNV7JFdb9uL
         SirEs1rDotCj4Bt+UebXYgcdMbbFcEZpxdLLyfkUlFMyFyFzS9RYL7WEGkjn8MlhuP
         +EYFemcAWbti3aY3MNjutr6VgRbC5+A7CWmMNcyI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stuart Henderson <stuarth@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.3 21/81] ASoC: wm_adsp: Don't generate kcontrols without READ flags
Date:   Wed, 30 Oct 2019 11:48:27 -0400
Message-Id: <20191030154928.9432-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Henderson <stuarth@opensource.cirrus.com>

[ Upstream commit 3ae7359c0e39f42a96284d6798fc669acff38140 ]

User space always expects to be able to read ALSA controls, so ensure
no kcontrols are generated without an appropriate READ flag. In the case
of a read of such a control zeros will be returned.

Signed-off-by: Stuart Henderson <stuarth@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20191002084240.21589-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index f5fbadc5e7e25..914fb3be5feae 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1259,8 +1259,7 @@ static unsigned int wmfw_convert_flags(unsigned int in, unsigned int len)
 	}
 
 	if (in) {
-		if (in & WMFW_CTL_FLAG_READABLE)
-			out |= rd;
+		out |= rd;
 		if (in & WMFW_CTL_FLAG_WRITEABLE)
 			out |= wr;
 		if (in & WMFW_CTL_FLAG_VOLATILE)
-- 
2.20.1


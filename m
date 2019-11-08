Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68057F5449
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbfKHSz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732087AbfKHSzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:55:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E472178F;
        Fri,  8 Nov 2019 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239354;
        bh=oqcikNQaIlCTx7/PpLSFwH3TmCmGrsgNZ2IoEF/qXOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9z9cvGl3klqm49tR3qmQFVyqeWQACUf+7ISfxw7xCaYXjBySYs7KHRuQ20Fbuu5S
         72qwHk0B/URpGG6vrNQa68ioABIy1XpqSh0Ex2CLXsSN9yFErbp37LImzR3WuVE4bn
         B2fnpH3A4ZUAzeZYOOcxhavBQllj+IBFL+noMS/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stuart Henderson <stuarth@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/34] ASoC: wm_adsp: Dont generate kcontrols without READ flags
Date:   Fri,  8 Nov 2019 19:50:10 +0100
Message-Id: <20191108174624.420932863@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c03c9da076c2d..28eb55bc46634 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -948,8 +948,7 @@ static unsigned int wmfw_convert_flags(unsigned int in, unsigned int len)
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9507A4D88C
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfFTS1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727350AbfFTSFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:05:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A426B21670;
        Thu, 20 Jun 2019 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053903;
        bh=5jrAkegvWKyZI+KhoA+/JKnMoJguzm564z0l+fgdMoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxRy2Q64A+Mwobr+62FLVk/TsswOvDLHsNdPQvxaC7uFMpRY+I1uHhPUsaGARCc90
         t4QCrb60j1w7mYp4z7uUrP4iZLjIClAE42ijFxtf6TGU/5esnsLZ5Kn6kFqdWuxIdf
         a+2Z7jF1ut3NHEEKex1OJmi5z98pu6h0fxmhkrFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 067/117] ASoC: cs42xx8: Add regcache mask dirty
Date:   Thu, 20 Jun 2019 19:56:41 +0200
Message-Id: <20190620174356.786080120@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: S.j. Wang <shengjiu.wang@nxp.com>

commit ad6eecbfc01c987e0253371f274c3872042e4350 upstream.

Add regcache_mark_dirty before regcache_sync for power
of codec may be lost at suspend, then all the register
need to be reconfigured.

Fixes: 0c516b4ff85c ("ASoC: cs42xx8: Add codec driver
support for CS42448/CS42888")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42xx8.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/cs42xx8.c
+++ b/sound/soc/codecs/cs42xx8.c
@@ -569,6 +569,7 @@ static int cs42xx8_runtime_resume(struct
 	msleep(5);
 
 	regcache_cache_only(cs42xx8->regmap, false);
+	regcache_mark_dirty(cs42xx8->regmap);
 
 	ret = regcache_sync(cs42xx8->regmap);
 	if (ret) {



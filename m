Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 079CB56049
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfFZDql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbfFZDqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:46:40 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-90.mobile.att.net [107.77.172.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D829E208CB;
        Wed, 26 Jun 2019 03:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520799;
        bh=pSs8O96Ibkt2hV6ubcEOT594/fFAqp7rvY7rMUtSgyQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bGTWY2qnKyrbL4u10iTsPvgrlN2Lyf3jz4L7lqUzEALKHSCye3Ify04p4hM9+hQkZ
         Swaq9h86gBjn8umjIG3h6v8Z/JG6UgvZZBc9pLQY3uUCPqJdjwUCJpibA/D+x5RYBT
         KbGEMeVb5RmjcpQTKMnbIiwXIt+XNYRFft+9bVV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Flax <flatmax@flatmax.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 1/6] ASoC : cs4265 : readable register too low
Date:   Tue, 25 Jun 2019 23:46:32 -0400
Message-Id: <20190626034637.24515-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Flax <flatmax@flatmax.org>

[ Upstream commit f3df05c805983427319eddc2411a2105ee1757cf ]

The cs4265_readable_register function stopped short of the maximum
register.

An example bug is taken from :
https://github.com/Audio-Injector/Ultra/issues/25

Where alsactl store fails with :
Cannot read control '2,0,0,C Data Buffer,0': Input/output error

This patch fixes the bug by setting the cs4265 to have readable
registers up to the maximum hardware register CS4265_MAX_REGISTER.

Signed-off-by: Matt Flax <flatmax@flatmax.org>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs4265.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs4265.c b/sound/soc/codecs/cs4265.c
index 93b02be3a90e..6edec2387861 100644
--- a/sound/soc/codecs/cs4265.c
+++ b/sound/soc/codecs/cs4265.c
@@ -60,7 +60,7 @@ static const struct reg_default cs4265_reg_defaults[] = {
 static bool cs4265_readable_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case CS4265_CHIP_ID ... CS4265_SPDIF_CTL2:
+	case CS4265_CHIP_ID ... CS4265_MAX_REGISTER:
 		return true;
 	default:
 		return false;
-- 
2.20.1


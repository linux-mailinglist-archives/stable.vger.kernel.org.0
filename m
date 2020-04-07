Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053431A0BA0
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgDGK0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgDGK0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9806C208FE;
        Tue,  7 Apr 2020 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255174;
        bh=YdFwDM3nizR9RoYSZ8xW4YWp22aAwQdmLS3glgLedTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfCf7rLEoNb787z/3XDkmXkJWNzBiZtq6Ml3DWfMnVluPvqavaUcEf2gdyJFgJ+AD
         eXM+Yt+qIaLtQNeb5djy3DixlV5lxJlXsMQ5MXZx0jhDYY5ws1bv26q0U/ihjdqEc6
         X5Je5uD21lXXpQ2zpintjDkxn8fVORsu4wBoxVQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Torsten Duwe <duwe@lst.de>,
        Mark Brown <broonie@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.6 13/29] drm/bridge: analogix-anx6345: Avoid duplicate -supply suffix
Date:   Tue,  7 Apr 2020 12:22:10 +0200
Message-Id: <20200407101453.592871368@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Torsten Duwe <duwe@lst.de>

commit 6726ca1a2d531f5a6efc1f785b15606ce837c4dc upstream.

of_get_regulator() will unconditionally add "-supply" to form the
property name. This is documented in commit 69511a452e6dc ("map consumer
regulator based on device tree"). Remove the suffix from the requests.

Signed-off-by: Torsten Duwe <duwe@lst.de>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200218155440.BEFB968C65@verein.lst.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/bridge/analogix/analogix-anx6345.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
@@ -711,14 +711,14 @@ static int anx6345_i2c_probe(struct i2c_
 		DRM_DEBUG("No panel found\n");
 
 	/* 1.2V digital core power regulator  */
-	anx6345->dvdd12 = devm_regulator_get(dev, "dvdd12-supply");
+	anx6345->dvdd12 = devm_regulator_get(dev, "dvdd12");
 	if (IS_ERR(anx6345->dvdd12)) {
 		DRM_ERROR("dvdd12-supply not found\n");
 		return PTR_ERR(anx6345->dvdd12);
 	}
 
 	/* 2.5V digital core power regulator  */
-	anx6345->dvdd25 = devm_regulator_get(dev, "dvdd25-supply");
+	anx6345->dvdd25 = devm_regulator_get(dev, "dvdd25");
 	if (IS_ERR(anx6345->dvdd25)) {
 		DRM_ERROR("dvdd25-supply not found\n");
 		return PTR_ERR(anx6345->dvdd25);



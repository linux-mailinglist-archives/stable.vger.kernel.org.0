Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68E4200CA6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389057AbgFSOsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389040AbgFSOsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:48:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9C2C2083B;
        Fri, 19 Jun 2020 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578083;
        bh=jB0JHajaiSD8nMrmh1e+MEqgjkNC208Fvh9HNwxgcUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbmrbKZy2kEEd8Mea6C1PRxgMkbCfVHgjc8ZtbE3GCNKUOqyQ51JWUS6WRRORlVvK
         PaX3vqUgFkmzxVc24fVX/fOYCYtxGZUNeQLpxJNdKHaaJ6IjFck6XbaruCSWZeHJJ/
         j7T1KZ+VWZBlr5OF7OI5AfQ3bktqnvuwPB3yE8MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/190] drm: bridge: adv7511: Extend list of audio sample rates
Date:   Fri, 19 Jun 2020 16:32:01 +0200
Message-Id: <20200619141637.375833152@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bogdan Togorean <bogdan.togorean@analog.com>

[ Upstream commit b97b6a1f6e14a25d1e1ca2a46c5fa3e2ca374e22 ]

ADV7511 support sample rates up to 192kHz. CTS and N parameters should
be computed accordingly so this commit extend the list up to maximum
supported sample rate.

Signed-off-by: Bogdan Togorean <bogdan.togorean@analog.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200413113513.86091-2-bogdan.togorean@analog.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index 67469c26bae8..45a027d7a1e4 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -20,13 +20,15 @@ static void adv7511_calc_cts_n(unsigned int f_tmds, unsigned int fs,
 {
 	switch (fs) {
 	case 32000:
-		*n = 4096;
+	case 48000:
+	case 96000:
+	case 192000:
+		*n = fs * 128 / 1000;
 		break;
 	case 44100:
-		*n = 6272;
-		break;
-	case 48000:
-		*n = 6144;
+	case 88200:
+	case 176400:
+		*n = fs * 128 / 900;
 		break;
 	}
 
-- 
2.25.1




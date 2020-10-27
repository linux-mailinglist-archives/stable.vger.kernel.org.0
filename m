Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFAD29B087
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509560AbgJ0OUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758591AbgJ0OUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49AA0206D4;
        Tue, 27 Oct 2020 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808416;
        bh=qhuFVCXUuA5sMPw82Q2wnhqM6uP/R32IpzRSUB0qV3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqO2EtofevA3oeBhwtwrKD9kvQ9ag3nmZHKM/Jzlg1H033hJGkZ70wGdB7rgdyO/g
         flUrio2gHHutrU4udn+DGPF83Y9Jkux/oAm9lxAhs6/abKJ1PBy1udG+NASGVgt10B
         /9ObXPQNNJQRKG1bma4brjg51LKo+asTskplc5Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/264] media: tuner-simple: fix regression in simple_set_radio_freq
Date:   Tue, 27 Oct 2020 14:51:41 +0100
Message-Id: <20201027135432.695758641@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 505bfc2a142f12ce7bc7a878b44abc3496f2e747 ]

clang static analysis reports this problem

tuner-simple.c:714:13: warning: Assigned value is
  garbage or undefined
        buffer[1] = buffer[3];
                  ^ ~~~~~~~~~
In simple_set_radio_freq buffer[3] used to be done
in-function with a switch of tuner type, now done
by a call to simple_radio_bandswitch which has this case

	case TUNER_TENA_9533_DI:
	case TUNER_YMEC_TVF_5533MF:
		tuner_dbg("This tuner doesn't ...
		return 0;

which does not set buffer[3].  In the old logic, this case
would have returned 0 from simple_set_radio_freq.

Recover this old behavior by returning an error for this
codition. Since the old simple_set_radio_freq behavior
returned a 0, do the same.

Fixes: c7a9f3aa1e1b ("V4L/DVB (7129): tuner-simple: move device-specific code into three separate functions")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/tuner-simple.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 29c1473f2e9f6..81e24cf0c8b80 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -499,7 +499,7 @@ static int simple_radio_bandswitch(struct dvb_frontend *fe, u8 *buffer)
 	case TUNER_TENA_9533_DI:
 	case TUNER_YMEC_TVF_5533MF:
 		tuner_dbg("This tuner doesn't have FM. Most cards have a TEA5767 for FM\n");
-		return 0;
+		return -EINVAL;
 	case TUNER_PHILIPS_FM1216ME_MK3:
 	case TUNER_PHILIPS_FM1236_MK3:
 	case TUNER_PHILIPS_FMD1216ME_MK3:
@@ -701,7 +701,8 @@ static int simple_set_radio_freq(struct dvb_frontend *fe,
 		    TUNER_RATIO_SELECT_50; /* 50 kHz step */
 
 	/* Bandswitch byte */
-	simple_radio_bandswitch(fe, &buffer[0]);
+	if (simple_radio_bandswitch(fe, &buffer[0]))
+		return 0;
 
 	/* Convert from 1/16 kHz V4L steps to 1/20 MHz (=50 kHz) PLL steps
 	   freq * (1 Mhz / 16000 V4L steps) * (20 PLL steps / 1 MHz) =
-- 
2.25.1




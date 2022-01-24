Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8926149A97A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322610AbiAYDWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34664 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385267AbiAXUb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06AABB8123D;
        Mon, 24 Jan 2022 20:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2558FC340E5;
        Mon, 24 Jan 2022 20:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056312;
        bh=wxcf2td4nock/WupOP7KOGXdCb7aoLTxQcRZqO5Uhzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moM19WuAU3dIJcASYrz+Hb6m+zpibfp2HJp/Jso0I5266/eeIg7SuoUaOdH9XhQ8H
         UHjNdjEsZxEqDtSHHdt9sLbPW0JogdFVWehBo1U9vjqL0JHFT8qtz+X+wZ890WapPD
         38CIhMV8BYSKSJTu2N7DjGY8Zd1D/a0OiaFP5xM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Christian A. Ehrhardt" <lk@c--e.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/846] ALSA: hda/cs8409: Increase delay during jack detection
Date:   Mon, 24 Jan 2022 19:39:20 +0100
Message-Id: <20220124184116.263137916@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit 8cd07657177006b67cc1610e4466cc75ad781c05 ]

Commit c8b4f0865e82 reduced delays related to cs42l42 jack
detection. However, the change was too aggressive. As a result
internal speakers on DELL Inspirion 3501 are not detected.

Increase the delay in cs42l42_run_jack_detect() a bit.

Fixes: c8b4f0865e82 ("ALSA: hda/cs8409: Remove unnecessary delays")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://lore.kernel.org/r/20211231131221.itwotyfk5qomn7n6@cae.in-ulm.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_cs8409.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_cs8409.c b/sound/pci/hda/patch_cs8409.c
index 039b9f2f8e947..bf5d7f0c6ba55 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -628,8 +628,8 @@ static void cs42l42_run_jack_detect(struct sub_codec *cs42l42)
 	cs8409_i2c_write(cs42l42, 0x1b74, 0x07);
 	cs8409_i2c_write(cs42l42, 0x131b, 0xFD);
 	cs8409_i2c_write(cs42l42, 0x1120, 0x80);
-	/* Wait ~100us*/
-	usleep_range(100, 200);
+	/* Wait ~20ms*/
+	usleep_range(20000, 25000);
 	cs8409_i2c_write(cs42l42, 0x111f, 0x77);
 	cs8409_i2c_write(cs42l42, 0x1120, 0xc0);
 }
-- 
2.34.1




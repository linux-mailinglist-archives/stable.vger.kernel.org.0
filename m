Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD57C1E2DC8
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391328AbgEZTH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403778AbgEZTH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:07:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1485320776;
        Tue, 26 May 2020 19:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520076;
        bh=u2VeJ6WneGtXK1DRpVLdh0k3NgnIp1z1pi15bDGTiIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3k3A03aXKFo7/meVY8rJh3CXPh2WriqXSiW+cMvDRguCDl0c7lDuYL8zt/YaubMc
         xgfpDRmvu87mIJk4gxYqdJLVbjmWIzUbcsznGc3sQYyTiYE0s5QsiezHUlKAynuazI
         0fxruFgd2teIMfEZ9UY6a0MSHTB3UGt5wKS33A4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/111] ALSA: hda: patch_realtek: fix empty macro usage in if block
Date:   Tue, 26 May 2020 20:53:07 +0200
Message-Id: <20200526183937.524385358@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 8a71821f12a010d7100f9cc1f7b218aff0313c4a ]

GCC reports the following warning with W=1

sound/pci/hda/patch_realtek.c: In function ‘alc269_suspend’:
sound/pci/hda/patch_realtek.c:3616:29: warning: suggest braces around
empty body in an ‘if’ statement [-Wempty-body]
 3616 |   alc5505_dsp_suspend(codec);
      |                             ^

sound/pci/hda/patch_realtek.c: In function ‘alc269_resume’:
sound/pci/hda/patch_realtek.c:3651:28: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
 3651 |   alc5505_dsp_resume(codec);
      |                            ^

This is a classic macro problem and can indeed lead to bad program
flows.

Fix by using the usual "do { } while (0)" pattern

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200111214736.3002-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 151099b8c394..a0e7d711cbb5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3719,8 +3719,8 @@ static void alc5505_dsp_init(struct hda_codec *codec)
 }
 
 #ifdef HALT_REALTEK_ALC5505
-#define alc5505_dsp_suspend(codec)	/* NOP */
-#define alc5505_dsp_resume(codec)	/* NOP */
+#define alc5505_dsp_suspend(codec)	do { } while (0) /* NOP */
+#define alc5505_dsp_resume(codec)	do { } while (0) /* NOP */
 #else
 #define alc5505_dsp_suspend(codec)	alc5505_dsp_halt(codec)
 #define alc5505_dsp_resume(codec)	alc5505_dsp_back_from_halt(codec)
-- 
2.25.1




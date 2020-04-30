Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4951BFBF0
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgD3OCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbgD3Nxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 117E520870;
        Thu, 30 Apr 2020 13:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254818;
        bh=jLd/m6vXXjMduVePN9+R0gj6Wj03nfzM/HiOjiE5sA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiW3dpIUSAlsiKw+yKeCFCwWTkGdKsmzPMcFuKBgYyOEKaVskqxqFXorj17hBLtoa
         KF6dHKjgAD+QltwJUMSshBbdJPE/khwFaLUn2gIjG2WOdhDoF7TnEL9HL0IfzG06yl
         UbOTDW0XkgCbQtWsdTtibzV5q/1sZQMItnT68blc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 11/30] ASoC: codecs: hdac_hdmi: Fix incorrect use of list_for_each_entry
Date:   Thu, 30 Apr 2020 09:53:06 -0400
Message-Id: <20200430135325.20762-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135325.20762-1-sashal@kernel.org>
References: <20200430135325.20762-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 326b509238171d37402dbe308e154cc234ed1960 ]

If we don't find any pcm, pcm will point at address at an offset from
the the list head and not a meaningful structure. Fix this by returning
correct pcm if found and NULL if not. Found with coccinelle.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20200415162849.308-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index be2473166bfaf..4594b1447900a 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -148,14 +148,14 @@ static struct hdac_hdmi_pcm *
 hdac_hdmi_get_pcm_from_cvt(struct hdac_hdmi_priv *hdmi,
 			   struct hdac_hdmi_cvt *cvt)
 {
-	struct hdac_hdmi_pcm *pcm = NULL;
+	struct hdac_hdmi_pcm *pcm;
 
 	list_for_each_entry(pcm, &hdmi->pcm_list, head) {
 		if (pcm->cvt == cvt)
-			break;
+			return pcm;
 	}
 
-	return pcm;
+	return NULL;
 }
 
 static void hdac_hdmi_jack_report(struct hdac_hdmi_pcm *pcm,
-- 
2.20.1


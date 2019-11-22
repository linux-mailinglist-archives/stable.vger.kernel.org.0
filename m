Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA03106D38
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfKVK6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730781AbfKVK6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C63320706;
        Fri, 22 Nov 2019 10:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420300;
        bh=5JyN2FgPWBh3qL6a7cuhWgCk96f+uI8zA/DJLjhhlq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f83Q4rgKtiXeQey5atjg8QyLqEHZl4ZsQ175bAZE6g0A1QU6ZbxKQ4CumF4MLbm7l
         7TSnAxvhELoHytEeWW6H0nxk1mfF2NwBZB7TwjkXkhT597Zbrx50AUAn6L0uaAWegN
         WdSAoKm4QrGlN/27ttwxFw0eInT/pVMFLdyqUMSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keyon Jie <yang.jie@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/220] ALSA: hda: Fix mismatch for register mask and value in ext controller.
Date:   Fri, 22 Nov 2019 11:27:04 +0100
Message-Id: <20191122100916.348881819@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keyon Jie <yang.jie@linux.intel.com>

[ Upstream commit c32bf867cb6721d6ea04044d33f19c8bd81280c1 ]

E.g. for snd_hdac_ext_bus_link_power_up(), we should set mask to be
AZX_MLCTL_SPA(it was 0), and AZX_MLCTL_SPA as value to power up it,
here correct it and several similar mismatches.

Signed-off-by: Keyon Jie <yang.jie@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_controller.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/sound/hda/ext/hdac_ext_controller.c b/sound/hda/ext/hdac_ext_controller.c
index 5bc4a1d587d4f..60cb00fd0c693 100644
--- a/sound/hda/ext/hdac_ext_controller.c
+++ b/sound/hda/ext/hdac_ext_controller.c
@@ -48,9 +48,11 @@ void snd_hdac_ext_bus_ppcap_enable(struct hdac_bus *bus, bool enable)
 	}
 
 	if (enable)
-		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL, 0, AZX_PPCTL_GPROCEN);
+		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL,
+				 AZX_PPCTL_GPROCEN, AZX_PPCTL_GPROCEN);
 	else
-		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL, AZX_PPCTL_GPROCEN, 0);
+		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL,
+				 AZX_PPCTL_GPROCEN, 0);
 }
 EXPORT_SYMBOL_GPL(snd_hdac_ext_bus_ppcap_enable);
 
@@ -68,9 +70,11 @@ void snd_hdac_ext_bus_ppcap_int_enable(struct hdac_bus *bus, bool enable)
 	}
 
 	if (enable)
-		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL, 0, AZX_PPCTL_PIE);
+		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL,
+				 AZX_PPCTL_PIE, AZX_PPCTL_PIE);
 	else
-		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL, AZX_PPCTL_PIE, 0);
+		snd_hdac_updatel(bus->ppcap, AZX_REG_PP_PPCTL,
+				 AZX_PPCTL_PIE, 0);
 }
 EXPORT_SYMBOL_GPL(snd_hdac_ext_bus_ppcap_int_enable);
 
@@ -194,7 +198,8 @@ static int check_hdac_link_power_active(struct hdac_ext_link *link, bool enable)
  */
 int snd_hdac_ext_bus_link_power_up(struct hdac_ext_link *link)
 {
-	snd_hdac_updatel(link->ml_addr, AZX_REG_ML_LCTL, 0, AZX_MLCTL_SPA);
+	snd_hdac_updatel(link->ml_addr, AZX_REG_ML_LCTL,
+			 AZX_MLCTL_SPA, AZX_MLCTL_SPA);
 
 	return check_hdac_link_power_active(link, true);
 }
@@ -222,8 +227,8 @@ int snd_hdac_ext_bus_link_power_up_all(struct hdac_bus *bus)
 	int ret;
 
 	list_for_each_entry(hlink, &bus->hlink_list, list) {
-		snd_hdac_updatel(hlink->ml_addr,
-				AZX_REG_ML_LCTL, 0, AZX_MLCTL_SPA);
+		snd_hdac_updatel(hlink->ml_addr, AZX_REG_ML_LCTL,
+				 AZX_MLCTL_SPA, AZX_MLCTL_SPA);
 		ret = check_hdac_link_power_active(hlink, true);
 		if (ret < 0)
 			return ret;
@@ -243,7 +248,8 @@ int snd_hdac_ext_bus_link_power_down_all(struct hdac_bus *bus)
 	int ret;
 
 	list_for_each_entry(hlink, &bus->hlink_list, list) {
-		snd_hdac_updatel(hlink->ml_addr, AZX_REG_ML_LCTL, AZX_MLCTL_SPA, 0);
+		snd_hdac_updatel(hlink->ml_addr, AZX_REG_ML_LCTL,
+				 AZX_MLCTL_SPA, 0);
 		ret = check_hdac_link_power_active(hlink, false);
 		if (ret < 0)
 			return ret;
-- 
2.20.1




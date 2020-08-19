Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5077C24A1F5
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 16:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHSOo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 10:44:58 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4386 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHSOo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 10:44:58 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3d3a780001>; Wed, 19 Aug 2020 07:43:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 19 Aug 2020 07:44:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 19 Aug 2020 07:44:58 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Aug
 2020 14:44:54 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 19 Aug 2020 14:44:53 +0000
Received: from audio.nvidia.com (Not Verified[10.24.34.185]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f3d3ae20000>; Wed, 19 Aug 2020 07:44:52 -0700
From:   Sameer Pujar <spujar@nvidia.com>
To:     <tiwai@suse.com>, <perex@perex.cz>
CC:     <kai.vehmanen@linux.intel.com>, <yang.jie@linux.intel.com>,
        <pierre-louis.bossart@linux.intel.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] ALSA: hda: avoid reset of sdo_limit
Date:   Wed, 19 Aug 2020 20:14:33 +0530
Message-ID: <1597848273-25813-1-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597848184; bh=r259BE/Wv/192bTP/TCyvzCie6DbWCgPuvthR/nJltQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=Ecu/ODBICncWcP0dg0JsCV7FRbRSnUqbk/Ft+GUPzyLqLLVoquI+v0jkGHvV/pJXk
         CBYqHC4HjwVrM1m9RYJi785xNN0M7UZS1A2gpYlMiF7TGlwd2NJzGeo71R8aDAGD2i
         wlH23T6yNpM4V/wmoCxc+J1s5KRTDVinuw6jcrLp42113HHq9f03zBlTkbkPXk5OKm
         xNrvv2oGHIq5qRgiWizdodtisOT9F8YpP8cEGnpaUqbszfT9NosHWoXXdy0kHPHE7+
         BpunBnyMDEjqos0NvUnRwoWzuozHoYw8P+mozSJq1jliIK0m4t/8j/+aUsz6tPOlXq
         D1SVhSTbwzA0g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By default 'sdo_limit' is initialized with a default value of '8'
as per spec. This is overridden in cases where a different value is
required. However this is getting reset when snd_hdac_bus_init_chip()
is called again, which happens during runtime PM cycle. Avoid reset
by not initializing to default value everytime.

Fixes: 67ae482a59e9 ("ALSA: hda: add member to store ratio for stripe control")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 sound/hda/hdac_controller.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/hda/hdac_controller.c b/sound/hda/hdac_controller.c
index 011b17c..0e26e96 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -538,7 +538,8 @@ bool snd_hdac_bus_init_chip(struct hdac_bus *bus, bool full_reset)
 	 *   { ((num_channels * bits_per_sample * rate/48000) /
 	 *	number of SDOs) >= 8 }
 	 */
-	bus->sdo_limit = 8;
+	if (!bus->sdo_limit)
+		bus->sdo_limit = 8;
 
 	return true;
 }
-- 
2.7.4


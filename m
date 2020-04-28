Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135F91BCA8A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgD1SuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729425AbgD1Sj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:39:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B57220730;
        Tue, 28 Apr 2020 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099167;
        bh=//zB9eqmKRDD9KoFjetW5pHJ9mI7Z88mNkGSqKAfTK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeaBgQ5BMHsT0j0dIG112Pk5wmU+ZhY0uDcmLwDYQPS3gH82HBGYow5jr1qR4AGHm
         PTZx9Q56zxTQKpwe39ViI5c+02eYTCUSOMHbW8n0RG9Mzlef1SC+uFvBFLxxV6wXKK
         IGNhVRmNZ8A0vAelzLn5Zb20AH54dRPgi5GhqVH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gyeongtaek Lee <gt82.lee@samsung.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 108/131] ASoC: dapm: fixup dapm kcontrol widget
Date:   Tue, 28 Apr 2020 20:25:20 +0200
Message-Id: <20200428182238.752484549@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gyeongtaek Lee <gt82.lee@samsung.com>

commit ebf1474745b4373fdde0fcf32d9d1f369b50b212 upstream.

snd_soc_dapm_kcontrol widget which is created by autodisable control
should contain correct on_val, mask and shift because it is set when the
widget is powered and changed value is applied on registers by following
code in dapm_seq_run_coalesced().

		mask |= w->mask << w->shift;
		if (w->power)
			value |= w->on_val << w->shift;
		else
			value |= w->off_val << w->shift;

Shift on the mask in dapm_kcontrol_data_alloc() is removed to prevent
double shift.
And, on_val in dapm_kcontrol_set_value() is modified to get correct
value in the dapm_seq_run_coalesced().

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/000001d61537$b212f620$1638e260$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -410,7 +410,7 @@ static int dapm_kcontrol_data_alloc(stru
 
 			memset(&template, 0, sizeof(template));
 			template.reg = e->reg;
-			template.mask = e->mask << e->shift_l;
+			template.mask = e->mask;
 			template.shift = e->shift_l;
 			template.off_val = snd_soc_enum_item_to_val(e, 0);
 			template.on_val = template.off_val;
@@ -536,8 +536,22 @@ static bool dapm_kcontrol_set_value(cons
 	if (data->value == value)
 		return false;
 
-	if (data->widget)
-		data->widget->on_val = value;
+	if (data->widget) {
+		switch (dapm_kcontrol_get_wlist(kcontrol)->widgets[0]->id) {
+		case snd_soc_dapm_switch:
+		case snd_soc_dapm_mixer:
+		case snd_soc_dapm_mixer_named_ctl:
+			data->widget->on_val = value & data->widget->mask;
+			break;
+		case snd_soc_dapm_demux:
+		case snd_soc_dapm_mux:
+			data->widget->on_val = value >> data->widget->shift;
+			break;
+		default:
+			data->widget->on_val = value;
+			break;
+		}
+	}
 
 	data->value = value;
 



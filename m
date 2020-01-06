Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1C313117A
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 12:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgAFLjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 06:39:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48126 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725787AbgAFLjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 06:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578310750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7QnDS0wMpWsHdmbYrxKZ8IKh1lRAwVHzJpC+uPoDwz8=;
        b=bc1KlNxwgH/Shjx6yuTcI++NAnmbkvrJHGyyPzpD2T+s8FY5diupzmMGNHBXRcyESfa9Ej
        OlfmDVPlXIZNGBfnLjVwYRXuQV7RUJRIK3Qn8lmxQuRm16kV3y2ex+kShgQPTNxzh2VtKv
        2MtNn4ZJcffdtcLtN2odno6I4VdMoGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-Z24N8wNUPDiyB4Y_xwyr8w-1; Mon, 06 Jan 2020 06:39:09 -0500
X-MC-Unique: Z24N8wNUPDiyB4Y_xwyr8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35429DB65;
        Mon,  6 Jan 2020 11:39:07 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-130.ams2.redhat.com [10.36.116.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C463F271BA;
        Mon,  6 Jan 2020 11:39:04 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org, russianneuromancer@ya.ru
Subject: [PATCH] ASoC: Intel: bytcht_es8316: Fix Irbis NB41 netbook quirk
Date:   Mon,  6 Jan 2020 12:39:03 +0100
Message-Id: <20200106113903.279394-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a quirk for the Irbis NB41 netbook was added, to override the defaul=
ts
for this device, I forgot to add/keep the BYT_CHT_ES8316_SSP0 part of the
defaults, completely breaking audio on this netbook.

This commit adds the BYT_CHT_ES8316_SSP0 flag to the Irbis NB41 netbook
quirk, making audio work again.

Cc: stable@vger.kernel.org
Cc: russianneuromancer@ya.ru
Fixes: aa2ba991c420 ("ASoC: Intel: bytcht_es8316: Add quirk for Irbis NB4=
1 netbook")
Reported-and-tested-by: russianneuromancer@ya.ru
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 sound/soc/intel/boards/bytcht_es8316.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boa=
rds/bytcht_es8316.c
index 46612331f5ea..54e97455d7f6 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -442,7 +442,8 @@ static const struct dmi_system_id byt_cht_es8316_quir=
k_table[] =3D {
 			DMI_MATCH(DMI_SYS_VENDOR, "IRBIS"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "NB41"),
 		},
-		.driver_data =3D (void *)(BYT_CHT_ES8316_INTMIC_IN2_MAP
+		.driver_data =3D (void *)(BYT_CHT_ES8316_SSP0
+					| BYT_CHT_ES8316_INTMIC_IN2_MAP
 					| BYT_CHT_ES8316_JD_INVERTED),
 	},
 	{	/* Teclast X98 Plus II */
--=20
2.24.1


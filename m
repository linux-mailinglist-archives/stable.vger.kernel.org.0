Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D83213FD0F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390810AbgAPXV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390824AbgAPXV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ADB920684;
        Thu, 16 Jan 2020 23:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216886;
        bh=e7f1OtDSuCXOA9woZZNqytKyrZXUnNRWbVnq/VpohTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoQCnxICGMeETjWpK/SBxSem31CYkrLDcQRWw5CoTHV+QThYFJAIeQoXaUBmEFeKf
         3g+1l8tZhMPnNywzoqBSoFzM0u86BQvpLa03iTcWVCVfo93Od/o6aZ6rosVYXkRWET
         booV7ES2ClK7Sd57lC8PY/02W9FPXWMOplvMJmMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 060/203] ASoC: rsnd: fix DALIGN register for SSIU
Date:   Fri, 17 Jan 2020 00:16:17 +0100
Message-Id: <20200116231749.275523426@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>

commit ef8e14794308a428b194f8b06ad9ae06b43466e4 upstream.

The current driver only sets 0x76543210 and 0x67452301 for DALIGN.
This doesn’t work well for TDM split and ex-split mode for all SSIU.
This patch programs the DALIGN registers based on the SSIU number.

Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Jiada Wang <jiada_wang@mentor.com>
Cc: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Fixes: a914e44693d41b ("ASoC: rsnd: more clear rsnd_get_dalign() for DALIGN")
Signed-off-by: Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20191121111023.10976-1-erosca@de.adit-jv.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sh/rcar/core.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -376,6 +376,17 @@ u32 rsnd_get_adinr_bit(struct rsnd_mod *
  */
 u32 rsnd_get_dalign(struct rsnd_mod *mod, struct rsnd_dai_stream *io)
 {
+	static const u32 dalign_values[8][2] = {
+		{0x76543210, 0x67452301},
+		{0x00000032, 0x00000023},
+		{0x00007654, 0x00006745},
+		{0x00000076, 0x00000067},
+		{0xfedcba98, 0xefcdab89},
+		{0x000000ba, 0x000000ab},
+		{0x0000fedc, 0x0000efcd},
+		{0x000000fe, 0x000000ef},
+	};
+	int id = 0, inv;
 	struct rsnd_mod *ssiu = rsnd_io_to_mod_ssiu(io);
 	struct rsnd_mod *target;
 	struct snd_pcm_runtime *runtime = rsnd_io_to_runtime(io);
@@ -411,13 +422,18 @@ u32 rsnd_get_dalign(struct rsnd_mod *mod
 		target = cmd ? cmd : ssiu;
 	}
 
+	if (mod == ssiu)
+		id = rsnd_mod_id_sub(mod);
+
 	/* Non target mod or non 16bit needs normal DALIGN */
 	if ((snd_pcm_format_width(runtime->format) != 16) ||
 	    (mod != target))
-		return 0x76543210;
+		inv = 0;
 	/* Target mod needs inverted DALIGN when 16bit */
 	else
-		return 0x67452301;
+		inv = 1;
+
+	return dalign_values[id][inv];
 }
 
 u32 rsnd_get_busif_shift(struct rsnd_dai_stream *io, struct rsnd_mod *mod)



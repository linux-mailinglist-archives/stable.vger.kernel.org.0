Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F24662934
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjAIPCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjAIPB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:01:59 -0500
Received: from mail1.perex.cz (mail1.perex.cz [77.48.224.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C951C404
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 07:01:57 -0800 (PST)
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id 94B40A0058;
        Mon,  9 Jan 2023 16:01:54 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz 94B40A0058
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1673276514; bh=T3sdsyIaTFFXNPa/h3w8asbkqmac5HDKD0k0F0F8LIM=;
        h=From:To:Cc:Subject:Date:From;
        b=PT/wX+QHkZ/Dt/6pFZZDwGBAuvVPmr3wy26a3J6v29aKaOm8kKpSQvFdD6/ObUDbq
         AxE4gC6+48vgwcool/3zfma68KFgYyLposR5iSrY2bu/17Si2Z5lWANL+u3Q9qRrVP
         BCENQsm/sjxV1zVPIMIXN+9ZG0QbNe0D16Sp3rXw=
Received: from p1gen2.perex-int.cz (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Mon,  9 Jan 2023 16:01:49 +0100 (CET)
From:   Jaroslav Kysela <perex@perex.cz>
To:     ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        yang.yang29@zte.com.cn, stable@vger.kernel.org
Subject: [PATCH v2] ALSA: control-led: use strscpy in set_led_id()
Date:   Mon,  9 Jan 2023 16:01:18 +0100
Message-Id: <20230109150119.342771-1-perex@perex.cz>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The use of strncpy() in the set_led_id() was incorrect.
The len variable should use 'min(sizeof(buf2) - 1, count)'
expression.

Use strscpy() function to simplify things and handle the error gracefully.

Reported-by: yang.yang29@zte.com.cn
BugLink: https://lore.kernel.org/alsa-devel/202301091945513559977@zte.com.cn/
Cc: <stable@vger.kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>

v1..v2:
  - remove min() expression which strips the last char
---
 sound/core/control_led.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index f975cc85772b..3cadd40100f3 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -530,12 +530,11 @@ static ssize_t set_led_id(struct snd_ctl_led_card *led_card, const char *buf, si
 			  bool attach)
 {
 	char buf2[256], *s, *os;
-	size_t len = max(sizeof(s) - 1, count);
 	struct snd_ctl_elem_id id;
 	int err;
 
-	strncpy(buf2, buf, len);
-	buf2[len] = '\0';
+	if (strscpy(buf2, buf, sizeof(buf2)) < 0)
+		return -E2BIG;
 	memset(&id, 0, sizeof(id));
 	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	s = buf2;
-- 
2.39.0

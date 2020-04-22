Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873831B396F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 09:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgDVHwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 03:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726154AbgDVHwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 03:52:11 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE76DC03C1A6;
        Wed, 22 Apr 2020 00:52:10 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x23so857883lfq.1;
        Wed, 22 Apr 2020 00:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zWLG9WLDxjvVAUx23VHGxafd8rdyiPnw+mQBD7zdx4U=;
        b=LJ4WHgMeDvdr75XITNJboz1evInfdechCbg7zuDiEkJlbZwCAtI4f+i5gfkxiV4lZQ
         nGu5z/2oKi+KeNe4C5zOD/W5gWLU5XkFrXGB6aDUyr0UJci1Oenn67TSa4/csTfaSKCP
         L8QICOrO8ppl4wZMf6wQOBzGH+T15bZs7TW15B3ak10gMLAiq5mtt/P8K0MNADZNCi7x
         FcrIU4uuxfkFIjmD8KFOGU6TcBo70Y78EC4dM15uazn+/N8/rcfdH7xVUVLTtEtPPSNr
         hIMSAwHSBYAMU20dllQy1vgbDXpvR5xC3n43cCEdicK06gadabBDdQvRqmA8OEdzVQnY
         vhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zWLG9WLDxjvVAUx23VHGxafd8rdyiPnw+mQBD7zdx4U=;
        b=Knou/ytVsAek1kYqF0+NkPk6MUKwrVJAdtCQ4LONhFvVXNZfUGEgS4jDtzDW3OtgfT
         IqsBSi8IgHviG48TCQEJ5+6Vi81ipu2FmkpS+jEn5uFWuZus+4Z2SF/ExHrk2BZbqmd1
         ylmn6tEUfBPiZ16FDdI0Sy+PyawTYEKS66kutE75EWaizrHzm9vHX4OcaUVwS6GrCF6s
         pgRiGJ5ecbHLtTJSAirXZVU4a0Ai4pgJvm/wKvAYQxS+1tUWeVCHlin6Lm+UAsn//p9S
         fAdxZTvZdMWmCd1Ty4KjSvnlu9S2ldaio1K9X6u3UMV1jNUsj3sWp+RU5KjeNPVlSlz6
         Mauw==
X-Gm-Message-State: AGi0PuZB1aBSoh3gkyGg8zYIQLKObGSqBmasiDyabuEMd1t7YolGUpK7
        tUmURFUTs4baAbBxTiTUFx8=
X-Google-Smtp-Source: APiQypI7jz/Z2LEcWCbAcGd5SWzfHveB1CjNdzdINAg7okl6sXQdQVEUcEX/zzSsU9pTB+lzqNwS0w==
X-Received: by 2002:ac2:4426:: with SMTP id w6mr16203406lfl.8.1587541929396;
        Wed, 22 Apr 2020 00:52:09 -0700 (PDT)
Received: from luk-pc.lan (host-46-186-7-151.dynamic.mm.pl. [46.186.7.151])
        by smtp.googlemail.com with ESMTPSA id i20sm4250655lfe.15.2020.04.22.00.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 00:52:08 -0700 (PDT)
From:   LuK1337 <priv.luk@gmail.com>
Cc:     Cameron Gutman <aicommander@gmail.com>,
        =?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Fontana <rfontana@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: xpad - Add custom init packet for Xbox One S controllers
Date:   Wed, 22 Apr 2020 09:52:05 +0200
Message-Id: <20200422075206.18229-1-priv.luk@gmail.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <92b71dc5-ddd5-7ffd-65f8-65a6610dfe43@gmail.com>
References: <92b71dc5-ddd5-7ffd-65f8-65a6610dfe43@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Patron <priv.luk@gmail.com>

Sending [ 0x05, 0x20, 0x00, 0x0f, 0x06 ] packet for
Xbox One S controllers fixes an issue where controller
is stuck in Bluetooth mode and not sending any inputs.

Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/input/joystick/xpad.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 6b40a1c68f9f..c77cdb3b62b5 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -458,6 +458,16 @@ static const u8 xboxone_fw2015_init[] = {
 	0x05, 0x20, 0x00, 0x01, 0x00
 };
 
+/*
+ * This packet is required for Xbox One S (0x045e:0x02ea)
+ * and Xbox One Elite Series 2 (0x045e:0x0b00) pads to
+ * initialize the controller that was previously used in
+ * Bluetooth mode.
+ */
+static const u8 xboxone_s_init[] = {
+	0x05, 0x20, 0x00, 0x0f, 0x06
+};
+
 /*
  * This packet is required for the Titanfall 2 Xbox One pads
  * (0x0e6f:0x0165) to finish initialization and for Hori pads
@@ -516,6 +526,8 @@ static const struct xboxone_init_packet xboxone_init_packets[] = {
 	XBOXONE_INIT_PKT(0x0e6f, 0x0165, xboxone_hori_init),
 	XBOXONE_INIT_PKT(0x0f0d, 0x0067, xboxone_hori_init),
 	XBOXONE_INIT_PKT(0x0000, 0x0000, xboxone_fw2015_init),
+	XBOXONE_INIT_PKT(0x045e, 0x02ea, xboxone_s_init),
+	XBOXONE_INIT_PKT(0x045e, 0x0b00, xboxone_s_init),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init1),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init2),
 	XBOXONE_INIT_PKT(0x24c6, 0x541a, xboxone_rumblebegin_init),
-- 
2.26.0


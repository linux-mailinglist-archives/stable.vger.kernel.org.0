Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AA942DA98
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 15:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhJNNi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 09:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhJNNi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 09:38:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740A7C061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 06:36:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q12so2655115pgq.11
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 06:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lambdal-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHj+1t9MEwAxRx5qtotO1qSGm1kus+HGUYV6uTPSYfw=;
        b=KhpUxMk6X/7o7y5+Z6YSy2OWqZaFfDAtsjD1047NtD0En3WGnwt8mx9JBoxe5D+oNz
         sdDSVbPjTJgDTtuzKtZqM1fFfSR7NYP4RMw4ELlXj+YxI5177Y2NYsmRr+iWUqjqYUxn
         tVx6nq8DN1xnuBXA9VRgWE2En7CrZ3+qg+SHhphg+fvKaWDNIUdrn13hfk1eCB9WpNQR
         cHpZ3tzS9+PaQlhJTTgo2SXJjxvlQHHpeabT1wBHuprQO/kp62PY5/LdzAO1f9ytrSFI
         e3/KvOWtJpiuktPn/47oNB7iQDZBz6awJdFbBrL7NmHaWMsM4BhKqQNHiE1gE9pU+yAG
         y7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHj+1t9MEwAxRx5qtotO1qSGm1kus+HGUYV6uTPSYfw=;
        b=kOfxLpDmEENpsVf7w96cySdSHjqOhmBn821wFHVzH5dV7i3IU452MBV5o2IWMwD6jF
         HDJMF84UTmz7AJV8Xu5DbSEn/KRAfImgRBKHbWRh2wb/g7i2lnHt2NSTwPnic2xve5wp
         dHJaKb7QT0X2wgs5uZiGz9X2SJ6mihRN6CGlC4jAUx4oPb5s/iWb9XvQicD+v0QNKUq5
         fg2gZ8i/WwMwyYlxrTV9FJY9XSSQ8WEvQX/oOkaFdr9MNtByv9EPSK65JHTmuBO93Eqk
         D42DK/C5TIs5NI1r90gDWvyZE/NE0w80XyzuZWU/7tKhM0sFjemQJALLzJX7ihx44Vsu
         kadQ==
X-Gm-Message-State: AOAM530lohbAAB6Oz2dcYVf7OX+EtSIiw+PIPvweUiQvku5rU3zt55f2
        cS7yZH6zDltaEupE46x7024aeuCN+SgK/A==
X-Google-Smtp-Source: ABdhPJw6mYqfGIgLP/eM785vQF+DX4w2gJc5qcuydoXfDCHrgLzr8hAq9JCrn/Gjy54io6ldHLTtSQ==
X-Received: by 2002:a63:7404:: with SMTP id p4mr4200503pgc.222.1634218611977;
        Thu, 14 Oct 2021 06:36:51 -0700 (PDT)
Received: from mogadishu.hsd1.ca.comcast.net ([50.211.197.46])
        by smtp.gmail.com with ESMTPSA id w19sm9370153pjy.9.2021.10.14.06.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:36:51 -0700 (PDT)
From:   Steven Clarkson <sc@lambdal.com>
To:     alsa-devel@alsa-project.com
Cc:     tiwai@suse.de, Steven Clarkson <sc@lambdal.com>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: Add quirk for Clevo PC50HS
Date:   Thu, 14 Oct 2021 06:35:54 -0700
Message-Id: <20211014133554.1326741-1-sc@lambdal.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apply existing PCI quirk to the Clevo PC50HS and related models to fix
audio output on the built in speakers.

Signed-off-by: Steven Clarkson <sc@lambdal.com>
Cc: <stable@vger.kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4407f7da57c4..f44a3c7efbe6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2533,6 +2533,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e5, "Clevo PC50D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x65f1, "Clevo PC50HS", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
-- 
2.25.1


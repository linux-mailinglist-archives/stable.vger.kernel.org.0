Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7394A3C69
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 02:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357275AbiAaBGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 20:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiAaBGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 20:06:14 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACE1C061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 17:06:14 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id h7so37629003ejf.1
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 17:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vxCizGjPP8oXWBLfTZQwIA3YFQNWiqW6fSdu870FudY=;
        b=CSySMKgcNc2+T1xpCfJIPCDJ4KhpgmCZ1hWmTBHTQYhVvuJgw16Jat3Kf6dH3m/34w
         86H2+iryrZOB+GTP4XIfoS+145OL48L9egxcSRAyJwI+QNw5+iNvoYeBc4pkPNbOgPze
         i8u/kBM0wFKNmzjtgI9Hq3d1msjvzyenfU1utXXOcRo2/DzqZ59DZsIlSJyUzzmXaQUR
         o9lECrRSIywcSDyXDOXQcb2GhAfJsIRnTX8d9NBL3ofsnzTmJAKpJpWpLj+8P9nsOlrS
         XwTMcyUDwE/TXeUd9tBOR3NimuMNZ5ko6p4UwE/8vx9zLd7q+8EGGZnZY/l4am2POhqO
         4Jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vxCizGjPP8oXWBLfTZQwIA3YFQNWiqW6fSdu870FudY=;
        b=SPutRx7cEI9HZRX4k8a00bTIO0VJvozrH8tLldcaHHRB3uE1VRsPSVWMn822FayRoH
         Qd6r1BoXfI/CC5JV/vOzxwsqFxv1VK4owYOZt46KgZqKivZMIiX01iXp4RZLx5EfmyG2
         5TnjwJ74yFCiQHsV+E9mBCJDdydfSVN2Z+JHOcQL66w6+lagiZLpmJ61GVe1NdnmoZ1Z
         aGmsjbNwpUxRksJ4Ss0Ea11YtAS50IU1MboTjN4khSAr5zqQ5dIvNLf/froQi1ohUz8D
         KDUJ7zvqBW6tMhxSkxMYji8OhsgIRtm1Wbr8bAX/xA9plo/uDFpSlDTw0VZ2GL0NHKlN
         Nvww==
X-Gm-Message-State: AOAM530243AtBs6OFMXMmmDtir+rSNWNsmitm6sF2ue9TZdEn8VPjo3y
        d2eqtV6WXKqCXUXtIs+gYbc=
X-Google-Smtp-Source: ABdhPJzZ3O91ltE6Zbn0LtMwEL8EwSPbVn4ejvlUkMt0nskHkpvbJXrfAPS8gD4qjHOndB4tpVF9GA==
X-Received: by 2002:a17:907:2d2a:: with SMTP id gs42mr15239498ejc.106.1643591172753;
        Sun, 30 Jan 2022 17:06:12 -0800 (PST)
Received: from localhost.localdomain ([188.27.63.13])
        by smtp.gmail.com with ESMTPSA id d16sm12549276ejy.135.2022.01.30.17.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 17:06:12 -0800 (PST)
From:   Albert Geanta <albertgeanta@gmail.com>
To:     alsa-devel@alsa-project.org
Cc:     stable@vger.kernel.org, Albert Geanta <albertgeanta@gmail.com>
Subject: [PATCH] ALSA: hda/realtek: Add quirk for ASUS GU603
Date:   Mon, 31 Jan 2022 03:05:23 +0200
Message-Id: <20220131010523.546386-1-albertgeanta@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ASUS GU603 (Zephyrus M16 - SSID 1043:16b2) requires a quirk similar to
other ASUS devices for correctly routing the 4 integrated speakers. This
fixes it by adding a corresponding quirk entry, which connects the bass
speakers to the proper DAC.

Signed-off-by: Albert Geantă <albertgeanta@gmail.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 668274e52674..61b314c7dbc9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8969,6 +8969,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89452359A18
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbhDIJ4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhDIJzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:55:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1845E6115B;
        Fri,  9 Apr 2021 09:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962123;
        bh=MTJHk6ahuEGox4z9zkGzrjsztitpvcgvjDXnoQWHf9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlzyO01/vm0cpqmdnnNDCEhnVt2PBrwXteiaCJb33h6S+UlZY2Zw3o55ws/PjzEQa
         FiscNec4xGrv9cbkdmOMtyZCgDCzzwc5xsgRnBHDZpoohILwxcS91gOP2ztYvJMsJX
         qpTuuQsSkTpayJqaA5tC8rZaaelpksq3+86pDjaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Shih-Yuan Lee (FourDollars)" <sylee@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 11/13] ALSA: hda/realtek - Fix pincfg for Dell XPS 13 9370
Date:   Fri,  9 Apr 2021 11:53:31 +0200
Message-Id: <20210409095259.997727415@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.624577828@linuxfoundation.org>
References: <20210409095259.624577828@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Shih-Yuan Lee (FourDollars)" <sylee@canonical.com>

commit 8df4b0031067758d8b0a3bfde7d35e980d0376d5 upstream

The initial pin configs for Dell headset mode of ALC3271 has changed.

/sys/class/sound/hwC0D0/init_pin_configs: (BIOS 0.1.4)
0x12 0xb7a60130
0x13 0xb8a61140
0x14 0x40000000
0x16 0x411111f0
0x17 0x90170110
0x18 0x411111f0
0x19 0x411111f0
0x1a 0x411111f0
0x1b 0x411111f0
0x1d 0x4087992d
0x1e 0x411111f0
0x21 0x04211020

has changed to ...

/sys/class/sound/hwC0D0/init_pin_configs: (BIOS 0.2.0)
0x12 0xb7a60130
0x13 0x40000000
0x14 0x411111f0
0x16 0x411111f0
0x17 0x90170110
0x18 0x411111f0
0x19 0x411111f0
0x1a 0x411111f0
0x1b 0x411111f0
0x1d 0x4067992d
0x1e 0x411111f0
0x21 0x04211020

Fixes: b4576de87243 ("ALSA: hda/realtek - Fix typo of pincfg for Dell quirk")
Signed-off-by: Shih-Yuan Lee (FourDollars) <sylee@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6285,7 +6285,6 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0299, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		ALC225_STANDARD_PINS,
 		{0x12, 0xb7a60130},
-		{0x13, 0xb8a61140},
 		{0x17, 0x90170110}),
 	{}
 };



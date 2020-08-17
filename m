Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E8E246CE3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbgHQQb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731111AbgHQQSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:18:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B9420829;
        Mon, 17 Aug 2020 16:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597681073;
        bh=JU4CrObSjjW2Pn0ejksPiGM0pJ3DEvEDDzl8MP+NMXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brMdhxgBK1uCpB/4X/2iabQipsjehklVElF1J1HhwuMFsjmRqykx1ZnbC9mm3++wj
         H5rF873TKfXVqg5S0VtjQz5yPqfuS/rEKF/43niJAsLQVcVToSZcONEljAUON5eH2Z
         t9hYjC4xLzkc0USjjMjhS6sirXokkMmJgfOr4xP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 140/168] ALSA: hda - fix the micmute led status for Lenovo ThinkCentre AIO
Date:   Mon, 17 Aug 2020 17:17:51 +0200
Message-Id: <20200817143740.687123368@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 386a6539992b82fe9ac4f9dc3f548956fd894d8c upstream.

After installing the Ubuntu Linux, the micmute led status is not
correct. Users expect that the led is on if the capture is disabled,
but with the current kernel, the led is off with the capture disabled.

We tried the old linux kernel like linux-4.15, there is no this issue.
It looks like we introduced this issue when switching to the led_cdev.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200810021659.7429-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4072,6 +4072,7 @@ static void alc233_fixup_lenovo_line2_mi
 {
 	struct alc_spec *spec = codec->spec;
 
+	spec->micmute_led_polarity = 1;
 	alc_fixup_hp_gpio_led(codec, action, 0, 0x04);
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->init_amp = ALC_INIT_DEFAULT;



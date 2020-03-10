Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4636D17FBEB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbgCJNLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbgCJNLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF1320409;
        Tue, 10 Mar 2020 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845913;
        bh=6dG/Fsm2aNccggQy4jaRp9mUm2qB0CuG5n7vdcVBpMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvSAi+BHxpUsQRgDd7+KlUzQ9BQWizq/ZoK9KKSjIVgjm06nY3u+17OQS3tfJsSqI
         C8efp7ky1DItyx+Xi8XdoW8EeyNiUoXfuZSIAmfXI1RrN/0nK3tGoYnC0O/dKqqYjc
         1BwEvhiiJG1Xdef+GYI/YJNUkrZhMrFZn6Lnmito=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/86] ALSA: hda/realtek - Fix a regression for mute led on Lenovo Carbon X1
Date:   Tue, 10 Mar 2020 13:44:26 +0100
Message-Id: <20200310124530.942125402@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit c37c0ab029569a75fd180edb03d411e7a28a936f ]

Need to chain the THINKPAD_ACPI, otherwise the mute led will not
work.

Fixes: d2cd795c4ece ("ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200219052306.24935-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 94fffc0675a7b..f5f5169b093d4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6465,6 +6465,8 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC285_FIXUP_SPEAKER2_TO_DAC1] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_speaker2_to_dac1,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_THINKPAD_ACPI
 	},
 	[ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER] = {
 		.type = HDA_FIXUP_PINS,
-- 
2.20.1




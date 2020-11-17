Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF62B64C0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbgKQNtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731620AbgKQNeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCFB421534;
        Tue, 17 Nov 2020 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620043;
        bh=BCIW4p1Zo0de6sLNV3F/jr2YLbIlZOnqPwNQULCrSxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18rK+1dNf9G5BQZn74uCPX2gRIyQR8SnCZJ/a3w1A5fDzgbG1ize0R5kb182YPMBO
         IOVPKUVEVwyY1TXp2kUMPYYn/gd0a8iYJo4nMHA4Q6ZxGQM4fI4PILoE7aEBjF49go
         GMaqKQd2Mtc6P5jkk0BRli0f8uo1LihHUC+PAU5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 087/255] ALSA: hda: Reinstate runtime_allow() for all hda controllers
Date:   Tue, 17 Nov 2020 14:03:47 +0100
Message-Id: <20201117122143.193381808@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 9fc149c3bce7bdbb94948a8e6bd025e3b3538603 ]

The broken jack detection should be fixed by commit a6e7d0a4bdb0 ("ALSA:
hda: fix jack detection with Realtek codecs when in D3"), let's try
enabling runtime PM by default again.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20201027130038.16463-4-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 268e9ead9795f..0ae0290eb2bfd 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2361,6 +2361,7 @@ static int azx_probe_continue(struct azx *chip)
 
 	if (azx_has_pm_runtime(chip)) {
 		pm_runtime_use_autosuspend(&pci->dev);
+		pm_runtime_allow(&pci->dev);
 		pm_runtime_put_autosuspend(&pci->dev);
 	}
 
-- 
2.27.0




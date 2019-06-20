Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF44D6DC
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbfFTSM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbfFTSM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:12:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17CE12084E;
        Thu, 20 Jun 2019 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054377;
        bh=O7c2awUdbbtZs2EvYOyiLVtc9HeulBl01pu+z1OwIHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rq4BCBM49A3TohbTqwNEkvtrrjkuA/Lz7ghjht4NKy8NmHv45TrGk2MZd+n+6LXNB
         5BNyycUCMrHCuI+PdvXELd0ZrZakmVMz/zlUjZ/yq9ctq7s9uhZvVYA/Wp0QleKJwr
         iN3Ejka9hu83RydtXX6Jk+Fsi9DgeqE7b5x3Uw9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/61] ALSA: hda - Force polling mode on CNL for fixing codec communication
Date:   Thu, 20 Jun 2019 19:57:33 +0200
Message-Id: <20190620174344.015284833@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fa763f1b2858752e6150ffff46886a1b7faffc82 ]

We observed the same issue as reported by commit a8d7bde23e7130686b7662
("ALSA: hda - Force polling mode on CFL for fixing codec communication")
We don't have a better solution. So apply the same workaround to CNL.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 45bf89ed31de..308ce76149cc 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -378,6 +378,7 @@ enum {
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 #define IS_CFL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0xa348)
+#define IS_CNL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x9dc8)
 
 static char *driver_short_names[] = {
 	[AZX_DRIVER_ICH] = "HDA Intel",
@@ -1795,8 +1796,8 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 	else
 		chip->bdl_pos_adj = bdl_pos_adj[dev];
 
-	/* Workaround for a communication error on CFL (bko#199007) */
-	if (IS_CFL(pci))
+	/* Workaround for a communication error on CFL (bko#199007) and CNL */
+	if (IS_CFL(pci) || IS_CNL(pci))
 		chip->polling_mode = 1;
 
 	err = azx_bus_init(chip, model[dev], &pci_hda_io_ops);
-- 
2.20.1




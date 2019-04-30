Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2E2F7B1
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfD3LoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730110AbfD3LoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:44:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845B321734;
        Tue, 30 Apr 2019 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624651;
        bh=mY0sJyJHdhhOT3Ehwup/Tba7f1JcdM1DTG0ELVsBdBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihcQFwBgcsVnfocXL2Mm6IK/bf031BYtDvPPjkunMR77EOf701nuM1L2BmjwLHgz9
         HpkVZESvH1xTewZeJD0UGXseFVJYnWy2on3+XbVuuOBLrcdUmYhoxk+qKvmPjKp4Nd
         iq6CuR6sNOTZI5OyK9T9WB+AbcMAxxAkuG6Ec/b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/100] ALSA: hda/ca0132 - Fix build error without CONFIG_PCI
Date:   Tue, 30 Apr 2019 13:37:50 +0200
Message-Id: <20190430113609.903057754@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c97617a81a7616d49bc3700959e08c6c6f447093 ]

A call of pci_iounmap() call without CONFIG_PCI leads to a build error
on some architectures.  We tried to address this and add a check of
IS_ENABLED(CONFIG_PCI), but this still doesn't seem enough for sh.
Ideally we should fix it globally, it's really a corner case, so let's
paper over it with a simpler ifdef.

Fixes: 1e73359a24fa ("ALSA: hda/ca0132 - make pci_iounmap() call conditional")
Reported-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 80f73810b21b..0436789e7cd8 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -7394,8 +7394,10 @@ static void ca0132_free(struct hda_codec *codec)
 	ca0132_exit_chip(codec);
 
 	snd_hda_power_down(codec);
-	if (IS_ENABLED(CONFIG_PCI) && spec->mem_base)
+#ifdef CONFIG_PCI
+	if (spec->mem_base)
 		pci_iounmap(codec->bus->pci, spec->mem_base);
+#endif
 	kfree(spec->spec_init_verbs);
 	kfree(codec->spec);
 }
-- 
2.19.1




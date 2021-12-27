Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E8F47FEB1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbhL0Pa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:30:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35386 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237625AbhL0PaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:30:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03009B810B9;
        Mon, 27 Dec 2021 15:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6E6C36AE7;
        Mon, 27 Dec 2021 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619019;
        bh=8NcTJMBUM/PsY5EIjirWHljvPxiDrnTC/nH+pvVWWS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHAC2PhR2mfag+7H5KFjhlmuKfg9OzPw4CRBLNVl1XhD9OeSx9CVVbAGgnib/5WT2
         Xgc/KB5RAGoAJQdI41L6Vft95dMPtck2y0b6eyUK+++xhJC/HVag725nuq3iwrBfC7
         yB6jhiLnnV6zSgvrCPT7XpZ6QIB0zq3sq2odWAQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 16/29] ALSA: drivers: opl3: Fix incorrect use of vp->state
Date:   Mon, 27 Dec 2021 16:27:26 +0100
Message-Id: <20211227151318.997012000@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>

commit 2dee54b289fbc810669a1b2b8a0887fa1c9a14d7 upstream.

Static analysis with scan-build has found an assignment to vp2 that is
never used. It seems that the check on vp->state > 0 should be actually
on vp2->state instead. Fix this.

This dates back to 2002, I found the offending commit from the git
history git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git,
commit 91e39521bbf6 ("[PATCH] ALSA patch for 2.5.4")

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211212172025.470367-1-colin.i.king@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/opl3/opl3_midi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/drivers/opl3/opl3_midi.c
+++ b/sound/drivers/opl3/opl3_midi.c
@@ -415,7 +415,7 @@ void snd_opl3_note_on(void *p, int note,
 	}
 	if (instr_4op) {
 		vp2 = &opl3->voices[voice + 3];
-		if (vp->state > 0) {
+		if (vp2->state > 0) {
 			opl3_reg = reg_side | (OPL3_REG_KEYON_BLOCK +
 					       voice_offset + 3);
 			reg_val = vp->keyon_reg & ~OPL3_KEYON_BIT;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBEB38EE4A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhEXPsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233744AbhEXPqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:46:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F26C56108E;
        Mon, 24 May 2021 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870595;
        bh=pzldK/ODVQn7pBn2K65hBAv2hXuUOjSPmxb6eH4ybLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDWhd85mYEcpVZhdnPmc9D+cuzo8Mg1qmelT1uX5R+gLJqc+dfS71lsf09q2fqCjI
         CKPbDtdMwSv6/PmN91hQiF5h7lhNxoj80xOMEyjNolO0Jej8kayU+go031FWo/W6zf
         IoHLy7gcj6OaZYZMG7zhpxh1wppmqewZPfRzLnRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 18/71] ALSA: dice: fix stream format for TC Electronic Konnekt Live at high sampling transfer frequency
Date:   Mon, 24 May 2021 17:25:24 +0200
Message-Id: <20210524152327.052940887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 4c6fe8c547e3c9e8c15dabdd23c569ee0df3adb1 upstream.

At high sampling transfer frequency, TC Electronic Konnekt Live
transfers/receives 6 audio data frames in multi bit linear audio data
channel of data block in CIP payload. Current hard-coded stream format
is wrong.

Cc: <stable@vger.kernel.org>
Fixes: f1f0f330b1d0 ("ALSA: dice: add parameters of stream formats for models produced by TC Electronic")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210518012612.37268-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/dice/dice-tcelectronic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/firewire/dice/dice-tcelectronic.c
+++ b/sound/firewire/dice/dice-tcelectronic.c
@@ -38,8 +38,8 @@ static const struct dice_tc_spec konnekt
 };
 
 static const struct dice_tc_spec konnekt_live = {
-	.tx_pcm_chs = {{16, 16, 16}, {0, 0, 0} },
-	.rx_pcm_chs = {{16, 16, 16}, {0, 0, 0} },
+	.tx_pcm_chs = {{16, 16, 6}, {0, 0, 0} },
+	.rx_pcm_chs = {{16, 16, 6}, {0, 0, 0} },
 	.has_midi = true,
 };
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4752B63B3
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732898AbgKQNkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732894AbgKQNkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64CE62465E;
        Tue, 17 Nov 2020 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620446;
        bh=hDm07hmMZqMdno+nmMKZ5DeVXRppk4ddKQGEXEM6S1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEVMnZyG0UhKaK79dC1xD03UqFNRfMB2gizs4nYF9PMLP+Xf7DpBGhvPGuKxOJz+G
         WqYNjsCxkTbiC4Xadt7zgOk1cLu5BSeuxKqiteGBYCyBbD39Rmm/8V14u0q1Jr383m
         tAKynDXzU1HaJoyRy2io5WcULshQyh7Jq36vJGew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirk Reiser <kirk@reisers.ca>,
        Gregory Nowak <greg@gregn.net>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.9 192/255] speakup: Fix var_id_t values and thus keymap
Date:   Tue, 17 Nov 2020 14:05:32 +0100
Message-Id: <20201117122148.272346908@linuxfoundation.org>
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

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit d7012df3c9aecdcfb50f7a2ebad766952fd1410e upstream.

commit d97a9d7aea04 ("staging/speakup: Add inflection synth parameter")
introduced a new "inflection" speakup parameter next to "pitch", but
the values of the var_id_t enum are actually used by the keymap tables
so we must not renumber them. The effect was that notably the volume
control shortcut (speakup-1 or 2) was actually changing the inflection.

This moves the INFLECTION value at the end of the var_id_t enum to
fix back the enum values. This also adds a warning about it.

Fixes: d97a9d7aea04 ("staging/speakup: Add inflection synth parameter")
Cc: stable@vger.kernel.org
Reported-by: Kirk Reiser <kirk@reisers.ca>
Reported-by: Gregory Nowak <greg@gregn.net>
Tested-by: Gregory Nowak <greg@gregn.net>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20201012160646.qmdo4eqtj24hpch4@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/accessibility/speakup/spk_types.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/accessibility/speakup/spk_types.h
+++ b/drivers/accessibility/speakup/spk_types.h
@@ -32,6 +32,10 @@ enum {
 	E_NEW_DEFAULT,
 };
 
+/*
+ * Note: add new members at the end, speakupmap.h depends on the values of the
+ * enum starting from SPELL_DELAY (see inc_dec_var)
+ */
 enum var_id_t {
 	VERSION = 0, SYNTH, SILENT, SYNTH_DIRECT,
 	KEYMAP, CHARS,
@@ -42,9 +46,9 @@ enum var_id_t {
 	SAY_CONTROL, SAY_WORD_CTL, NO_INTERRUPT, KEY_ECHO,
 	SPELL_DELAY, PUNC_LEVEL, READING_PUNC,
 	ATTRIB_BLEEP, BLEEPS,
-	RATE, PITCH, INFLECTION, VOL, TONE, PUNCT, VOICE, FREQUENCY, LANG,
+	RATE, PITCH, VOL, TONE, PUNCT, VOICE, FREQUENCY, LANG,
 	DIRECT, PAUSE,
-	CAPS_START, CAPS_STOP, CHARTAB,
+	CAPS_START, CAPS_STOP, CHARTAB, INFLECTION,
 	MAXVARS
 };
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BDE304B3A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbhAZEsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbhAYSpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FB8422460;
        Mon, 25 Jan 2021 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600294;
        bh=e0Ty4pCZkGjsK14w8f92uSSiaSSYm5pQGe0C7bzJxeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxVZ4natQMYg9brcHTUPf9C6IKpkr0GrmKnSGlh1Hh9BrZfiNYht/woJInGlJo810
         iNl8Zdb7TLzXfI8+8A+RdkW4BunsuEkMqQMx33vxDSht9TxQ36Wbwgr2wK37jZipgP
         5Kx05jfoAm/lBGf3MYoDrgPkrpEhQSmQA4QHF0OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 05/86] ALSA: hda/via: Add minimum mute flag
Date:   Mon, 25 Jan 2021 19:38:47 +0100
Message-Id: <20210125183201.265447013@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 67ea698c3950d10925be33c21ca49ffb64e21842 upstream.

It turned out that VIA codecs also mute the sound in the lowest mixer
level.  Turn on the dac_min_mute flag to indicate the mute-as-minimum
in TLV like already done in Conexant and IDT codecs.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210559
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210114072453.11379-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -113,6 +113,7 @@ static struct via_spec *via_new_spec(str
 		spec->codec_type = VT1708S;
 	spec->gen.indep_hp = 1;
 	spec->gen.keep_eapd_on = 1;
+	spec->gen.dac_min_mute = 1;
 	spec->gen.pcm_playback_hook = via_playback_pcm_hook;
 	spec->gen.add_stereo_mix_input = HDA_HINT_STEREO_MIX_AUTO;
 	codec->power_save_node = 1;



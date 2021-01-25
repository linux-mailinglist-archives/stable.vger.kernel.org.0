Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11761302A89
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbhAYSme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbhAYSm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EC0A2067B;
        Mon, 25 Jan 2021 18:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600086;
        bh=CTE8a0ckAaAcL26TQnYiCu6KMd/VKB9yCuANcjHECrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1ii0kG2WVT6MLKSDEUKipLBgREN4eiBwTxAe/C8Z9vWgwT9Ft5zMtAxTFS14BiC6
         zn/xxUzKpdKEZjmDIbpFFxeMQbSfaJGlfs4eeQ7xR8fWluKaTd1VpewAVkL6wTaZnb
         IrRrXe/CIOSzoKzHyyiK8vFNA1Ag9CyIswO+6ia4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 03/58] ALSA: hda/via: Add minimum mute flag
Date:   Mon, 25 Jan 2021 19:39:04 +0100
Message-Id: <20210125183156.847196586@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
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
@@ -126,6 +126,7 @@ static struct via_spec *via_new_spec(str
 		spec->codec_type = VT1708S;
 	spec->gen.indep_hp = 1;
 	spec->gen.keep_eapd_on = 1;
+	spec->gen.dac_min_mute = 1;
 	spec->gen.pcm_playback_hook = via_playback_pcm_hook;
 	spec->gen.add_stereo_mix_input = HDA_HINT_STEREO_MIX_AUTO;
 	codec->power_save_node = 1;



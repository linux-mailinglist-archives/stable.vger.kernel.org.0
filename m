Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B1A353CD9
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhDEI5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232586AbhDEI5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38DBD610E8;
        Mon,  5 Apr 2021 08:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613015;
        bh=2toyl2ADBG1UD6BhombtMX5ac1KksflKVYr9VzK2RJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi3BvsSTU1qdBRqv+BYo812K3KfbQORjSUC75e2i/TB9k97GHADIc+XTGserkO45O
         9MPaMbOMkxkgwu5zuA9vN4/vbO9soTbAbgRFg0pi1ZffRjm0GNro7UJ+Qy6htStY2C
         g0HwVsoWx3scH4vkJXWsv38/yKRxswq2UbvkuRTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 20/35] ALSA: hda/realtek: call alc_update_headset_mode() in hp_automute_hook
Date:   Mon,  5 Apr 2021 10:53:55 +0200
Message-Id: <20210405085019.518324342@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit e54f30befa7990b897189b44a56c1138c6bfdbb5 upstream.

We found the alc_update_headset_mode() is not called on some machines
when unplugging the headset, as a result, the mode of the
ALC_HEADSET_MODE_UNPLUGGED can't be set, then the current_headset_type
is not cleared, if users plug a differnt type of headset next time,
the determine_headset_type() will not be called and the audio jack is
set to the headset type of previous time.

On the Dell machines which connect the dmic to the PCH, if we open
the gnome-sound-setting and unplug the headset, this issue will
happen. Those machines disable the auto-mute by ucm and has no
internal mic in the input source, so the update_headset_mode() will
not be called by cap_sync_hook or automute_hook when unplugging, and
because the gnome-sound-setting is opened, the codec will not enter
the runtime_suspend state, so the update_headset_mode() will not be
called by alc_resume when unplugging. In this case the
hp_automute_hook is called when unplugging, so add
update_headset_mode() calling to this function.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210320091542.6748-2-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4304,6 +4304,7 @@ static void alc_update_headset_jack_cb(s
 	struct alc_spec *spec = codec->spec;
 	spec->current_headset_type = ALC_HEADSET_TYPE_UNKNOWN;
 	snd_hda_gen_hp_automute(codec, jack);
+	alc_update_headset_mode(codec);
 }
 
 static void alc_probe_headset_mode(struct hda_codec *codec)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650A329B61B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796838AbgJ0PUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796834AbgJ0PUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:20:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 781FF20728;
        Tue, 27 Oct 2020 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812006;
        bh=HdDfKqdDl9jL2oa9/5M7IYCYqaUTL4ZctplRvPI00K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnW92QHr1Wobx8w8gt8PRg506H7ikX5OolyVnUx4fEqs6UgqkLktHhZBLZAjy/nX/
         Z/M8SSZwycGur41YceJm6/mGLtxrm3+VBHEiTuntwDD4B86etcC1mgiM54Tv4Ok8jR
         CCjhVolze7PlCtoKhTwEB2p9oulaIHFKSU9VTvzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 059/757] ALSA: hda - Dont register a cb func if it is registered already
Date:   Tue, 27 Oct 2020 14:45:09 +0100
Message-Id: <20201027135453.328413877@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit f4794c6064a83d2c57b264bd299c367d172d1044 upstream.

If the caller of enable_callback_mst() passes a cb func, the callee
function will malloc memory and link this cb func to the list
unconditionally. This will introduce problem if caller is in the
hda_codec_ops.init() since the init() will be repeatedly called in the
codec rt_resume().

So far, the patch_hdmi.c and patch_ca0132.c call enable_callback_mst()
in the hda_codec_ops.init().

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200930055146.5665-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_jack.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -275,6 +275,18 @@ int snd_hda_jack_detect_state_mst(struct
 }
 EXPORT_SYMBOL_GPL(snd_hda_jack_detect_state_mst);
 
+static bool func_is_already_in_callback_list(struct hda_jack_tbl *jack,
+					     hda_jack_callback_fn func)
+{
+	struct hda_jack_callback *cb;
+
+	for (cb = jack->callback; cb; cb = cb->next) {
+		if (cb->func == func)
+			return true;
+	}
+	return false;
+}
+
 /**
  * snd_hda_jack_detect_enable_mst - enable the jack-detection
  * @codec: the HDA codec
@@ -297,7 +309,7 @@ snd_hda_jack_detect_enable_callback_mst(
 	jack = snd_hda_jack_tbl_new(codec, nid, dev_id);
 	if (!jack)
 		return ERR_PTR(-ENOMEM);
-	if (func) {
+	if (func && !func_is_already_in_callback_list(jack, func)) {
 		callback = kzalloc(sizeof(*callback), GFP_KERNEL);
 		if (!callback)
 			return ERR_PTR(-ENOMEM);



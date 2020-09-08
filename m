Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9026194E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgIHSMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731482AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8527D24751;
        Tue,  8 Sep 2020 15:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579683;
        bh=8aUkVrdlKzXA1oR6Zc/t9V+ViwSRjUFeYtF4BGaGNwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKTDHDskIcrYpfkBucLnBxif6JiZ1H0ZAQXdvdQ7SKEQDxSDG2lfq39w00DC8f9p3
         bgExHdCfcuONKoqAVSAJ8837AcI+zzasZ1FRePSn9Vft7WFxMWKFrKH7JlTt8fp5Jn
         EAgTgoaqCtE31yTNTM/tyfyzhR8I7r0QYCW5YRE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 139/186] ALSA: hda/hdmi: always check pin power status in i915 pin fixup
Date:   Tue,  8 Sep 2020 17:24:41 +0200
Message-Id: <20200908152248.395837533@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit 858e0ad9301d1270c02b5aca97537d2d6ee9dd68 upstream.

When system is suspended with active audio playback to HDMI/DP, two
alternative sequences can happen at resume:
  a) monitor is detected first and ALSA prepare follows normal
     stream setup sequence, or
  b) ALSA prepare is called first, but monitor is not yet detected,
     so PCM is restarted without a pin,

In case of (b), on i915 systems, haswell_verify_D0() is not called at
resume and the pin power state may be incorrect. Result is lack of audio
after resume with no error reported back to user-space.

Fix the problem by always verifying converter and pin state in the
i915_pin_cvt_fixup().

BugLink: https://github.com/thesofproject/linux/issues/2388
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200826170306.701566-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2737,6 +2737,7 @@ static void i915_pin_cvt_fixup(struct hd
 			       hda_nid_t cvt_nid)
 {
 	if (per_pin) {
+		haswell_verify_D0(codec, per_pin->cvt_nid, per_pin->pin_nid);
 		snd_hda_set_dev_select(codec, per_pin->pin_nid,
 			       per_pin->dev_id);
 		intel_verify_pin_cvt_connect(codec, per_pin);



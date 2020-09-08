Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE226179D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731663AbgIHRjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbgIHQOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:14:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E344724905;
        Tue,  8 Sep 2020 15:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580416;
        bh=Y5Swf/4pKnGZ9O4qJuYRRHDMaCKKDZ9ukoJvF9CpBjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4xKpHCW9gHLDIowi+kEQEmT5+Au/n1a5E+AX+rVg3VpCVRb9MsKFNq8iDGfZaGbK
         k1hJZR+4R0bdiDlsVh/zrYZYXSKJvZ5/e3y8kQt/xlBxxB72Ky1Sklo0TKwhOvqMuh
         W1+6V8khZAsVKVOs6FBSXVsrBiAM+NKYa3krmpLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 49/65] ALSA: hda/hdmi: always check pin power status in i915 pin fixup
Date:   Tue,  8 Sep 2020 17:26:34 +0200
Message-Id: <20200908152219.570655832@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
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
@@ -2546,6 +2546,7 @@ static void i915_pin_cvt_fixup(struct hd
 			       hda_nid_t cvt_nid)
 {
 	if (per_pin) {
+		haswell_verify_D0(codec, per_pin->cvt_nid, per_pin->pin_nid);
 		snd_hda_set_dev_select(codec, per_pin->pin_nid,
 			       per_pin->dev_id);
 		intel_verify_pin_cvt_connect(codec, per_pin);



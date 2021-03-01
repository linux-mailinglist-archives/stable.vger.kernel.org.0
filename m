Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3677332913F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbhCAUXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242792AbhCAUQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:16:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30FC76506B;
        Mon,  1 Mar 2021 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621750;
        bh=13/SFlDXf22dps/MVLYCYrY6oU1978dBydjZlNBbMfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wz0Y8GGedfhcxpj4ps195F9IlWQKdKDbEDHLueeWA1gyc/NK3XQSthBQ/v95qu8nm
         N8JAsveECdFM0sLwfE3tNHeCA8yWSbbrlId/6uSZTGuPaQB4IN5Y47FrDRH39zJ9a6
         5ecMNyB8/kb+AWaJPBxVU7zIDYYqlnVKATcq/5Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 600/775] ALSA: hda/hdmi: Drop bogus check at closing a stream
Date:   Mon,  1 Mar 2021 17:12:48 +0100
Message-Id: <20210301161231.069419072@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 056a3da5d07fc5d3ceacfa2cdf013c9d8df630bd upstream.

Some users reported the kernel WARNING with stack traces from
hdmi_pcm_close(), and it's the line checking the per_cvt->assigned
flag.  This used to be a valid check in the past because the flag was
turned on/off only at opening and closing a PCM stream.  Meanwhile,
since the introduction of the silent-stream mode, this flag may be
turned on/off at the monitor connection/disconnection time, which
isn't always associated with the PCM open/close.  Hence this may lead
to the inconsistent per_cvt->assigned flag at closing.

As the check itself became almost useless and confuses users as if it
were a serious problem, just drop the check.

Fixes: b1a5039759cb ("ALSA: hda/hdmi: fix silent stream for first playback to DP")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210987
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210211083139.29531-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2130,7 +2130,6 @@ static int hdmi_pcm_close(struct hda_pcm
 			goto unlock;
 		}
 		per_cvt = get_cvt(spec, cvt_idx);
-		snd_BUG_ON(!per_cvt->assigned);
 		per_cvt->assigned = 0;
 		hinfo->nid = 0;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C63F33B55A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCONyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229929AbhCONxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17AFF64EF6;
        Mon, 15 Mar 2021 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816416;
        bh=xPOyjQVC9zn/UwBkVcl/FOk/o6vGCPsyRe8EBtqcggY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3qTcETC61KCJLbdDE26yzfaqw/j8Bg/dKBocdXHU4E1jjXXfVbQigL88Tu0E8X5o
         UtvVkrL09tXxfU9XLT4bqvfj7Boi1x0TabX2cUWCUUudb5y4RDhyiVs/WV498Psmjf
         808eHnYRQhgmKdCwGecn0JyW6QGi96jYfo3jeo2o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <abhsahu@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 26/78] ALSA: hda: Avoid spurious unsol event handling during S3/S4
Date:   Mon, 15 Mar 2021 14:51:49 +0100
Message-Id: <20210315135212.921800364@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit 5ff9dde42e8c72ed8102eb8cb62e03f9dc2103ab upstream.

When HD-audio bus receives unsolicited events during its system
suspend/resume (S3 and S4) phase, the controller driver may still try
to process events although the codec chips are already (or yet)
powered down.  This might screw up the codec communication, resulting
in CORB/RIRB errors.  Such events should be rather skipped, as the
codec chip status such as the jack status will be fully refreshed at
the system resume time.

Since we're tracking the system suspend/resume state in codec
power.power_state field, let's add the check in the common unsol event
handler entry point to filter out such events.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1182377
Tested-by: Abhishek Sahu <abhsahu@nvidia.com>
Cc: <stable@vger.kernel.org> # 183ab39eb0ea: ALSA: hda: Initialize power_state
Link: https://lore.kernel.org/r/20210310112809.9215-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_bind.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -46,6 +46,10 @@ static void hda_codec_unsol_event(struct
 	if (codec->bus->shutdown)
 		return;
 
+	/* ignore unsol events during system suspend/resume */
+	if (codec->core.dev.power.power_state.event != PM_EVENT_ON)
+		return;
+
 	if (codec->patch_ops.unsol_event)
 		codec->patch_ops.unsol_event(codec, ev);
 }



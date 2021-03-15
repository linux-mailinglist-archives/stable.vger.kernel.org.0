Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E067733B7D3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCOOBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232599AbhCON7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2B7A64F48;
        Mon, 15 Mar 2021 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816763;
        bh=9ibA2mjQg2zuTjL39SlYdc/2f0IYeUrZryi5svSAFy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VbUbAS95j8aQWdfMenRZcMwjO/yXno+nFwakBpzT2qzsSSUBrp2OABYLu0Ir6Yt8
         +2lLpuPbAeZNANdTmdlss1/+DiypZIXGbneI94Nmhqfcmq4q0PLZDdiltHtipiXdyJ
         nulbHKZr89RLDWyiEY4k+CqSWuJsVqbpU49LzJhs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <abhsahu@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 093/168] ALSA: hda: Avoid spurious unsol event handling during S3/S4
Date:   Mon, 15 Mar 2021 14:55:25 +0100
Message-Id: <20210315135553.427747080@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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
@@ -47,6 +47,10 @@ static void hda_codec_unsol_event(struct
 	if (codec->bus->shutdown)
 		return;
 
+	/* ignore unsol events during system suspend/resume */
+	if (codec->core.dev.power.power_state.event != PM_EVENT_ON)
+		return;
+
 	if (codec->patch_ops.unsol_event)
 		codec->patch_ops.unsol_event(codec, ev);
 }



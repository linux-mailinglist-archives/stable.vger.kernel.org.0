Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D182733B7BE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhCOOBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232753AbhCON7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 719D964F71;
        Mon, 15 Mar 2021 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816762;
        bh=ozORQh8hrikD8yt6BfDuS1JtpN8Qi+X8VEgoqeZk4Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxvbYHNSo+qoJ47PppGPoEXjhqbPcCecHQ3d7WWKYc1OWWdRFoZAyeGxOZeOobZEU
         S5xa0OfWhuB0hazIH+AI4/u1cfpKt/zYMz5v48ND4nQtYl5MMEHvF8UGq+MNt5+r3Z
         HUSI+qN6614FkFut0AxGfKy2MMk4us/KUcT6xdvA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH 5.4 092/168] ALSA: hda: Flush pending unsolicited events before suspend
Date:   Mon, 15 Mar 2021 14:55:24 +0100
Message-Id: <20210315135553.396141668@linuxfoundation.org>
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

commit 13661fc48461282e43fe8f76bf5bf449b3d40687 upstream.

The HD-audio controller driver processes the unsolicited events via
its work asynchronously, and this might be pending when the system
goes to suspend.  When a lengthy event handling like ELD byte reads is
running, this might trigger unexpected accesses among suspend/resume
procedure, typically seen with Nvidia driver that still requires the
handling via unsolicited event verbs for ELD updates.

This patch adds the flush of unsol_work to assure that pending events
are processed before going into suspend.

Buglink: https://bugzilla.suse.com/show_bug.cgi?id=1182377
Reported-and-tested-by: Abhishek Sahu <abhsahu@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210310112809.9215-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1025,6 +1025,8 @@ static int azx_prepare(struct device *de
 	chip = card->private_data;
 	chip->pm_prepared = 1;
 
+	flush_work(&azx_bus(chip)->unsol_work);
+
 	/* HDA controller always requires different WAKEEN for runtime suspend
 	 * and system suspend, so don't use direct-complete here.
 	 */



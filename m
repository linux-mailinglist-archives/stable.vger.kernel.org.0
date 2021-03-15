Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F08033B9CE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhCOOGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233342AbhCOOBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC60864F94;
        Mon, 15 Mar 2021 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816862;
        bh=m0eptkftbLSjQQQ0ZaN37gBHuvMAVpnT1UwmsFU+owc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftdejxeF7ni31jPXmtzR45O5s8TFft9cPYnM/S2fIeSFAnSb8rR6rzH3TA+kKaj4/
         S7AXs+Vob+AgleVkLI5IVn8Dq8VEND7l6q8Le+NT+Bi2Rsk9hlS2EORW6kvIYlBT3l
         6I3kIfNpuqPIMwySeF+aLSosTIJLzYsA2izwtE4o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH 5.11 169/306] ALSA: hda: Flush pending unsolicited events before suspend
Date:   Mon, 15 Mar 2021 14:53:52 +0100
Message-Id: <20210315135513.336425794@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
@@ -1026,6 +1026,8 @@ static int azx_prepare(struct device *de
 	chip = card->private_data;
 	chip->pm_prepared = 1;
 
+	flush_work(&azx_bus(chip)->unsol_work);
+
 	/* HDA controller always requires different WAKEEN for runtime suspend
 	 * and system suspend, so don't use direct-complete here.
 	 */



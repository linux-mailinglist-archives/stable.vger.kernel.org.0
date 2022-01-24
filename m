Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A17499610
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442445AbiAXU65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:58:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50276 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351838AbiAXUxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5414AB8105C;
        Mon, 24 Jan 2022 20:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CFAC36AE7;
        Mon, 24 Jan 2022 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057598;
        bh=MXPVVBYHEXHFo4yE+Xal95RCl5qOtXe7FpJ1wCoXn6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3bEMADCtMjWy1Es7+2sAUryCsTybdAgQJ2C6bEgr4q1nCle61AgLMNEr2W+5/Ato
         hDX05m603y4/sCGE3bBO+sf+eI+YvZIItxMuWWRfmvSf+Z2jLzcoz9y0yn/QRyqOrc
         X7sXB4gLiuH9w2rPIe5fvr01Np//fB++8GUVn6sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 0008/1039] ALSA: core: Fix SSID quirk lookup for subvendor=0
Date:   Mon, 24 Jan 2022 19:29:57 +0100
Message-Id: <20220124184125.421745210@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5576c4f24c56722a2d9fb9c447d896e5b312078b upstream.

Some weird devices set the codec SSID vendor ID 0, and
snd_pci_quirk_lookup_id() loop aborts at the point although it should
still try matching with the SSID device ID.  This resulted in a
missing quirk for some old Macs.

Fix the loop termination condition to check both subvendor and
subdevice.

Fixes: 73355ddd8775 ("ALSA: hda: Code refactoring snd_hda_pick_fixup()")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215495
Link: https://lore.kernel.org/r/20220116082838.19382-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -112,7 +112,7 @@ snd_pci_quirk_lookup_id(u16 vendor, u16
 {
 	const struct snd_pci_quirk *q;
 
-	for (q = list; q->subvendor; q++) {
+	for (q = list; q->subvendor || q->subdevice; q++) {
 		if (q->subvendor != vendor)
 			continue;
 		if (!q->subdevice ||



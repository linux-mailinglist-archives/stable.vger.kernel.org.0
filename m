Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD764997F7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445924AbiAXVRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449145AbiAXVO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B691C06E027;
        Mon, 24 Jan 2022 12:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B47B6091A;
        Mon, 24 Jan 2022 20:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AA6C340E5;
        Mon, 24 Jan 2022 20:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055098;
        bh=MXPVVBYHEXHFo4yE+Xal95RCl5qOtXe7FpJ1wCoXn6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QW1X4c01vcnN+kOknMDZ2ROHTZAnJgESMi8jNjU2hd5hxKys4B8+i2SA/B8vg8PjO
         BxMGMJZbxsAysWW0iErg3EpL6J+2OXVji1LUfL/h1PQ36JkCh1XIQ7UPtlMg+Kg7hQ
         ipPtNu+5RXPeo7xJmm6NyeGLt0qPVTjfU/X8dXCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 008/846] ALSA: core: Fix SSID quirk lookup for subvendor=0
Date:   Mon, 24 Jan 2022 19:32:05 +0100
Message-Id: <20220124184101.185913749@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



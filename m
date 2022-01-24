Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4408C499B94
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574536AbiAXVto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456733AbiAXVjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3484C0419CE;
        Mon, 24 Jan 2022 12:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73A80614EC;
        Mon, 24 Jan 2022 20:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7C4C340E5;
        Mon, 24 Jan 2022 20:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056022;
        bh=spR1xNJx3bFfMAPFkVgQoFMpMInnlTc6YT27FCUaXOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYnSIfaockbukrz+5FzqR1719wCU+neKVUQ/OqWfVzgt+3loNr5dpOphPMdiVLotd
         nlzAPleItYr47BEcv8ATaXc6izEFk7G6NaDjICVMoymQpOdgOxcWiajoFu5QtnlvXH
         f2xpjk6ujQtV93jlyfeKMao/kozVTNajkcJR4SpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Hofman <pavel.hofman@ivitera.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/846] usb: gadget: u_audio: Subdevice 0 for capture ctls
Date:   Mon, 24 Jan 2022 19:37:24 +0100
Message-Id: <20220124184112.184479178@linuxfoundation.org>
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

From: Pavel Hofman <pavel.hofman@ivitera.com>

[ Upstream commit 601a5bc1aeef772ab1f47582fd322957799f5ab5 ]

Both capture and playback alsa devices use subdevice 0. Yet capture-side
ctls are defined for subdevice 1. The patch sets subdevice 0 for them.

Fixes: 02de698ca812 ("usb: gadget: u_audio: add bi-directional volume and mute support")
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Link: https://lore.kernel.org/r/20220105104643.90125-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index ad16163b5ff80..d22ac23c94b0f 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -1097,7 +1097,7 @@ int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 			}
 
 			kctl->id.device = pcm->device;
-			kctl->id.subdevice = i;
+			kctl->id.subdevice = 0;
 
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
@@ -1120,7 +1120,7 @@ int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 			}
 
 			kctl->id.device = pcm->device;
-			kctl->id.subdevice = i;
+			kctl->id.subdevice = 0;
 
 
 			kctl->tlv.c = u_audio_volume_tlv;
-- 
2.34.1




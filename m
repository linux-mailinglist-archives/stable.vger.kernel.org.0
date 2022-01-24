Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A5049A05A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843851AbiAXXGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841169AbiAXW5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:57:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EDBC03463F;
        Mon, 24 Jan 2022 13:12:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C90AB80FA3;
        Mon, 24 Jan 2022 21:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E762C340E5;
        Mon, 24 Jan 2022 21:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058760;
        bh=IixZNRqrC7fA+CC4osZInDTPVqKj2ZTmVK4/tN2viaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXuajE/5/YK/kjk4AiTKnXlQLCGC2HHoMPHaUJo2z44kY3SVr2o6yJgOBlJzCkWCJ
         YGTbLDRtqIBtflMIYtuqqFbprbOOiwn3QKi3a6qtx7GbHe7it8b56sTxD+K7XAX3ln
         8EXR1sqlnKyb4XkTqXqhF7ek8K43HZFwfCk6CL1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Hofman <pavel.hofman@ivitera.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0393/1039] usb: gadget: u_audio: Subdevice 0 for capture ctls
Date:   Mon, 24 Jan 2022 19:36:22 +0100
Message-Id: <20220124184138.534127053@linuxfoundation.org>
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
index 4fb05f9576a67..4561d7a183ff4 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -1147,7 +1147,7 @@ int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 			}
 
 			kctl->id.device = pcm->device;
-			kctl->id.subdevice = i;
+			kctl->id.subdevice = 0;
 
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
@@ -1170,7 +1170,7 @@ int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 			}
 
 			kctl->id.device = pcm->device;
-			kctl->id.subdevice = i;
+			kctl->id.subdevice = 0;
 
 
 			kctl->tlv.c = u_audio_volume_tlv;
-- 
2.34.1




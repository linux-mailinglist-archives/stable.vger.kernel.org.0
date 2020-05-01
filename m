Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2361C1483
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgEANkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731286AbgEANkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:40:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E9A20757;
        Fri,  1 May 2020 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340410;
        bh=ciDE7tLOhkX7ZhV4b5NJFGz06YbWng/dESEOjg+hBXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6QoBC1wuC8riJDAjrzZDCQJIKurlpIwtoxJh6eGGFJNpGvpOMH3v3eM6WrQ2Enbw
         CqVIMYam7++HEZL6Yh9BPcOZivAupEkCyzSVEDcHlQdIarCSya123NS4cB1qv4Qs6h
         jn5U8TJ+2IYymDqyil30tc48NEFpM/prKMNeNAEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 67/83] ALSA: hda: call runtime_allow() for all hda controllers
Date:   Fri,  1 May 2020 15:23:46 +0200
Message-Id: <20200501131541.054584956@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 9a6418487b566503c772cb6e7d3d44e652b019b0 ]

Before the pci_driver->probe() is called, the pci subsystem calls
runtime_forbid() and runtime_get_sync() on this pci dev, so only call
runtime_put_autosuspend() is not enough to enable the runtime_pm on
this device.

For controllers with vgaswitcheroo feature, the pci/quirks.c will call
runtime_allow() for this dev, then the controllers could enter
rt_idle/suspend/resume, but for non-vgaswitcheroo controllers like
Intel hda controllers, the runtime_pm is not enabled because the
runtime_allow() is not called.

Since it is no harm calling runtime_allow() twice, here let hda
driver call runtime_allow() for all controllers. Then the runtime_pm
is enabled on all controllers after the put_autosuspend() is called.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200414142725.6020-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a85b0cf7371a3..1673479b4eef3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2305,6 +2305,7 @@ static int azx_probe_continue(struct azx *chip)
 
 	if (azx_has_pm_runtime(chip)) {
 		pm_runtime_use_autosuspend(&pci->dev);
+		pm_runtime_allow(&pci->dev);
 		pm_runtime_put_autosuspend(&pci->dev);
 	}
 
-- 
2.20.1




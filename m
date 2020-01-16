Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF4213EF2E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393025AbgAPReu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393020AbgAPRet (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:34:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C3E3246A1;
        Thu, 16 Jan 2020 17:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196089;
        bh=Vs31waamsWD7SzIS5H+rhqQTbCNe4meiHZm1NTT59go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2uJWTaurT3WeFUk1cXpm8Fwk4rkNyTHsaf2rYvKk83XOaBkCmNdT2doIh5DSn53n
         OAzFLwv1GDDxDoWZGkSpStmUkvnuyX5sPKFdppE3VQ7BUc4qJjrVEGocrEWYcTpTJg
         uEESO6eSE/0F0CZJreap8Ua136z24jSaf5RvOkNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 003/251] ALSA: hda: fix unused variable warning
Date:   Thu, 16 Jan 2020 12:30:37 -0500
Message-Id: <20200116173445.21385-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 5b03006d5c58ddd31caf542eef4d0269bcf265b3 ]

When CONFIG_X86=n function azx_snoop doesn't use the variable chip it
only returns true.

sound/pci/hda/hda_intel.c: In function ‘dma_alloc_pages’:
sound/pci/hda/hda_intel.c:2002:14: warning: unused variable ‘chip’ [-Wunused-variable]
  struct azx *chip = bus_to_azx(bus);
              ^~~~

Create a inline function of azx_snoop.

Fixes: a41d122449be ("ALSA: hda - Embed bus into controller object")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index b83feecf1e40..8f9386998270 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -171,11 +171,10 @@ struct azx {
 #define azx_bus(chip)	(&(chip)->bus.core)
 #define bus_to_azx(_bus)	container_of(_bus, struct azx, bus.core)
 
-#ifdef CONFIG_X86
-#define azx_snoop(chip)		((chip)->snoop)
-#else
-#define azx_snoop(chip)		true
-#endif
+static inline bool azx_snoop(struct azx *chip)
+{
+	return !IS_ENABLED(CONFIG_X86) || chip->snoop;
+}
 
 /*
  * macros for easy use
-- 
2.20.1


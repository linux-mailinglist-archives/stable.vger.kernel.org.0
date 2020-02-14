Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F2C15E824
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394237AbgBNQ6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404484AbgBNQRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186B8246F4;
        Fri, 14 Feb 2020 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697050;
        bh=8aHHGS6tkGBLeGkwk9FMJYUq4EvcCZ+0UidKSNcAdGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f871c1EMNV7nfLzXbgTMAsT12Kq3SiTy1hrmZOVVH9gQ2cHClfo33i1HqGWO66hWW
         q3Nb8hs7gLUstKBVjP2ITRwU/NHLvA1GG2ciEZLv1sFmAw0ndy0d1tZZUn6s3ZUVpL
         7ku+eOclzzMaVFsch21IybdHh9xEfX+/1lGgsegQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 011/186] ALSA: ctl: allow TLV read operation for callback type of element in locked case
Date:   Fri, 14 Feb 2020 11:14:20 -0500
Message-Id: <20200214161715.18113-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit d61fe22c2ae42d9fd76c34ef4224064cca4b04b0 ]

A design of ALSA control core allows applications to execute three
operations for TLV feature; read, write and command. Furthermore, it
allows driver developers to process the operations by two ways; allocated
array or callback function. In the former, read operation is just allowed,
thus developers uses the latter when device driver supports variety of
models or the target model is expected to dynamically change information
stored in TLV container.

The core also allows applications to lock any element so that the other
applications can't perform write operation to the element for element
value and TLV information. When the element is locked, write and command
operation for TLV information are prohibited as well as element value.
Any read operation should be allowed in the case.

At present, when an element has callback function for TLV information,
TLV read operation returns EPERM if the element is locked. On the
other hand, the read operation is success when an element has allocated
array for TLV information. In both cases, read operation is success for
element value expectedly.

This commit fixes the bug. This change can be backported to v4.14
kernel or later.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20191223093347.15279-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 36571cd49be33..a0ce22164957c 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1467,8 +1467,9 @@ static int call_tlv_handler(struct snd_ctl_file *file, int op_flag,
 	if (kctl->tlv.c == NULL)
 		return -ENXIO;
 
-	/* When locked, this is unavailable. */
-	if (vd->owner != NULL && vd->owner != file)
+	/* Write and command operations are not allowed for locked element. */
+	if (op_flag != SNDRV_CTL_TLV_OP_READ &&
+	    vd->owner != NULL && vd->owner != file)
 		return -EPERM;
 
 	return kctl->tlv.c(kctl, op_flag, size, buf);
-- 
2.20.1


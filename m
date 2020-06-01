Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36801EAEAA
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgFASzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbgFASBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F4F52065C;
        Mon,  1 Jun 2020 18:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034465;
        bh=lYfWziiWkn5jLrFvpyipxsyoD5WcN1/v/djhZEq/Zl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzqgcdamKkP89RxeOdvxFrKv02bkkrhwGCafGpzWrNCWaNftu5U3x4h7mUKH3jX6G
         NyWi5MK++RxEpglaJ+Etwx8qHQBClUPbGUtAKBdNZ9Z1m/fx7QQ/2yaawsWLdu5C0j
         m3pmunmWJmVcFkcbpHQrRgmfsgaxtdJgwiZoC9Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Changming Liu <liu.changm@northeastern.edu>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 43/77] ALSA: hwdep: fix a left shifting 1 by 31 UB bug
Date:   Mon,  1 Jun 2020 19:53:48 +0200
Message-Id: <20200601174024.147973386@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changming Liu <liu.changm@northeastern.edu>

[ Upstream commit fb8cd6481ffd126f35e9e146a0dcf0c4e8899f2e ]

The "info.index" variable can be 31 in "1 << info.index".
This might trigger an undefined behavior since 1 is signed.

Fix this by casting 1 to 1u just to be sure "1u << 31" is defined.

Signed-off-by: Changming Liu <liu.changm@northeastern.edu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/BL0PR06MB4548170B842CB055C9AF695DE5B00@BL0PR06MB4548.namprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/hwdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index a73baa1242be..727219f40201 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -229,14 +229,14 @@ static int snd_hwdep_dsp_load(struct snd_hwdep *hw,
 	if (copy_from_user(&info, _info, sizeof(info)))
 		return -EFAULT;
 	/* check whether the dsp was already loaded */
-	if (hw->dsp_loaded & (1 << info.index))
+	if (hw->dsp_loaded & (1u << info.index))
 		return -EBUSY;
 	if (!access_ok(VERIFY_READ, info.image, info.length))
 		return -EFAULT;
 	err = hw->ops.dsp_load(hw, &info);
 	if (err < 0)
 		return err;
-	hw->dsp_loaded |= (1 << info.index);
+	hw->dsp_loaded |= (1u << info.index);
 	return 0;
 }
 
-- 
2.25.1




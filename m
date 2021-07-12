Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984CB3C55E5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350355AbhGLIMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354033AbhGLIDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AADC760FF4;
        Mon, 12 Jul 2021 07:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076771;
        bh=kNiOrzvcKNrD+ip7sSBcajzs+GpzpFmKuppADWUHlJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXS3/huOdM5U24B5T+V0mZ2nx9UrcWdsWdkpTUku/lOUr0VAzsHg7/6Q/gf7xM23p
         63d7T/nc1FsCB+CNmvXB3WyjLLJA1ZIl80hCbRkAqAB8vSwOpI0OAFZFXi4GIxrY2v
         pVecpkChUwKMDZacmo8s/tbDv7ToIUNgcx1DRm9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 750/800] staging: rtl8723bs: Fix an error handling path
Date:   Mon, 12 Jul 2021 08:12:53 +0200
Message-Id: <20210712061046.592736888@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit eb64c6f60ed5406da496cf772fee4b29674bcbb1 ]

'ret' is known to be 0 at this point. It must be set to -ENOMEM if a
memory allocation occurs.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/a9533d1594900152e1e64e9f09e54240e3b7062a.1624177169.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 5088c3731b6d..6d0d0beed402 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -420,8 +420,10 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, KeyMaterial);
 			pwep = kzalloc(wep_total_len, GFP_KERNEL);
-			if (!pwep)
+			if (!pwep) {
+				ret = -ENOMEM;
 				goto exit;
+			}
 
 			pwep->KeyLength = wep_key_len;
 			pwep->Length = wep_total_len;
-- 
2.30.2




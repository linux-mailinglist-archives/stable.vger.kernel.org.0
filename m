Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0831014C1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfKSFhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbfKSFhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE45E21823;
        Tue, 19 Nov 2019 05:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141824;
        bh=G8lJ2j3/oBPS6i/yoR6pbKyVq2pXSDmOnUhlWt+bOgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEtGWEwcvYRiZYdY2hSldDw+tarO0LXEDxKnzzqfHxdezrKen4JkAjYtOFJsJb0fd
         e/I+HcCZyDs0XKO9cjDaiSlHUpqzzJyMIXj00jTVVL+3SMzx0mYKVwt6BhdEimHQ9a
         MlRr5ESbxSC4orG3dvZ2DJpiXHAQFxZrVjIoogi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 293/422] brcmsmac: Use kvmalloc() for ucode allocations
Date:   Tue, 19 Nov 2019 06:18:10 +0100
Message-Id: <20191119051417.979638039@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6c3efbe77bc78bf49db851aec7f385be475afca6 ]

The ucode chunk might be relatively large and the allocation with
kmalloc() may fail occasionally.  Since the data isn't DMA-transferred
but by manual loops, we can use vmalloc instead of kmalloc.
For a better performance, though, kvmalloc() would be the best choice
in such a case, so let's replace with it.

Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1103431
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ecc89e718b9c1..6255fb6d97a70 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1578,10 +1578,10 @@ int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 			if (le32_to_cpu(hdr->idx) == idx) {
 				pdata = wl->fw.fw_bin[i]->data +
 					le32_to_cpu(hdr->offset);
-				*pbuf = kmemdup(pdata, len, GFP_KERNEL);
+				*pbuf = kvmalloc(len, GFP_KERNEL);
 				if (*pbuf == NULL)
 					goto fail;
-
+				memcpy(*pbuf, pdata, len);
 				return 0;
 			}
 		}
@@ -1629,7 +1629,7 @@ int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes, u32 idx)
  */
 void brcms_ucode_free_buf(void *p)
 {
-	kfree(p);
+	kvfree(p);
 }
 
 /*
-- 
2.20.1




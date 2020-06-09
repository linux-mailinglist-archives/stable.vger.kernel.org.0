Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59A41F4446
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgFIRxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733014AbgFIRxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B172074B;
        Tue,  9 Jun 2020 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725196;
        bh=miLTQdPwzuk9lQFiqP5cxP8nhx922KpR3g6Sz11QT1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfHaRxKfACHuJKy6i7epq16MqyLHTeIuApNuuXuAJIJAvxvEEisEG3Lq3TOtqTyKb
         o3JpqIJS+unhA7YldkMkWRQBn0m21tiTuIBa7bJOfyq01lcWK/t43Xrs8Y+p7L6vSx
         XF/Tn83LxMJFUIFIZ1pLU8GwwSgmTJfDlde/O268=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Terjan <pterjan@google.com>
Subject: [PATCH 5.4 24/34] staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK
Date:   Tue,  9 Jun 2020 19:45:20 +0200
Message-Id: <20200609174056.116658615@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pascal Terjan <pterjan@google.com>

commit 15ea976a1f12b5fd76b1bd6ff3eb5132fd28047f upstream.

The value in shared headers was fixed 9 years ago in commit 8d661f1e462d
("ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro") and
while looking at using shared headers for other duplicated constants
I noticed this driver uses the old value.

The macros are also defined twice in this file so I am deleting the
second definition.

Signed-off-by: Pascal Terjan <pterjan@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200523211247.23262-1-pterjan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/wifi.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/staging/rtl8712/wifi.h
+++ b/drivers/staging/rtl8712/wifi.h
@@ -440,7 +440,7 @@ static inline unsigned char *get_hdr_bss
 /* block-ack parameters */
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
@@ -532,13 +532,6 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
 #define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
-/* block-ack parameters */
-#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
-#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
-#define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
-#define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
-
 /*
  * A-PMDU buffer sizes
  * According to IEEE802.11n spec size varies from 8K to 64K (in powers of 2)



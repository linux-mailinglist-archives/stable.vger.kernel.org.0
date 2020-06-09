Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48B91F4591
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgFISRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730956AbgFIRuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C66520774;
        Tue,  9 Jun 2020 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725020;
        bh=A8/2DMt2DlV627jgZn/LmE7bO5UtcIiyT4fVmDE37ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/2fPriWkUmBT90g8kIyIg8RddpD2pb8RUbnJp3IQ5L6MkE6i0V9wNEq2n236VgTC
         7fk0F9bpSVVhRq48mMbvDY5wty449M6nqp9mPwIcpY3DHw5bMrDpVKLbZcm843KC6n
         ANT/tDSjgtI7geG2i838FWBabG87Dzr6QBZ6UvAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Terjan <pterjan@google.com>
Subject: [PATCH 4.14 37/46] staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK
Date:   Tue,  9 Jun 2020 19:44:53 +0200
Message-Id: <20200609174030.070675162@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
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
@@ -468,7 +468,7 @@ static inline unsigned char *get_hdr_bss
 /* block-ack parameters */
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
@@ -562,13 +562,6 @@ struct ieee80211_ht_addt_info {
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



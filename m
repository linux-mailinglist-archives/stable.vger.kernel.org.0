Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7A71F43E1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgFIR6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733271AbgFIRzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:55:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A24720812;
        Tue,  9 Jun 2020 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725336;
        bh=miLTQdPwzuk9lQFiqP5cxP8nhx922KpR3g6Sz11QT1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhF5im26SG2cedIWsqYpMYE3O/+PQTPgJEj4waEu154iGl3SL4oAVwR4DLOy/tQoK
         2GnaZd15+xmnGJ6HRN5zTKxCj9lJGyRWflRnRx0NcT+P/0k0gQWi4FI7dwi0gkAsLK
         AGWAB0bcxNpKbJBwBjxsgOkfiaV4OLjCEi6Al2bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Terjan <pterjan@google.com>
Subject: [PATCH 5.7 16/24] staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK
Date:   Tue,  9 Jun 2020 19:45:47 +0200
Message-Id: <20200609174150.650165331@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174149.255223112@linuxfoundation.org>
References: <20200609174149.255223112@linuxfoundation.org>
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



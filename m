Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E72CF804E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKKTky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:40:54 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33259 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfKKTky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 14:40:54 -0500
Received: by mail-ot1-f65.google.com with SMTP id u13so12256572ote.0;
        Mon, 11 Nov 2019 11:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=shU2J5MGutpyjMyh4O9vSnabrYGZWqe8emFU2lBG2tY=;
        b=qGvPuxp+AbhEIClSiR7Hk/2ZD+eADq9JG9vzFCFee7SBpgBzff72h57eqt9OGKcIEx
         l/6zzPgwUUB/lZ2xCyfJM6762rcvLftUQ8NGJ50n8PDus6xtArQsIfD7gOAoUYR5rStR
         zaIvetf0Gjklj0DmgzwHs6x+kc3QqIeh6YI8ixSVBfxKqgqspYzbcZm1be8/ZX+pu0c8
         x45+3XT/vzke9SpN98UI9RUDvSlkOqWJpLVOqFRLZfspIeqQRrMxV0BNwee8bl2/ubBE
         e8TByg2So1nItdBKxRvGDn3cfEevFXQ1amdwC+3L3v5F4Z+7Av5ljU9rAL2iQmwP0nB+
         JMUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=shU2J5MGutpyjMyh4O9vSnabrYGZWqe8emFU2lBG2tY=;
        b=ZPA0NXV52XlXnwjjiZa0jpRf2iQI8g1Cu1xg/BtGqF6j2n5vuO0R9eaZs4OXRCMhkV
         YcSTCjMV4vR3jEcAYuDZa44PN9MSUaHkSZ3XeAXvhGCjiNwukJsth1/xP/cT1HIATKxf
         d5S60+iL8uSbJAIa+EeM/C6Gu1jLSIUxO3JHCnci20jOe81Cydnmflg2qP5jzYBA3Nqe
         wS99AJk5Vr6kmfFJ4oc9t7JCJX+hMLpBSESizyKC52uEi4zjcnUqx8zN8lekHYbCl/iQ
         +R91K9A5KfzO3mp3xRxxYH+4Ttqv945VcuKLhMBoSEu9qxZwteZYm2oZD3fYNPEV6QbZ
         Wb+w==
X-Gm-Message-State: APjAAAXMZduXfUMnzoBKTLH+aKlmagaaDS4Ncz8eniIoIp4WrgQJ9dS7
        621W9nfRlYIa3fQFAkCF9C8=
X-Google-Smtp-Source: APXvYqxE8yv9qhu6ExkLev1Cpqd++Uk8HVcT8as4CAu4sQytl/ajPfiAFw8tFJ08kji8AZUIbYL80w==
X-Received: by 2002:a9d:4a9c:: with SMTP id i28mr21730902otf.169.1573501253637;
        Mon, 11 Nov 2019 11:40:53 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o22sm5031002otk.47.2019.11.11.11.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 11:40:53 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
Date:   Mon, 11 Nov 2019 13:40:44 -0600
Message-Id: <20191111194046.26908-2-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111194046.26908-1-Larry.Finger@lwfinger.net>
References: <20191111194046.26908-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for
new drivers"), a callback to get the RX buffer address was added to
the PCI driver. Unfortunately, driver rtl8192de was not modified
appropriately and the code runs into a WARN_ONCE() call. The use
of an incorrect array is also fixed.

Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
Cc: Stable <stable@vger.kernel.org> # 3.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index 2494e1f118f8..b4561923a70a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -804,13 +804,15 @@ u64 rtl92de_get_desc(struct ieee80211_hw *hw,
 			break;
 		}
 	} else {
-		struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
 		switch (desc_name) {
 		case HW_DESC_OWN:
-			ret = GET_RX_DESC_OWN(pdesc);
+			ret = GET_RX_DESC_OWN(p_desc);
 			break;
 		case HW_DESC_RXPKT_LEN:
-			ret = GET_RX_DESC_PKT_LEN(pdesc);
+			ret = GET_RX_DESC_PKT_LEN(p_desc);
+			break;
+		case HW_DESC_RXBUFF_ADDR:
+			ret = GET_RX_DESC_BUFF_ADDR(p_desc);
 			break;
 		default:
 			WARN_ONCE(true, "rtl8192de: ERR rxdesc :%d not processed\n",
-- 
2.23.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C5110EB7C
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 15:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfLBOXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 09:23:30 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46641 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbfLBOXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 09:23:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so41045117wrl.13
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 06:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7QBBODz38af9BAAmLqiAF2JyTB9aVxEgaGJzaKdt6kc=;
        b=jK970Haq5+eP6U8jVgCizD6e94pTSRW5a6cNhsMhL/CAFbMIpQeVyUh3wiD53o6/rj
         PTA44gZLrZQHJtFgcMlLw82fYziEgKUdP6YfACBGsDefhVGHY3xJaE7h7zPVsQjM3Y+B
         3QIkBqerL8ysFQ224NneXBBjinpHRk+6JLJX4ZdSqQbukiovLlqSqEL9onPNkKkiLaHs
         sow1MzNAP63hofaPW9KFghTTh119/5q6fCPVVxlkDiRG3XjwZu5G0hOSUr6ychClfThI
         XkPT8flmahx0ZBeCFGC+v5URmAKF+cLdPql1gcsPcUpAUkdfHmIXJn7MAqQg8g98RxfM
         ghKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7QBBODz38af9BAAmLqiAF2JyTB9aVxEgaGJzaKdt6kc=;
        b=WyChBtBg8NyhYZqzCQjs10VpCRBxsmkPdfk1ifVSShtKNcxkP2NQLiryDtMy0oM2hx
         c0OswxR0BFf+hkO1i3YFGSeaPrL2hhQ8UEDSW2FaHDN0tv/CBwc/zDGPcHJy6lOK+5zB
         PmzjWnB1TMrzQ+DFQe0kg8Ue934rsGcz/iEZtB4Su6FlZzTCu2wK6JNRS3GEti63fVYs
         cIcQHrK8E2CLQRDpb/y4aH4N7yoVqpTIEqZRMt8ueGpOpLYEJLKE+WAbAxTNc8l0VNLi
         /yTFBEXxIjtUL3gGHps7vpz0FQJU+kxhzzLxb5Vpmm0q0K4nBWuqoVUNI9S5xab1RsG2
         KVVg==
X-Gm-Message-State: APjAAAV0h+j+BAnmBciEEkNFgny8161vO/4hYHtJzHBpv+7YY9KQESKJ
        ZDIoLTEsrLilb8bjwGUkdylBbhDI
X-Google-Smtp-Source: APXvYqxP1UfBbJ4WMuesZ2VVZ47Si7thCLBf3RcAQ5048QdgFOvf2h58ds0jn5sky8XdGHUgpB/Xzg==
X-Received: by 2002:adf:fd87:: with SMTP id d7mr533010wrr.226.1575296608500;
        Mon, 02 Dec 2019 06:23:28 -0800 (PST)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id s19sm19691571wmc.4.2019.12.02.06.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Dec 2019 06:23:27 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     stable@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure: Fix stability issue with Macchiatobin
Date:   Mon,  2 Dec 2019 15:20:15 +0100
Message-Id: <1575296415-29255-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b8c5d882c833 upstream

This patch should have made it into kernel version 5.4 as it fixes some
major stability issue running on Marvell A7K/A8K, for which it was 
originally developed, which was introduced by an earlier patch.
It is identical to the upstream patch, save for some whitespace fixes
that were removed to not violate the "no trivial fixes" rule.
Below follows the original patch text as submitted for kernel 5.5.

This patch corrects an error in the Transform Record Cache initialization
code that was causing intermittent stability problems on the Macchiatobin
board.

Unfortunately, due to HW platform specifics, the problem could not happen
on the main development platform, being the VCU118 Xilinx development
board. And since it was a problem with hash table access, it was very
dependent on the actual physical context record DMA buffers being used,
i.e. with some (bad) luck it could seemingly work quit stable for a while.

Fixes: 465527bcaebc ("crypto: inside-secure - Probe transform record cache RAM sizes")
Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4ab1bde..40adf8c 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -223,7 +223,7 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	/* Step #4: determine current size of hash table in dwords */
 	cs_ht_wc = 16<<cs_ht_sz; /* dwords, not admin words */
 	/* Step #5: add back excess words and see if we can fit more records */
-	cs_rc_max = min_t(uint, cs_rc_abs_max, asize - (cs_ht_wc >> 4));
+	cs_rc_max = min_t(uint, cs_rc_abs_max, asize - (cs_ht_wc >> 2));
 
 	/* Clear the cache RAMs */
 	eip197_trc_cache_clear(priv, cs_rc_max, cs_ht_wc);
-- 
1.8.3.1


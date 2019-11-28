Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5901310CD12
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfK1QuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:50:07 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41733 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfK1QuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id l26so2991841pgb.8
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jEs6QE+VfGFRlxMX16dTWWCBFFIHacBUeuklTX9eehk=;
        b=KXOTFhYW31M6DowFuVSnZZCtoVs9n/0m0NvfFFZd/SJgu5toTz3abL8mMkd78Ce33g
         jS4H5Xas4NpISrNogQilOVf2XtLcQFgi241JW6pdGzS9mAe1TpFBHF4dIwqlW2YBDkHi
         LcwZVULYkgOFnRsBSM5zGwnGB+uoPXjd8zsDy9LydhztAqwlpMUZBUjtnbLpM9/eZcPm
         B55+nvIbQgZJi8R9mKUwalRDzBnjtNK9Mow4lfWl94dyekaSG6aLvasftGqFRfTwvjev
         4w2+wCx0fHYT80fgo1kSm6hUHDAFw5HJI/3UXjlz4QSPSaylm0almF6B7yg9RP1vvNF5
         FDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jEs6QE+VfGFRlxMX16dTWWCBFFIHacBUeuklTX9eehk=;
        b=ZYOu3iT/MmssupDzJ4iVjRxFWsEU9OK3xMPBYFxwYiqMCEJEYYaiGw+J1gWFH0Hxkv
         BbIYByDM5l22HW+TDMrooVcLaX6kUUZeqtdBAvSxglT/a8JwHZ9NU4oop6lCTfQfI34L
         CE8/homtXtouTVsBb60AXK2H9rzVTp0Qu1/fr0ndQgYHkE+j0BP8vbV53wBkw8rykxEg
         NhUA4YO/cmH5GZh89w8mi0YDEK+t4nMpqWzA8O/fVAbkiXfQrN6IwdxGFi2Y6E+BIn06
         vIYQR959esDejYiCSljKeL+D9a8lyJDUSXzgnHAQ8e3kpZKTdgEsEL0HfNjd/8HAaF7W
         apAA==
X-Gm-Message-State: APjAAAU+uaPjz3iUrr4H9JF5eKaOt7qPN7aPQsmI2eMWp22RLLGyokgo
        e04s5+IKrT4XCTa5bkWyPhVqzTqXkRU=
X-Google-Smtp-Source: APXvYqx8Qk2Of+BXuSVm+sEuntEca3roAUMLg6UeXFFjMVrolEG4T3O608o00roYtbf9Fj0Zeo7MNA==
X-Received: by 2002:a63:e03:: with SMTP id d3mr6794337pgl.395.1574959806302;
        Thu, 28 Nov 2019 08:50:06 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:05 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 02/17] crypto: stm31/hash - Fix hmac issue more than 256 bytes
Date:   Thu, 28 Nov 2019 09:49:47 -0700
Message-Id: <20191128165002.6234-3-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Debieve <lionel.debieve@st.com>

commit 0acabecebc912b3ba06289e4ef40476acc499a37 upstream

Correct condition for the second hmac loop. Key must be only
set in the first loop. Initial condition was wrong,
HMAC_KEY flag was not properly checked.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/crypto/stm32/stm32-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 590d7352837e..641b11077f47 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -365,7 +365,7 @@ static int stm32_hash_xmit_cpu(struct stm32_hash_dev *hdev,
 		return -ETIMEDOUT;
 
 	if ((hdev->flags & HASH_FLAGS_HMAC) &&
-	    (hdev->flags & ~HASH_FLAGS_HMAC_KEY)) {
+	    (!(hdev->flags & HASH_FLAGS_HMAC_KEY))) {
 		hdev->flags |= HASH_FLAGS_HMAC_KEY;
 		stm32_hash_write_key(hdev);
 		if (stm32_hash_wait_busy(hdev))
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198C02DA109
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 21:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502957AbgLNUE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 15:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502992AbgLNUEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 15:04:25 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ED3C0611C5
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:23 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id z12so6957924pjn.1
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=id/Q5ao6THistubUC4V3inH2fBZpq87NgTKXp27iujY=;
        b=Ah7IwggI4z9FHB9YbqLDpj0nCp9uUjVuQkXErTXTYqynlfQmuvYA/CfhxB8gw6N9BC
         HG67Iq68JFApt8mGenms10a8fNTb5JsuoWXEtogvyqPdZP7FmFkB9ljRwdL4NRpuwzjG
         M0Bpfdrwg3x31h+drs15tcIqwfjErlthCxte5M7XGlRzs02sCnVvcLOYKhedn8YGB0vE
         KzlYatfyyvZVCZ2VOypXNWPdCmSDNoTSDYLhI4cHDorUzuAOrqbFJmx8qb3mUHU+ghLD
         TmzGTf1nHnES3uxiI8qn3B6pkHyELmsBOf6IK5Dn/JaVIaOYWJgIKwlIQRx/g61ecqAx
         ME3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=id/Q5ao6THistubUC4V3inH2fBZpq87NgTKXp27iujY=;
        b=b3C9ZWaw9yPjKu/DCGrSSblJ6Yc9zrKldIXMZ1QWtsI+nqkCRcslXeV0hugas+cp2+
         uToMODb3va/udDdoagzyqAxR7SuUdOM03T4BKOv17dqAPWQ8fLYipyschsICPv1t80Go
         di6woOPSt6Tc7goJo9miolvZoU93tta414zCyvlsq4/4O0DyCHIvolX4MzbGGfqStK3g
         WzqK52ZR1z9HkcQuSmz1wsepl1JiuzVlheBtlISQNFbiy7Jtph0sYgVapzWPgXyFYMzl
         gbjq+exfXuKYlmXHGpUj82/DBwkiov5j2QcfQyBcl9HswElPJnsT2ijBSqZJ/qcjHkWc
         aUrA==
X-Gm-Message-State: AOAM532H6m5wZkynWWUNbegydFe3B7banr0uuNrYDhS1YrGm90LSVgfY
        bs/h0nhAn1X+Ll2F7FNLbOjxeg==
X-Google-Smtp-Source: ABdhPJwqXwB839aTHuuRfA5fv8f6XIPiV7G7EQ2SPaHJbY5OdwVed//y4tVkvbHpfUDXRFHMnDxotg==
X-Received: by 2002:a17:90b:1294:: with SMTP id fw20mr26654548pjb.187.1607976203320;
        Mon, 14 Dec 2020 12:03:23 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:22 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v4 5/8] crypto: sun4i-ss: initialize need_fallback
Date:   Mon, 14 Dec 2020 20:02:29 +0000
Message-Id: <20201214200232.17357-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The need_fallback is never initialized and seem to be always true at runtime.
So all hardware operations are always bypassed.

Fixes: 0ae1f46c55f87 ("crypto: sun4i-ss - fallback when length is not multiple of blocksize")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index e097f4c3e68f..5759fa79f293 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -179,7 +179,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
-	bool need_fallback;
+	bool need_fallback = false;
 
 	if (!areq->cryptlen)
 		return 0;
-- 
2.26.2


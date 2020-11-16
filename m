Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF80A2B4537
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 14:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgKPNy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 08:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbgKPNy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 08:54:26 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1795DC0613D2
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 05:54:25 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id h16so9219798pgb.7
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 05:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+A359lF42tZa73dPiOWZxYbdDHUjaoA4SP1/TVC6kqw=;
        b=uhrUcNEKOBNJHazYbkL0/WF/jWRl6a4lPtR5yUmS/9ZGu9nIeJeSBAYW7AixeYsajJ
         MdTINMXr78JkR3QHYkXVFW6bU/3iPm5GOEoxaIBRV34IVfhMC3DOPR2d5Ij1wyOFHxw7
         SSIcAwr0NphdpCzUpdzlLNuimTIpEcRFEmh/FA5qPhCTPu4xUNW7VYhvfJykv/9jV4Pa
         +y2GKPkUqDCS/I2AYrEUDrv6LpFFe/iBpLAPRTF2wTaUP0kYvhfFKCrAoMR3WucUC5UJ
         unoa8iDF+ShqImnC7uASDcgwnvpRL3fhpyjSjNysN6bM6c12EhXhdAGpHyPP5wWYRlFT
         OoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+A359lF42tZa73dPiOWZxYbdDHUjaoA4SP1/TVC6kqw=;
        b=ObAF7lSQ2GTd1ZOdvES/JlWiQesvVkh2tS9KNIUI+okpK5MC7g3EhsAmVavnXn1Xwc
         LWF5+rzeEJ+zySCP2fOYA2uZzvHwYHlA6TOtxHv+CX3+UIma3f+SoENBSb2HpEFy9e/Y
         PcDaRFzCaMIe8CBcXZmUE3dHEoGKOPYSbVSotDHGQT6EFn4G1/vgSSBtn3HDo0K6r9wf
         YkVKO1naWlsiJqARFuHOktDHOqz3VgQoKvnvPcDYkQ3vA14pZeqLliav5edJJPMEChEU
         nrP3H2ffoZgR11RZtDzaMWehw5f9bZx0n7wYQobY/j3iLE2qllrOlszuddWRn5L2D5yL
         psug==
X-Gm-Message-State: AOAM531O2tgJPLSfe7OXj0oiED3Tc8F4xeC7OGltz6WjlrlnG1m7V72j
        HD3Vn9humlySG54mv+d1TV6TpA==
X-Google-Smtp-Source: ABdhPJx7zPBrpHujwVU2oFB8zrUqJuJFYi0hZX7sx2UK8bvDlOvTG38tK788gR3212Yjzqoa2hpXLg==
X-Received: by 2002:a63:4759:: with SMTP id w25mr12628446pgk.414.1605534864664;
        Mon, 16 Nov 2020 05:54:24 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:24 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/7] crypto: sun4i-ss: checking sg length is not sufficient
Date:   Mon, 16 Nov 2020 13:53:40 +0000
Message-Id: <20201116135345.11834-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201116135345.11834-1-clabbe@baylibre.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The optimized cipher function need length multiple of 4 bytes.
But it get sometimes odd length.
This is due to SG data could be stored with an offset.

So the fix is to check also if the offset is aligned with 4 bytes.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 19f1aa577ed4..4dd736ee5a4d 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -186,12 +186,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if (in_sg->length % 4)
+		if (in_sg->length % 4 || !IS_ALIGNED(in_sg->offset, sizeof(u32)))
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if (out_sg->length % 4)
+		if (out_sg->length % 4 || !IS_ALIGNED(out_sg->offset, sizeof(u32)))
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}
-- 
2.26.2


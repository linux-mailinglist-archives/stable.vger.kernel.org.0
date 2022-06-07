Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B355D541502
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359389AbiFGUYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359485AbiFGUW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:22:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA101D503A;
        Tue,  7 Jun 2022 11:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B269761295;
        Tue,  7 Jun 2022 18:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFF0C385A2;
        Tue,  7 Jun 2022 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626721;
        bh=BVS30Ri3Nw0GyaQoY80jOTh/+gVIBSzugnPkzKzAh24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkmpbNJUXtdCkSiJZjyR5PhL+vXmt4y5tBByPUvULo6fwCrMiW4z7BdM6U2t6QJ6U
         fhAljiDMbxc1w49qMtly3OSaPrzNWeT6iY/t2GNZvzfHf3CBV2Wo3SjeVEI8IWs24W
         cLBUuabDII80rm3nbqmH4rqbWKj/C2h2wuhhx2dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 481/772] hwrng: cn10k - Optimize cn10k_rng_read()
Date:   Tue,  7 Jun 2022 19:01:13 +0200
Message-Id: <20220607165003.164126671@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

[ Upstream commit 753d6770879894de10d74b437ab99ea380f1cad7 ]

This function assumes that sizeof(void) is 1 and arithmetic works for
void pointers. This is a GNU C extention and may not work with other
compilers. Change this by using an u8 pointer.

Also move cn10k_read_trng() out of a loop thus saving some cycles.

Fixes: 38e9791a0209 ("hwrng: cn10k - Add random number generator support")
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/cn10k-rng.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/cn10k-rng.c b/drivers/char/hw_random/cn10k-rng.c
index 35001c63648b..dd226630b67d 100644
--- a/drivers/char/hw_random/cn10k-rng.c
+++ b/drivers/char/hw_random/cn10k-rng.c
@@ -90,6 +90,7 @@ static int cn10k_rng_read(struct hwrng *hwrng, void *data,
 {
 	struct cn10k_rng *rng = (struct cn10k_rng *)hwrng->priv;
 	unsigned int size;
+	u8 *pos = data;
 	int err = 0;
 	u64 value;
 
@@ -102,17 +103,20 @@ static int cn10k_rng_read(struct hwrng *hwrng, void *data,
 	while (size >= 8) {
 		cn10k_read_trng(rng, &value);
 
-		*((u64 *)data) = (u64)value;
+		*((u64 *)pos) = value;
 		size -= 8;
-		data += 8;
+		pos += 8;
 	}
 
-	while (size > 0) {
+	if (size > 0) {
 		cn10k_read_trng(rng, &value);
 
-		*((u8 *)data) = (u8)value;
-		size--;
-		data++;
+		while (size > 0) {
+			*pos = (u8)value;
+			value >>= 8;
+			size--;
+			pos++;
+		}
 	}
 
 	return max - size;
-- 
2.35.1




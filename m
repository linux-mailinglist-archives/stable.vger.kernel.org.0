Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4745B59DE0A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbiHWLVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357614AbiHWLUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:20:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E588C018;
        Tue, 23 Aug 2022 02:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 297F36122D;
        Tue, 23 Aug 2022 09:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316C6C433C1;
        Tue, 23 Aug 2022 09:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246559;
        bh=/DeAmAkZLsLUJ1rMm66Za+XJ3MYFeZHDpaX7It3ToiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPsy7KseuqVFp9lSZsvUsFzgdWmZ9iSaQc7TxDpJ/l6XPE17f8IMPTOItScEkNUgy
         baXka1ITKuUuZFRreQEBklwIw4DHSB5ehOtSCD+narLf6OdJHS5N38xPE2IEe2txRF
         a3MeuoO85H+KuWp7EQdcp0wGKm1RF9LK11rcIic0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/389] crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of
Date:   Tue, 23 Aug 2022 10:23:46 +0200
Message-Id: <20220823080121.786293719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit fa4d57b85786ec0e16565c75a51c208834b0c24d ]

Without MODULE_DEVICE_TABLE, crypto_safexcel.ko module is not automatically
loaded on platforms where inside-secure crypto HW is specified in device
tree (e.g. Armada 3720). So add missing MODULE_DEVICE_TABLE for of.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4d9d97c59ee3..9534f52210af 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1658,6 +1658,8 @@ static const struct of_device_id safexcel_of_match_table[] = {
 	{},
 };
 
+MODULE_DEVICE_TABLE(of, safexcel_of_match_table);
+
 static struct platform_driver  crypto_safexcel = {
 	.probe		= safexcel_probe,
 	.remove		= safexcel_remove,
-- 
2.35.1




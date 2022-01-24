Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A5D49A02B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842271AbiAXXB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838090AbiAXWpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:45:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C551C0550F9;
        Mon, 24 Jan 2022 13:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23295B81142;
        Mon, 24 Jan 2022 21:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAE5C340E5;
        Mon, 24 Jan 2022 21:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058382;
        bh=1Xu0fY9+VgGKTdVcFCdBa37F4Om7SvBXrvrP+wodbko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOK//x8C42s7VOPLUhvzGQ/irofn7dcla5NAQwdovIm/9jzC4hZnvqnOK05uXOMD/
         jRWzUsvXyAtIGuPJA67SuLES7uT8kX9wwJsDRlok0mIpY8sc0YPVyM/66l+wSC7ORT
         ArPlrhgKlwpT6cF5yp6sa66dvr4UZUol9FlLwNuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0272/1039] crypto: stm32/cryp - fix xts and race condition in crypto_engine requests
Date:   Mon, 24 Jan 2022 19:34:21 +0100
Message-Id: <20220124184134.442878223@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>

[ Upstream commit d703c7a994ee34b7fa89baf21631fca0aa9f17fc ]

Don't erase key:
If key is erased before the crypto_finalize_.*_request() call, some
pending process will run with a key={ 0 }.
Moreover if the key is reset at end of request, it breaks xts chaining
mode, as for last xts block (in case input len is not a multiple of
block) a new AES request is started without calling again set_key().

Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto module")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index d13b262b36252..e2bcc4f98b0ae 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -674,8 +674,6 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 	else
 		crypto_finalize_skcipher_request(cryp->engine, cryp->req,
 						   err);
-
-	memset(cryp->ctx->key, 0, cryp->ctx->keylen);
 }
 
 static int stm32_cryp_cpu_start(struct stm32_cryp *cryp)
-- 
2.34.1




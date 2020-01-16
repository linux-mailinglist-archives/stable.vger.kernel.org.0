Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D9213F57D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389111AbgAPRHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389109AbgAPRHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F37C320663;
        Thu, 16 Jan 2020 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194432;
        bh=BsDrq1g+bMq/8XFhrxOFkZEa6EtIzrjo52mrJdI9crs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WC2kkTov1f6/yyiNxGXGf4WdTtKn80kg4A0rJncEaX6DOrZyZyFrUSRbmfcBzrGrT
         v+J0JSLG+Dd0mbFb2IWXPRcGzh9HRiUjEfWmKzk9RF752DF2uQ3Zz9L42JTqGqShtb
         bKLFM3rw/rjxS8HiJDkuEP0vYA++ycj6IAGXhy/0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 348/671] crypto: caam - fix caam_dump_sg that iterates through scatterlist
Date:   Thu, 16 Jan 2020 11:59:46 -0500
Message-Id: <20200116170509.12787-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

[ Upstream commit 8c65d35435e8cbfdf953cafe5ebe3648ee9276a2 ]

Fix caam_dump_sg by correctly determining the next scatterlist
entry in the list.

Fixes: 5ecf8ef9103c ("crypto: caam - fix sg dump")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 8da88beb1abb..832ba2afdcd5 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -22,7 +22,7 @@ void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
 	size_t len;
 	void *buf;
 
-	for (it = sg; it && tlen > 0 ; it = sg_next(sg)) {
+	for (it = sg; it && tlen > 0 ; it = sg_next(it)) {
 		/*
 		 * make sure the scatterlist's page
 		 * has a valid virtual memory mapping
-- 
2.20.1


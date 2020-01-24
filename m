Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEFF147D34
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbgAXJ57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgAXJ55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:57:57 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1220920709;
        Fri, 24 Jan 2020 09:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859876;
        bh=Lx/v8lP1XRAdlXS6cjveRkk21Low/MXwVw+Vi6W/52E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEmj1LkfeFNTXEIlO+3RF1lJldoBZyJA8QqpEFYSdHcrEByA5aNp6e/aiFhP0Z8Sz
         eNj+JGQc+G31a69TG529DcUZIAEGOwWy5oAORmRrHty6//e4KDgRXy0f/4uRVqyfI8
         k2QGflIvGrH8JyI3eY8UmvcSyaqB3VkeM5VbRnNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iuliana Prodan <iuliana.prodan@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 202/343] crypto: caam - fix caam_dump_sg that iterates through scatterlist
Date:   Fri, 24 Jan 2020 10:30:20 +0100
Message-Id: <20200124092946.513198433@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8da88beb1abbe..832ba2afdcd57 100644
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




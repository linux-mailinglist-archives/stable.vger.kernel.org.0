Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A023229B6BD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797332AbgJ0PYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797601AbgJ0PYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D4E2225E;
        Tue, 27 Oct 2020 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812271;
        bh=6z1GlKEHSp5e5ACyIwqWZepobB9Kxm65ZQa/XjTzVns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFhjwQ4/cMYc5g7YF03tnpINHkTxQQr+5vmJNQ9H46l10u/GvLRhBJdRRXvbvdmAH
         AjAv/FykK4ZBSvbwt/WqSynVvM4Od+4+XS3pR03i4yQYEh5oI6T8Sngdedn9W0oyhr
         wyK1CWFKgCs7X4aCyqpqy1jH1nVC9dKZXpBkD0OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 151/757] crypto: sa2ul - Fix pm_runtime_get_sync() error checking
Date:   Tue, 27 Oct 2020 14:46:41 +0100
Message-Id: <20201027135457.692771286@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2baace5feb86c6916221911f391f11fcd8e1a259 ]

The pm_runtime_get_sync() function returns either 0 or 1 on success but
this code treats a return of 1 as a failure.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index ff8bbdb4d235d..039579b7cc818 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2331,7 +2331,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(&pdev->dev, "%s: failed to get sync: %d\n", __func__,
 			ret);
 		return ret;
-- 
2.25.1




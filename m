Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4D0B1EFE
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388983AbfIMNOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389568AbfIMNOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:43 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E26214AF;
        Fri, 13 Sep 2019 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380483;
        bh=vbbHDpDslA+4zmqXCGAUncDj5cH7yhA6XMoT7JsesgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNZcfPT3j99TYwgttdJkyemLW1XxZLyWzoFdlecn3BsxsNShwhFemedHl2Z8y/JAE
         BS37CE5No+arx0XiC1IyqJU0CqaygcZpX30oeaMobX89j6iM8JCxFL7MRdmMmNPxhf
         MnvLEdUBkJ83fkGwchzm4GmVNYsQ/N92EUPJMwXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, stable@kernel.org
Subject: [PATCH 4.19 080/190] crypto: ccree - add missing inline qualifier
Date:   Fri, 13 Sep 2019 14:05:35 +0100
Message-Id: <20190913130605.895137622@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f1071c3e2473ae19a7f5d892a187c4cab1a61f2e ]

Commit 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
was missing a "inline" qualifier for stub function used when CONFIG_PM
is not set causing a build warning.

Fixes: 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
Cc: stable@kernel.org # v4.20
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_pm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index f626243570209..907a6db4d6c03 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -30,7 +30,7 @@ static inline int cc_pm_init(struct cc_drvdata *drvdata)
 	return 0;
 }
 
-static void cc_pm_go(struct cc_drvdata *drvdata) {}
+static inline void cc_pm_go(struct cc_drvdata *drvdata) {}
 
 static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
 
-- 
2.20.1




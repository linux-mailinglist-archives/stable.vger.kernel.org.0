Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EB329C143
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818818AbgJ0RXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900801AbgJ0OyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C4420679;
        Tue, 27 Oct 2020 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810465;
        bh=9wKS+bOD5X6wF0z12+Q03h5eBqJKEhOTM9h6X8XjQEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s59HpwC+lCfOQY5Lbeuq3S613qbIhu0fdM8J1JohyN3UhFfxcpG78nfc+7bT0Hrrn
         pFOFECVgzl9JpczYk/rJ4mrT6Lt2LeapPoo74VkNesIe2VqN99PkzuSgSNqrhq1jWz
         v6RbZKMUtaplYbR8e3bXAlupmQAPVWYDitwV0S4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 108/633] crypto: ccree - fix runtime PM imbalance on error
Date:   Tue, 27 Oct 2020 14:47:31 +0100
Message-Id: <20201027135527.748297461@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dinghao.liu@zju.edu.cn <dinghao.liu@zju.edu.cn>

[ Upstream commit b7b57a5643c2ae45afe6aa5e73363b553cacd14b ]

pm_runtime_get_sync() increments the runtime PM usage counter
even when it returns an error code. However, users of cc_pm_get(),
a direct wrapper of pm_runtime_get_sync(), assume that PM usage
counter will not change on error. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Fixes: 8c7849a30255c ("crypto: ccree - simplify Runtime PM handling")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_pm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index d39e1664fc7ed..3c65bf070c908 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -65,8 +65,12 @@ const struct dev_pm_ops ccree_pm = {
 int cc_pm_get(struct device *dev)
 {
 	int rc = pm_runtime_get_sync(dev);
+	if (rc < 0) {
+		pm_runtime_put_noidle(dev);
+		return rc;
+	}
 
-	return (rc == 1 ? 0 : rc);
+	return 0;
 }
 
 void cc_pm_put_suspend(struct device *dev)
-- 
2.25.1




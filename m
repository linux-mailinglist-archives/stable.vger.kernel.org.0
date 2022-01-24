Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19885499B2B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574720AbiAXVuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51902 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457231AbiAXVlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A2EB80FA1;
        Mon, 24 Jan 2022 21:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71380C340E5;
        Mon, 24 Jan 2022 21:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060473;
        bh=vtrHks515mWWDB8VUuf53R07+1bjr6PyWKO1q/bUdAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJr4evXSCfy6Y7me42GLRX+GY/tXtGApTzG12Bo3Bu21oOzRlHbwyLMrQBFLWoY8O
         o0qNntsyeKgpiaXhhWLgDbc7A8ifSdgrkqJymvdEcAJqkUBC52noQtIOclfCGrFtzP
         HGHKbuLKG0RqBi8xCq4gKifBvDsVFw1UXJt6QeQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.16 0959/1039] crypto: octeontx2 - uninitialized variable in kvf_limits_store()
Date:   Mon, 24 Jan 2022 19:45:48 +0100
Message-Id: <20220124184157.530557206@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0ea275df84c389e910a3575a9233075118c173ee upstream.

If kstrtoint() fails then "lfs_num" is uninitialized and the warning
doesn't make any sense.  Just delete it.

Fixes: 8ec8015a3168 ("crypto: octeontx2 - add support to process the crypto request")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -494,12 +494,11 @@ static ssize_t kvf_limits_store(struct d
 {
 	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
 	int lfs_num;
+	int ret;
 
-	if (kstrtoint(buf, 0, &lfs_num)) {
-		dev_err(dev, "lfs count %d must be in range [1 - %d]\n",
-			lfs_num, num_online_cpus());
-		return -EINVAL;
-	}
+	ret = kstrtoint(buf, 0, &lfs_num);
+	if (ret)
+		return ret;
 	if (lfs_num < 1 || lfs_num > num_online_cpus()) {
 		dev_err(dev, "lfs count %d must be in range [1 - %d]\n",
 			lfs_num, num_online_cpus());



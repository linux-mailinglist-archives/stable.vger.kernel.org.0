Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9703B20631D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389522AbgFWURQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388879AbgFWURP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B9D021473;
        Tue, 23 Jun 2020 20:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943434;
        bh=sCCwyRLCF5aRjLCzuvDL6L0KBqXgD83So6ptPp8A6Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmSff8n79JDkZkAOAyeQnRqonNS2rXRjdsq4xOXyg1mj8n8NNt9j+ZnUHdT906o1k
         lT2HW3r2K/VxNtPZ1UI0tJGt9p6v/I5QTLN6QoneSVGW3dULukoPEERT9KSZwosfdu
         P7U7cHJYMfpj90u21gIj1pcLhr9mscKJYj4b8Prc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 390/477] crypto: marvell/octeontx - Fix a potential NULL dereference
Date:   Tue, 23 Jun 2020 21:56:27 +0200
Message-Id: <20200623195425.968545850@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1f5b07f5dd1748a6f9363fb1a76d599c74af8231 ]

Smatch reports that:

    drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:132 otx_cpt_aead_callback()
    warn: variable dereferenced before check 'cpt_info' (see line 121)

This function is called from process_pending_queue() as:

drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
   599                  /*
   600                   * Call callback after current pending entry has been
   601                   * processed, we don't do it if the callback pointer is
   602                   * invalid.
   603                   */
   604                  if (callback)
   605                          callback(res_code, areq, cpt_info);

It does appear to me that "cpt_info" can be NULL so this could lead to
a NULL dereference.

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 06202bcffb33f..a370c99ecf4c9 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -118,6 +118,9 @@ static void otx_cpt_aead_callback(int status, void *arg1, void *arg2)
 	struct otx_cpt_req_info *cpt_req;
 	struct pci_dev *pdev;
 
+	if (!cpt_info)
+		goto complete;
+
 	cpt_req = cpt_info->req;
 	if (!status) {
 		/*
@@ -129,10 +132,10 @@ static void otx_cpt_aead_callback(int status, void *arg1, void *arg2)
 		    !cpt_req->is_enc)
 			status = validate_hmac_cipher_null(cpt_req);
 	}
-	if (cpt_info) {
-		pdev = cpt_info->pdev;
-		do_request_cleanup(pdev, cpt_info);
-	}
+	pdev = cpt_info->pdev;
+	do_request_cleanup(pdev, cpt_info);
+
+complete:
 	if (areq)
 		areq->complete(areq, status);
 }
-- 
2.25.1




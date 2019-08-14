Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F968D8CB
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfHNRCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbfHNRCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:02:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB53214DA;
        Wed, 14 Aug 2019 17:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802150;
        bh=dGFnpAPC4qOQDGGUuBj/oVuYlq1NPYAWqx8iczDaSzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRh33WDT6lpFq0UQe4XAKZnJuZ9fVwXPgwSvGvUmlWJsmLT32Gy2WWegOOzJ5N3QD
         llXpbMYTaAq+Vds2zAZyFO3pQW2B6DNgUqFjC700oQRGgnRMDe6cF7SwcMjgauZLLK
         zMTJFNfk+HlDEr+h3qrFC1pvc9SGoxmKJ56wvIW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 014/144] crypto: ccp - Ignore tag length when decrypting GCM ciphertext
Date:   Wed, 14 Aug 2019 18:59:30 +0200
Message-Id: <20190814165800.523255835@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

commit e2664ecbb2f26225ac6646876f2899558ffb2604 upstream.

AES GCM input buffers for decryption contain AAD+CTEXT+TAG. Only
decrypt the ciphertext, and use the tag for comparison.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-ops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -782,8 +782,7 @@ static int ccp_run_aes_gcm_cmd(struct cc
 		while (src.sg_wa.bytes_left) {
 			ccp_prepare_data(&src, &dst, &op, AES_BLOCK_SIZE, true);
 			if (!src.sg_wa.bytes_left) {
-				unsigned int nbytes = aes->src_len
-						      % AES_BLOCK_SIZE;
+				unsigned int nbytes = ilen % AES_BLOCK_SIZE;
 
 				if (nbytes) {
 					op.eom = 1;



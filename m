Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4563F8DAEE
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbfHNRJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729904AbfHNRJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76395208C2;
        Wed, 14 Aug 2019 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802580;
        bh=hk+BW2g498HkjhgTTJ87szRPCj5bd3Unj3WwSKMmQNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIHElwq85bjTD7crVgekgmHBveEUoPLDxxiThVVvk0d5J1FITy8KNJtQ7SrQL18xM
         cmVksLNc4M9mlgWRyelwSfPCfHmblF/UpL95WE7ciSnWUNXssrd1g2e1BKga1zTOlm
         WYJWfnq/vMV32GL5xgXpgQ8VGJrtvF84hTfYPpH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 07/91] crypto: ccp - Ignore tag length when decrypting GCM ciphertext
Date:   Wed, 14 Aug 2019 19:00:30 +0200
Message-Id: <20190814165749.388040530@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
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
@@ -785,8 +785,7 @@ static int ccp_run_aes_gcm_cmd(struct cc
 		while (src.sg_wa.bytes_left) {
 			ccp_prepare_data(&src, &dst, &op, AES_BLOCK_SIZE, true);
 			if (!src.sg_wa.bytes_left) {
-				unsigned int nbytes = aes->src_len
-						      % AES_BLOCK_SIZE;
+				unsigned int nbytes = ilen % AES_BLOCK_SIZE;
 
 				if (nbytes) {
 					op.eom = 1;



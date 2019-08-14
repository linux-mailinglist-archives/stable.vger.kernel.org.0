Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33438DA8A
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbfHNRMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730745AbfHNRMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:12:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D422133F;
        Wed, 14 Aug 2019 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802751;
        bh=zCzGe+IkEgLhN0/wnekb8wcp+LhDVFGV4vS0wRfFjuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZoS9gy58UXUs7NqYdpXcX6UMRbnnMlSTf/edT24S5DqkjWaT9LqygLEfSXg0HwCB
         RnEpx5gE2O5yQ5XB/aPo1QopCetcALgpGc9U+3R/caRTWJnjM6Az0XHhoTkYAClvvQ
         NHTB7HCq0cCwQKKJO0M/gncKQJY6Cv8hLWrJD57Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 02/69] crypto: ccp - Fix oops by properly managing allocated structures
Date:   Wed, 14 Aug 2019 19:01:00 +0200
Message-Id: <20190814165745.308040528@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

commit 25e44338321af545ab34243a6081c3f0fc6107d0 upstream.

A plaintext or ciphertext length of 0 is allowed in AES, in which case
no encryption occurs. Ensure that we don't clean up data structures
that were never allocated.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -841,11 +841,11 @@ e_tag:
 	ccp_dm_free(&final_wa);
 
 e_dst:
-	if (aes->src_len && !in_place)
+	if (ilen > 0 && !in_place)
 		ccp_free_data(&dst, cmd_q);
 
 e_src:
-	if (aes->src_len)
+	if (ilen > 0)
 		ccp_free_data(&src, cmd_q);
 
 e_aad:



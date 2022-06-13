Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5215487D1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379194AbiFMNkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378062AbiFMNg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:36:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2860511174;
        Mon, 13 Jun 2022 04:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96FA5B80E59;
        Mon, 13 Jun 2022 11:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1028CC341C4;
        Mon, 13 Jun 2022 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119639;
        bh=ckANyrkMqg8JdbVw/F++oS0RepEeTBciE0XRiI5cdxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvwulq/iLXFgteF1mGofiDbezF64T92k8ckaYyGSHHMUry/DotZWmsDHQynxRgCdT
         dqjmd4q3Jw+vH2pWQu/uPJF1mKkNPvFp5WhJ8xcsvb8hNdqnr/pq7F4XfVHIxQW//U
         fGHLvixfKxPI1mqHn001AYTP+jlbG8S+O0oSTUII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 085/339] s390/crypto: fix scatterwalk_unmap() callers in AES-GCM
Date:   Mon, 13 Jun 2022 12:08:30 +0200
Message-Id: <20220613094929.095162493@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit bd52cd5e23f134019b23f0c389db0f9a436e4576 ]

The argument of scatterwalk_unmap() is supposed to be the void* that was
returned by the previous scatterwalk_map() call.
The s390 AES-GCM implementation was instead passing the pointer to the
struct scatter_walk.

This doesn't actually break anything because scatterwalk_unmap() only uses
its argument under CONFIG_HIGHMEM and ARCH_HAS_FLUSH_ON_KUNMAP.

Fixes: bf7fa038707c ("s390/crypto: add s390 platform specific aes gcm support.")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Harald Freudenberger <freude@linux.ibm.com>
Link: https://lore.kernel.org/r/20220517143047.3054498-1-jannh@google.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 54c7536f2482..1023e9d43d44 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -701,7 +701,7 @@ static inline void _gcm_sg_unmap_and_advance(struct gcm_sg_walk *gw,
 					     unsigned int nbytes)
 {
 	gw->walk_bytes_remain -= nbytes;
-	scatterwalk_unmap(&gw->walk);
+	scatterwalk_unmap(gw->walk_ptr);
 	scatterwalk_advance(&gw->walk, nbytes);
 	scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
 	gw->walk_ptr = NULL;
@@ -776,7 +776,7 @@ static int gcm_out_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 		goto out;
 	}
 
-	scatterwalk_unmap(&gw->walk);
+	scatterwalk_unmap(gw->walk_ptr);
 	gw->walk_ptr = NULL;
 
 	gw->ptr = gw->buf;
-- 
2.35.1




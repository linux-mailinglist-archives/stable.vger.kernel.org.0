Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE0C6AF372
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjCGTE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbjCGTEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:04:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8917D163D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AC8AB819CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2C0C433B4;
        Tue,  7 Mar 2023 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215012;
        bh=uw+d/MGSWEKxdDrXow9nFnZ5jR24MWhjnbMpVFslErw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpAFSHx8mj7ulS6nWesDXkxcTNgGJDq0VEjxlc+ueRgdjVp+NN7OAHkj//H8A4RCq
         csgjLYo8Kt5exGnj/oEgLowQtDtZLriBSHrwsOF2EwEW965BWY1TWYzNqaJE6h88Ee
         gXktcaSTBRnWB8jQsO4Pf9JyfIaX9XqbrWWMoHPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/567] lib/mpi: Fix buffer overrun when SG is too long
Date:   Tue,  7 Mar 2023 17:57:07 +0100
Message-Id: <20230307165909.838557136@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 7361d1bc307b926cbca214ab67b641123c2d6357 ]

The helper mpi_read_raw_from_sgl sets the number of entries in
the SG list according to nbytes.  However, if the last entry
in the SG list contains more data than nbytes, then it may overrun
the buffer because it only allocates enough memory for nbytes.

Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Reported-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/mpi/mpicoder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 39c4c67310946..3cb6bd148fa9e 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -504,7 +504,8 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 
 	while (sg_miter_next(&miter)) {
 		buff = miter.addr;
-		len = miter.length;
+		len = min_t(unsigned, miter.length, nbytes);
+		nbytes -= len;
 
 		for (x = 0; x < len; x++) {
 			a <<= 8;
-- 
2.39.2




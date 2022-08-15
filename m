Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBCF5950DC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiHPEsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiHPEqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFBAF0FB;
        Mon, 15 Aug 2022 13:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 721F560F60;
        Mon, 15 Aug 2022 20:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6350DC433D6;
        Mon, 15 Aug 2022 20:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596188;
        bh=XxnMfiIn8ZZYp5o420FI+PUdTBG8lET6FLr1Ryvn9bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvPMB9NYNFuxM3riZcDbq67DWN/Gfe99l/xsNJFVkrgriB5MYTSZiOlOwDuL5NBxE
         KaL/iTHCXIGeMOSUqGgl46IjI6OqXhKmgVWfYKLxWFy+mifGyphkwTb7DfJCRqK5N7
         mRN2z8Ekm6mU/D+EZ2ht3GfUmpZNnoX6ACN+QWiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rashmica Gupta <rashmica@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1000/1157] selftests/powerpc: Fix matrix multiply assist test
Date:   Mon, 15 Aug 2022 20:05:56 +0200
Message-Id: <20220815180519.784939569@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rashmica Gupta <rashmica@linux.ibm.com>

[ Upstream commit cd1e64935f79e31d666172c52c951ca97152b783 ]

The ISA states: "when ACC[i] contains defined data, the contents of VSRs
4×i to 4×i+3 are undefined until either a VSX Move From ACC instruction
is used to copy the contents of ACC[i] to VSRs 4×i to 4×i+3 or some other
instruction directly writes to one of these VSRs." We aren't doing this.

This test only works on Power10 because the hardware implementation
happens to map ACC0 to VSRs 0-3, but will fail on any other implementation
that doesn't do this. So add xxmfacc between writing to the accumulator
and accessing the VSRs.

Fixes: 3527e1ab9a79 ("selftests/powerpc: Add matrix multiply assist (MMA) test")
Signed-off-by: Rashmica Gupta <rashmica@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220617043935.428083-1-rashmica@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/math/mma.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/powerpc/math/mma.S b/tools/testing/selftests/powerpc/math/mma.S
index 8528c9849565..61cc88b1b26b 100644
--- a/tools/testing/selftests/powerpc/math/mma.S
+++ b/tools/testing/selftests/powerpc/math/mma.S
@@ -20,6 +20,9 @@ test_mma:
 	/* xvi16ger2s */
 	.long	0xec042958
 
+	/* Deprime the accumulator - xxmfacc 0 */
+	.long 0x7c000162
+
 	/* Store result in image passed in r5 */
 	stxvw4x	0,0,5
 	addi	5,5,16
-- 
2.35.1




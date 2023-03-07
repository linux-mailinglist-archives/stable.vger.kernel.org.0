Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FA96AE90A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjCGRUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjCGRUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5979F20C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:15:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4577614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8AEC433D2;
        Tue,  7 Mar 2023 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209328;
        bh=PYtdjopN2UJp+2eK/CBZp6xShk+9Njdh/NTg5rBPIco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkBiqVynGHhUdB8KlBkXFC/r+FfrBjB4QERj/MNhk4CuEqpIS/m4ZIR1+JH2RpwCW
         ADpx7g3825IPWj58g1XzyNshejVZzRIRrcwHwgVTWIcbAM1iIOQl0wrEocIxVw75Jm
         ZKSi/tCDkUR+OsZYlXYy72w5UfhXbNvM9pZMdplQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Nguyen <theflow@google.com>,
        Peter Gonda <pgonda@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0182/1001] crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2
Date:   Tue,  7 Mar 2023 17:49:14 +0100
Message-Id: <20230307170029.801106160@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

[ Upstream commit 91dfd98216d817ec5f1c55890bacb7b4fe9b068a ]

For SEV_GET_ID2, the user provided length does not have a specified
limitation because the length of the ID may change in the future.  The
kernel memory allocation, however, is implicitly limited to 4MB on x86 by
the page allocator, otherwise the kzalloc() will fail.

When this happens, it is best not to spam the kernel log with the warning.
Simply fail the allocation and return ENOMEM to the user.

Fixes: d6112ea0cb34 ("crypto: ccp - introduce SEV_GET_ID2 command")
Reported-by: Andy Nguyen <theflow@google.com>
Reported-by: Peter Gonda <pgonda@google.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 06fc7156c04f3..56998bc579d67 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -881,7 +881,14 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-		id_blob = kzalloc(input.length, GFP_KERNEL);
+		/*
+		 * The length of the ID shouldn't be assumed by software since
+		 * it may change in the future.  The allocation size is limited
+		 * to 1 << (PAGE_SHIFT + MAX_ORDER - 1) by the page allocator.
+		 * If the allocation fails, simply return ENOMEM rather than
+		 * warning in the kernel log.
+		 */
+		id_blob = kzalloc(input.length, GFP_KERNEL | __GFP_NOWARN);
 		if (!id_blob)
 			return -ENOMEM;
 
-- 
2.39.2




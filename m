Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2B4F2B0F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241195AbiDEKsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244560AbiDEJl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41996BBE09;
        Tue,  5 Apr 2022 02:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E036165C;
        Tue,  5 Apr 2022 09:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B584BC385A2;
        Tue,  5 Apr 2022 09:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150819;
        bh=nYwfEtMFbMAE6czzSoryuRv5ziTITHooF+OvNTqn/1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WflVkywDr0T1Fdut3pd1zeI0Vj6Km4nxDkvgZmW8+81ftWgQfgfeVSm7sY1+UjYOi
         RH9K3IBzBbor1YG0Fy08PULsmGzbvaSNfNOlyAZAwCCACP0G6jNJpVzFN6+9QCP/Ow
         nVJXcaKMsxHoTDdyiHVWGvKfGkyDvI8OD80qoEig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/913] crypto: ccp - Ensure psp_ret is always initd in __sev_platform_init_locked()
Date:   Tue,  5 Apr 2022 09:20:54 +0200
Message-Id: <20220405070345.613291615@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Peter Gonda <pgonda@google.com>

[ Upstream commit 1e1ec11d3ec3134e05d4710f4dee5f9bd05e828d ]

Initialize psp_ret inside of __sev_platform_init_locked() because there
are many failure paths with PSP initialization that do not set
__sev_do_cmd_locked().

Fixes: e423b9d75e77: ("crypto: ccp - Move SEV_INIT retry for corrupted data")

Signed-off-by: Peter Gonda <pgonda@google.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e2806ca3300a..5040726fc119 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -241,7 +241,7 @@ static int __sev_platform_init_locked(int *error)
 	struct psp_device *psp = psp_master;
 	struct sev_data_init data;
 	struct sev_device *sev;
-	int psp_ret, rc = 0;
+	int psp_ret = -1, rc = 0;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
-- 
2.34.1




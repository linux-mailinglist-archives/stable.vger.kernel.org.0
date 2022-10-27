Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC560FDBD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbiJ0Q6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236623AbiJ0Q6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C303B87A2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDDFE623EC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04A3C433D6;
        Thu, 27 Oct 2022 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889912;
        bh=Fv6MRAwPocitOzoAV8jtA4fycgON8VLDjkKAGjL3swg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRY7B/vc87VZZLyX3UTQneTSmI0o1+sigwU9KfkJCtv2KcKYCzyVJSDRVQirRGhb6
         UG1QRHqaHoAAMAGijoyfaxZ2agBCr36Cwq6sqPJyN7rTY3zmyGLDdt5+0CMRSV3Ngc
         yCf39MbETLypFh6Un95emcMGBuMe5NVbUNKqYGKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 45/94] net/smc: Fix an error code in smc_lgr_create()
Date:   Thu, 27 Oct 2022 18:54:47 +0200
Message-Id: <20221027165058.960159056@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit bdee15e8c58b450ad736a2b62ef8c7a12548b704 ]

If smc_wr_alloc_lgr_mem() fails then return an error code.  Don't return
success.

Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index df89c2e08cbf..828dd3a4126a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -896,7 +896,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 		memcpy(lgr->pnet_id, ibdev->pnetid[ibport - 1],
 		       SMC_MAX_PNETID_LEN);
-		if (smc_wr_alloc_lgr_mem(lgr))
+		rc = smc_wr_alloc_lgr_mem(lgr);
+		if (rc)
 			goto free_wq;
 		smc_llc_lgr_init(lgr, smc);
 
-- 
2.35.1




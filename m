Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10C6593F9F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiHOVIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344781AbiHOVDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:03:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CF651436;
        Mon, 15 Aug 2022 12:14:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64E0EB810A3;
        Mon, 15 Aug 2022 19:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD73CC433B5;
        Mon, 15 Aug 2022 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590883;
        bh=kS8tbc67MJN5uKPeEWqHN9GJd2RwXw/4SoQNaYonMcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW6UV2ozL6GJOJHUh09kponEPOnrYfK2tU7Jxv5m99q1PZkxERnQKFuptQ+GQ0HN2
         zDq0T8u23vjJfNEcVw0Eh5iSMk+t+kwIK6xY7M9kajmCg8Rq1Fup3VaEEHAVf4lGmH
         cfFihIvpW3MLW9X9uxvn9++vGcjk88qe4A9iPh7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0370/1095] crypto: ccp - During shutdown, check SEV data pointer before using
Date:   Mon, 15 Aug 2022 19:56:09 +0200
Message-Id: <20220815180445.028779075@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 1b05ece0c931536c0a38a9385e243a7962e933f6 ]

On shutdown, each CCP device instance performs shutdown processing.
However, __sev_platform_shutdown_locked() uses the controlling psp
structure to obtain the pointer to the sev_device structure. However,
during driver initialization, it is possible that an error can be received
from the firmware that results in the sev_data pointer being cleared from
the controlling psp structure. The __sev_platform_shutdown_locked()
function does not check for this situation and will segfault.

While not common, this scenario should be accounted for. Add a check for a
NULL sev_device structure before attempting to use it.

Fixes: 5441a07a127f ("crypto: ccp - shutdown SEV firmware on kexec")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 812c1356a0f8..95dbab0ffab2 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -503,7 +503,7 @@ static int __sev_platform_shutdown_locked(int *error)
 	struct sev_device *sev = psp_master->sev_data;
 	int ret;
 
-	if (sev->state == SEV_STATE_UNINIT)
+	if (!sev || sev->state == SEV_STATE_UNINIT)
 		return 0;
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
-- 
2.35.1




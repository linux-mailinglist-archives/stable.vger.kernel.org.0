Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3759594A27
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353658AbiHOXjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353671AbiHOXhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:37:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DA2BD1EB;
        Mon, 15 Aug 2022 13:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A74DCE12EB;
        Mon, 15 Aug 2022 20:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E27C433C1;
        Mon, 15 Aug 2022 20:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594197;
        bh=3a/0iYeb7AK1RwoIK1dPVzlUnp+fNBDwrmN1efzJZA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xU69hgcJWroZeeyZxQyZT+ForhNRHOOfCi2gzdTBrLBDo2GwevELn/L4axdLoHWKi
         JYDidCxCeht6apuRb5XgxAlWIZCgbV4IjzCkxehSWVe4VcCFngyGR891Phr3TS4Z3n
         oegvNiPaAzXdifE/zFheRRWqk6Z7z80WT3WMhv2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0393/1157] crypto: ccp - During shutdown, check SEV data pointer before using
Date:   Mon, 15 Aug 2022 19:55:49 +0200
Message-Id: <20220815180455.411363444@linuxfoundation.org>
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
index 0c92d940ac4e..9f588c9728f8 100644
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




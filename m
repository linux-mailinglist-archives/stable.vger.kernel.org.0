Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2331A657D70
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiL1PnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiL1PnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAF917046
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E32561542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0462C433EF;
        Wed, 28 Dec 2022 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242191;
        bh=gGKFdLQh9+hNSTjkHWs4Ma/sIi/sl10LiXJb+KfUtRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQRmdYUAbqua5RlTpLRo1N28cNKBS39DIgY+Emg999ZTbQrzo4+e2YVuGZxMLOetU
         a3P2rwo4gYVcgOv0JIz/UsvwC8moNOcJvPa4LRuk203DQPYRnSUUpr2O+VmcdoxOiq
         rMFjuQoDIXYWp5MFfMreFdjE50pb0Bq/Ch9ljArc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 573/731] powerpc/pseries/eeh: use correct API for error log size
Date:   Wed, 28 Dec 2022 15:41:20 +0100
Message-Id: <20221228144313.165112486@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 9aafbfa5f57a4b75bafd3bed0191e8429c5fa618 ]

rtas-error-log-max is not the name of an RTAS function, so rtas_token()
is not the appropriate API for retrieving its value. We already have
rtas_get_error_log_max() which returns a sensible value if the property
is absent for any reason, so use that instead.

Fixes: 8d633291b4fc ("powerpc/eeh: pseries platform EEH error log retrieval")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
[mpe: Drop no-longer possible error handling as noticed by ajd]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221118150751.469393-6-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 08ce7e4ad9f0..f51fd4ac3f0b 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -846,16 +846,7 @@ static int __init eeh_pseries_init(void)
 	}
 
 	/* Initialize error log size */
-	eeh_error_buf_size = rtas_token("rtas-error-log-max");
-	if (eeh_error_buf_size == RTAS_UNKNOWN_SERVICE) {
-		pr_info("%s: unknown EEH error log size\n",
-			__func__);
-		eeh_error_buf_size = 1024;
-	} else if (eeh_error_buf_size > RTAS_ERROR_LOG_MAX) {
-		pr_info("%s: EEH error log size %d exceeds the maximal %d\n",
-			__func__, eeh_error_buf_size, RTAS_ERROR_LOG_MAX);
-		eeh_error_buf_size = RTAS_ERROR_LOG_MAX;
-	}
+	eeh_error_buf_size = rtas_get_error_log_max();
 
 	/* Set EEH probe mode */
 	eeh_add_flag(EEH_PROBE_MODE_DEVTREE | EEH_ENABLE_IO_FOR_LOG);
-- 
2.35.1




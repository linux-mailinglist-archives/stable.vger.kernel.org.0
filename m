Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF1B667668
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbjALOba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbjALOaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:30:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7565E096
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB81461F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6173C433F0;
        Thu, 12 Jan 2023 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533347;
        bh=seJvWumFKoobQXpi66eWDWoKRUZ3vb+5cnh0u7iGPwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FM2kw3excVaqF59y7pbMvRT8Qo+b2TbWec+xBuwXlP3IJPqKUEc2Km7R3AcaqAxjR
         Fa6yWP3LqHllGA/XaCZfeDTSHLt89/tVumqSdo1VqPV6JSR9tjYd5CqlFmMiRq7/2O
         tROS/HPdcYXh1TqTOt2vc2L8TNAR1I0yxrTtxM4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haowen Bai <baihaowen@meizu.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/783] powerpc/eeh: Drop redundant spinlock initialization
Date:   Thu, 12 Jan 2023 14:52:46 +0100
Message-Id: <20230112135545.110602147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit 3def164a5cedad9117859dd4610cae2cc59cb6d2 ]

slot_errbuf_lock has declared and initialized by DEFINE_SPINLOCK,
so we don't need to spin_lock_init again, drop it.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1652232476-9696-1-git-send-email-baihaowen@meizu.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 7ed38ebd0c7b..6ad8bda06345 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -846,8 +846,7 @@ static int __init eeh_pseries_init(void)
 		return -EINVAL;
 	}
 
-	/* Initialize error log lock and size */
-	spin_lock_init(&slot_errbuf_lock);
+	/* Initialize error log size */
 	eeh_error_buf_size = rtas_token("rtas-error-log-max");
 	if (eeh_error_buf_size == RTAS_UNKNOWN_SERVICE) {
 		pr_info("%s: unknown EEH error log size\n",
-- 
2.35.1




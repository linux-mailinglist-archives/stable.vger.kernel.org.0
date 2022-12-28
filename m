Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC971657D6D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbiL1PnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiL1PnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E812917061
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E21DB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B42C433EF;
        Wed, 28 Dec 2022 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242183;
        bh=5jSvgRiOhduuPkKHWzUxRp4CDHMpTbXlHBe2cPUWReQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1wwWBP3IwXnNBhxUxqXITV9KeDdFU0LsdJKtOj3MlZg/BXUGAKWNX+iNd9VTDSla
         yzAvPHAdqJcQIGdydcVyWX78OiBmdZMxChAnkkiKWS5aWrR2BtSZdT3UwH1v4mxO50
         dmy0be1t2F9yx7hoqLwqP8l3ETmBSU/dGNMMS7oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haowen Bai <baihaowen@meizu.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 572/731] powerpc/eeh: Drop redundant spinlock initialization
Date:   Wed, 28 Dec 2022 15:41:19 +0100
Message-Id: <20221228144313.136609194@linuxfoundation.org>
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
index 09fafcf2d3a0..08ce7e4ad9f0 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -845,8 +845,7 @@ static int __init eeh_pseries_init(void)
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




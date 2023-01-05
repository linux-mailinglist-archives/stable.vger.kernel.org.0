Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7F65EC24
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbjAENGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbjAENGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:06:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0705A88D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEEA761A15
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B13C433D2;
        Thu,  5 Jan 2023 13:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923975;
        bh=2Mc5JHlgPIBa19nGemESDM0gmtnKDomVhNzJTXCGL8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6q7vZqzy7a+1/vBt/h9JdkYcxkIo+GftoY6+b1YdXy+P/VHFhbElKHfiRanlJjfb
         8a6+GdgeVTH1nhRQFQk9gJtMvXG8iXugHR/c0g1QZYtIAXRNXVKsorEWC3E27AH2nZ
         k60YCSWT9ZEe+XCznk+6+07iTI+e0/57nRO5FiDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 164/251] powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()
Date:   Thu,  5 Jan 2023 13:55:01 +0100
Message-Id: <20230105125342.356512639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4d0eea415216fe3791da2f65eb41399e70c7bedf ]

If platform_device_add() is not called or failed, it can not call
platform_device_del() to clean up memory, it should call
platform_device_put() in error case.

Fixes: 26f6cb999366 ("[POWERPC] fsl_soc: add support for fsl_spi")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221029111626.429971-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/83xx/mpc832x_rdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index d7c9b186954d..3e5e51de9a0d 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -111,7 +111,7 @@ static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
 
 		goto next;
 unreg:
-		platform_device_del(pdev);
+		platform_device_put(pdev);
 err:
 		pr_err("%s: registration failed\n", np->full_name);
 next:
-- 
2.35.1




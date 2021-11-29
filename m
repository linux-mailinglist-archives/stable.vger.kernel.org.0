Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4F246254E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhK2Whu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbhK2WhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:37:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915B0C0800D9;
        Mon, 29 Nov 2021 10:38:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3646AB815D4;
        Mon, 29 Nov 2021 18:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635E6C53FC7;
        Mon, 29 Nov 2021 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211136;
        bh=IsvXh94l+yFvljE/qgo+PAhLPMO9YvZWOBuL6WmVWbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8tt2fdv9C0ZALoy/moCkkvvnzEpbOLli53wnY/zKCv5q+mqqQAMGvcbKcLm/M910
         Mz8pzqrGj9vYVNIcVaSzM+t57gmwBDfCjieWIg6IhYM4068gplBMjOKoaabfjDuLIa
         lNJf/dC62Aeq/tdXSOMkwvE4mpMos1MwRZ5ktE0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/179] firmware: smccc: Fix check for ARCH_SOC_ID not implemented
Date:   Mon, 29 Nov 2021 19:18:21 +0100
Message-Id: <20211129181722.465030389@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit e95d8eaee21cd0d117d34125d4cdc97489c1ab82 ]

The ARCH_FEATURES function ID is a 32-bit SMC call, which returns
a 32-bit result per the SMCCC spec.  Current code is doing a 64-bit
comparison against -1 (SMCCC_RET_NOT_SUPPORTED) to detect that the
feature is unimplemented.  That check doesn't work in a Hyper-V VM,
where the upper 32-bits are zero as allowed by the spec.

Cast the result as an 'int' so the comparison works. The change also
makes the code consistent with other similar checks in this file.

Fixes: 821b67fa4639 ("firmware: smccc: Add ARCH_SOC_ID support")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/smccc/soc_id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/smccc/soc_id.c b/drivers/firmware/smccc/soc_id.c
index 581aa5e9b0778..dd7c3d5e8b0bb 100644
--- a/drivers/firmware/smccc/soc_id.c
+++ b/drivers/firmware/smccc/soc_id.c
@@ -50,7 +50,7 @@ static int __init smccc_soc_init(void)
 	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 			     ARM_SMCCC_ARCH_SOC_ID, &res);
 
-	if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
+	if ((int)res.a0 == SMCCC_RET_NOT_SUPPORTED) {
 		pr_info("ARCH_SOC_ID not implemented, skipping ....\n");
 		return 0;
 	}
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD51625093
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiKKCg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiKKCgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE066AED8;
        Thu, 10 Nov 2022 18:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C89661E8D;
        Fri, 11 Nov 2022 02:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20771C4314A;
        Fri, 11 Nov 2022 02:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134105;
        bh=/Z0Bemj1H9MnS0zOk4yHg8sMtqY+q2/C+h6e8CTgJjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CICV55IHYBrfC6ZkBoazSS8nWGXaBnNzjGTYGkugPRWSsOXt7O+Z6G22EePE2wAop
         GlAEyNQ8lYWiYJQB71hG1D09OOHaLzAZFvp+erKKi1NEa+3WZDCw2kgW106gN3Dzlg
         lqV3LC4oDJVm5PbZTi59DXnWaLI/TUA79fTmX7GG9uiv0T6VXLh63XI/XsCX2AMeQX
         H3YWD5yc9HjBXgUqZcbUksL8eIG1+iAe1qAkR1Q5SBixFZz5kOHkpm7qr30RmqbzqB
         r0PPbw1w72atpJkEOQEwFAFnMGv9Qc7GN1AkW0pRDmhFdUH/HS2oZLz6+O89wPagTw
         FWB+xuSkdDbHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Zhe <yuzhe@nfschina.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, alison.schofield@intel.com,
        vishal.l.verma@intel.com, ira.weiny@intel.com, bwidawsk@kernel.org,
        linux-cxl@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 27/30] cxl/pmem: Use size_add() against integer overflow
Date:   Thu, 10 Nov 2022 21:33:35 -0500
Message-Id: <20221111023340.227279-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Zhe <yuzhe@nfschina.com>

[ Upstream commit 4f1aa35f1fb7d51b125487c835982af792697ecb ]

"struct_size() + n" may cause a integer overflow,
use size_add() to handle it.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Link: https://lore.kernel.org/r/20220927070247.23148-1-yuzhe@nfschina.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 7dc0a2fa1a6b..8c08aa009a56 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -148,7 +148,7 @@ static int cxl_pmem_set_config_data(struct cxl_dev_state *cxlds,
 		return -EINVAL;
 
 	/* 4-byte status follows the input data in the payload */
-	if (struct_size(cmd, in_buf, cmd->in_length) + 4 > buf_len)
+	if (size_add(struct_size(cmd, in_buf, cmd->in_length), 4) > buf_len)
 		return -EINVAL;
 
 	set_lsa =
-- 
2.35.1


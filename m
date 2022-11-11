Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2207A62502F
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiKKCds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiKKCdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:33:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F3C64FE;
        Thu, 10 Nov 2022 18:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19CAAB82364;
        Fri, 11 Nov 2022 02:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B52AC433D6;
        Fri, 11 Nov 2022 02:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134023;
        bh=1KI/XL3dP3u5ToDBRNRYqK7q6h6denR/AjAnQMzJ4B4=;
        h=From:To:Cc:Subject:Date:From;
        b=AxNj5VBuVspHERXLrhdqy653AqOAJIKhzYD7LdEjONniezapUt7h+WQhygMbH7qHg
         7sgjm6E02pkr+JZOo61RpSy1TLAvygB1L+PssjTmssA8aNBKQb5lB0XxkogsPj9Qg+
         jLLsk72vMNgLqu9jogiFny+ufxxF+3shyYe8OO1mE4Yx+G9rgnxgNm8r5Zf9j6n9SZ
         pSxNTcXwLbYD04V8ZTHffYMRiQXVezdDgZPuaAtxMrRaiB4azIX2RypU04zBS4JmJg
         l/BelpS2VOrDDopnQhg9ezEiVyU+VJwYT2Ym6lg9F30zriGFzXkFSQLjRfoTbn4kAl
         +I8aU4Y1n91uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, alison.schofield@intel.com,
        vishal.l.verma@intel.com, ira.weiny@intel.com, bwidawsk@kernel.org,
        dave@stgolabs.net, linux-cxl@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 01/30] cxl/mbox: Add a check on input payload size
Date:   Thu, 10 Nov 2022 21:33:09 -0500
Message-Id: <20221111023340.227279-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit cf00b33058b196b4db928419dde68993b15a975b ]

A bug in the LSA code resulted in transfers slightly larger
than the mailbox size. Let us make it easier to catch similar
issues in future by adding a low level check.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20220815154044.24733-2-Jonathan.Cameron@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 16176b9278b4..0c90f13870a4 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -174,7 +174,7 @@ int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
 	};
 	int rc;
 
-	if (out_size > cxlds->payload_size)
+	if (in_size > cxlds->payload_size || out_size > cxlds->payload_size)
 		return -E2BIG;
 
 	rc = cxlds->mbox_send(cxlds, &mbox_cmd);
-- 
2.35.1


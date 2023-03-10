Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175866B40F4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjCJNsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjCJNsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633CD10420
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:47:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 956E2B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DA1C433EF;
        Fri, 10 Mar 2023 13:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456077;
        bh=JwiaiJePlYKy+Z6LmfFH7t3aPBmB+Po3NczqPZBfy58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mt9EmjSA2I56yJI+WfnzZOcpG9/+7sRAXfZptyxSwO6pKYo4YBlD9aH2wsiM2hr8Y
         6YLq463kBZfyKSpAFjw5LdV4EHtKlqSR74HNP187PKkM0fySolOVTmV002Xgnc/IAX
         gj9nw+n95YW87rMo6fgZTSam4S5KGBuNHOabIURc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qiheng Lin <linqiheng@huawei.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 065/193] mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()
Date:   Fri, 10 Mar 2023 14:37:27 +0100
Message-Id: <20230310133713.200023687@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 8b450dcff23aa254844492831a8e2b508a9d522d ]

`req` is allocated in pcf50633_adc_async_read(), but
adc_enqueue_request() could fail to insert the `req` into queue.
We need to check the return value and free it in the case of failure.

Fixes: 08c3e06a5eb2 ("mfd: PCF50633 adc driver")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221208061555.8776-1-linqiheng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/pcf50633-adc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index c1984b0d1b652..a4a765055ee6b 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -140,6 +140,7 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 			     void *callback_param)
 {
 	struct pcf50633_adc_request *req;
+	int ret;
 
 	/* req is freed when the result is ready, in interrupt handler */
 	req = kmalloc(sizeof(*req), GFP_KERNEL);
@@ -151,7 +152,11 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 	req->callback = callback;
 	req->callback_param = callback_param;
 
-	return adc_enqueue_request(pcf, req);
+	ret = adc_enqueue_request(pcf, req);
+	if (ret)
+		kfree(req);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pcf50633_adc_async_read);
 
-- 
2.39.2




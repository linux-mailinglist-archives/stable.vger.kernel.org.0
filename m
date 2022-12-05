Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633DC6433E1
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiLETkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbiLETkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6E927907
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5402AB811E3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3E4C433C1;
        Mon,  5 Dec 2022 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269038;
        bh=IMU+yhRfY9w5AGTrKaRP5qFDlKdiSQObbdoH1tJa3hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuOB4N5LVtBIBjwjVBnh2kpL/X2P7NyK3K2CB6JudaQnnAWWMjCCtGaE4sntXQnQU
         NpxXQT1VMI+oQoGc0oB5/w2hDh9y9KzPwPIPIJB+vQr6xuawoBt5+Oo4kxp/NrsrVJ
         f5hVE7timD3JlFrzxUVprjS+nlgNYD3Y/IbK8rYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 076/120] mmc: mmc_test: Fix removal of debugfs file
Date:   Mon,  5 Dec 2022 20:10:16 +0100
Message-Id: <20221205190808.897472691@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit f4307b4df1c28842bb1950ff0e1b97e17031b17f upstream.

In __mmc_test_register_dbgfs_file(), we need to assign 'file', as it's
being used when removing the debugfs files when the mmc_test module is
removed.

Fixes: a04c50aaa916 ("mmc: core: no need to check return value of debugfs_create functions")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
[Ulf: Re-wrote the commit msg]
Link: https://lore.kernel.org/r/20221123095506.1965691-1-yebin@huaweicloud.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3181,7 +3181,8 @@ static int __mmc_test_register_dbgfs_fil
 	struct mmc_test_dbgfs_file *df;
 
 	if (card->debugfs_root)
-		debugfs_create_file(name, mode, card->debugfs_root, card, fops);
+		file = debugfs_create_file(name, mode, card->debugfs_root,
+					   card, fops);
 
 	df = kmalloc(sizeof(*df), GFP_KERNEL);
 	if (!df) {



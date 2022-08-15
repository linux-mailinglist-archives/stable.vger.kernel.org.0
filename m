Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A097593F99
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbiHOVT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347162AbiHOVSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:18:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1234986C10;
        Mon, 15 Aug 2022 12:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8D16B81120;
        Mon, 15 Aug 2022 19:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C27C433D7;
        Mon, 15 Aug 2022 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591312;
        bh=AZWjm2x8zpKJXfI6zI6/Cj794cVBbJ4zC6s5gwi7uz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7jAWnd0Az+mL66si0lL0tIMvLRWYLlTf6HzVovjhd/RnzK8IriaBI9+0CJ0dVl/M
         06JRrNkMA8Gwa1i0fe0+iU2IByxeg87Yozsuow1sjNIM5PTv8lDnv6qUfs1Xc2YWs7
         lJuRvCSj5a/IG3PGQGv/UhU3EUZVuUPpNqeeT1Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0505/1095] wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`
Date:   Mon, 15 Aug 2022 19:58:24 +0200
Message-Id: <20220815180450.412888119@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

[ Upstream commit d578e0af3a003736f6c440188b156483d451b329 ]

Commit 7a4836560a61 changes simple_write_to_buffer() with memdup_user()
but it forgets to change the value to be returned that came from
simple_write_to_buffer() call. It results in the following warning:

  warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
           return rc;
                  ^~

Remove rc variable and just return the passed in length if the
memdup_user() succeeds.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 7a4836560a6198d245d5732e26f94898b12eb760 ("wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()")
Fixes: ff974e4083341383d3dd4079e52ed30f57f376f0 ("wil6210: debugfs interface to send raw WMI command")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220724202452.61846-1-ammar.faizi@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index c6f8254cb21d..ac7787e1a7f6 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1010,7 +1010,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 	void *cmd;
 	int cmdlen = len - sizeof(struct wmi_cmd_hdr);
 	u16 cmdid;
-	int rc, rc1;
+	int rc1;
 
 	if (cmdlen < 0 || *ppos != 0)
 		return -EINVAL;
@@ -1027,7 +1027,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 
 	wil_info(wil, "0x%04x[%d] -> %d\n", cmdid, cmdlen, rc1);
 
-	return rc;
+	return len;
 }
 
 static const struct file_operations fops_wmi = {
-- 
2.35.1




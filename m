Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6D599FA9
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352064AbiHSQTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352313AbiHSQQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:16:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562A4115202;
        Fri, 19 Aug 2022 08:59:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C52D7616F8;
        Fri, 19 Aug 2022 15:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB68FC433C1;
        Fri, 19 Aug 2022 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924766;
        bh=7xBqaD+HrDQJBUfWG4VqvMRucU4PAwrrna9WkfTRE7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmypBnrDcoLEBJhXj6J/oX8HY/2zki8bUa8XafpfWjjnhvI1WDnXDYQ551EhF43XE
         3LQNw5Syrxt07F8uoq42hJ2YjCu7Z+szi28G0DRb3sdRbyMgzym8s3a+gcT3k9Hz5f
         qCiIamIraRnc24YR+3PWZUD9ca40EbJMj9BWj7XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/545] wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`
Date:   Fri, 19 Aug 2022 17:40:18 +0200
Message-Id: <20220819153840.452845899@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 58c98e58bccb..cb40162bae99 100644
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




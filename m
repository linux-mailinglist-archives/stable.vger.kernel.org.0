Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62A74F254C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiDEHtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbiDEHrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E291B9D053;
        Tue,  5 Apr 2022 00:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62DDDB81B92;
        Tue,  5 Apr 2022 07:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF8C3410F;
        Tue,  5 Apr 2022 07:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144593;
        bh=k04tRHaCCcaSw16B5b4zqxD/SIoqsMzrPWW5b4SpaUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDkCJ0OhczFfMnt0OSiXEKL3UwI0birB6bn8sYARH72zAyT5hiAT+5qCumL7AqUSA
         Si484HyimwnLz5ZNMk5mGLFw1Xi5SBTOCiQBO2/k/9N0SuwySP5gsSXLUMqODMBkeS
         lj6CzjxuZcc8B/NB1c8uOZL7NAKY/KUf1ktIZXWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Delva <adelva@google.com>,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        linux-remoteproc@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 5.17 0062/1126] remoteproc: Fix count check in rproc_coredump_write()
Date:   Tue,  5 Apr 2022 09:13:29 +0200
Message-Id: <20220405070409.390759506@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Alistair Delva <adelva@google.com>

commit f89672cc3681952f2d06314981a6b45f8b0045d1 upstream.

Check count for 0, to avoid a potential underflow. Make the check the
same as the one in rproc_recovery_write().

Fixes: 3afdc59e4390 ("remoteproc: Add coredump debugfs entry")
Signed-off-by: Alistair Delva <adelva@google.com>
Cc: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Cc: stable@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Sibi Sankar <sibis@codeaurora.org>
Cc: linux-remoteproc@vger.kernel.org
Cc: kernel-team@android.com
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220119232139.1125908-1-adelva@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/remoteproc_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -76,7 +76,7 @@ static ssize_t rproc_coredump_write(stru
 	int ret, err = 0;
 	char buf[20];
 
-	if (count > sizeof(buf))
+	if (count < 1 || count > sizeof(buf))
 		return -EINVAL;
 
 	ret = copy_from_user(buf, user_buf, count);



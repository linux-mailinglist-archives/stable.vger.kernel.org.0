Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819494F2AB3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbiDEI1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbiDEIUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E679EB0;
        Tue,  5 Apr 2022 01:15:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B12E660B0B;
        Tue,  5 Apr 2022 08:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AA9C385A1;
        Tue,  5 Apr 2022 08:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146502;
        bh=R3eMH+O/1A3ZwWuiWMDt9Qc+4Won+DXxAfWIqk0wRgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEiMh18W8wd/+RXx5c5DOObcEButHdc6VVV9psEnNLnjMFgoW+HX2VWk5YiycDV65
         lg2OlIVs9fHpXwqJc70sCVB4ZYqk42kdHtCNi18k3yJ08GTDcY4WFqGpXgBsCofhuS
         NvDPkB19Cy/k7aYz6/5FJ/IVh06kNLnH1ctkJ+jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0786/1126] driver core: dd: fix return value of __setup handler
Date:   Tue,  5 Apr 2022 09:25:33 +0200
Message-Id: <20220405070430.646134546@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f2aad54703dbe630f9d8b235eb58e8c8cc78f37d ]

When "driver_async_probe=nulltty" is used on the kernel boot command line,
it causes an Unknown parameter message and the string is added to init's
environment strings, polluting them.

  Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc6
  driver_async_probe=nulltty", will be passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc6
     driver_async_probe=nulltty

Change the return value of the __setup function to 1 to indicate
that the __setup option has been handled.

Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: 1ea61b68d0f8 ("async: Add cmdline option to specify drivers to be async probed")
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20220301041829.15137-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f47cab21430f..752a11d16e26 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -810,7 +810,7 @@ static int __init save_async_options(char *buf)
 		pr_warn("Too long list of driver names for 'driver_async_probe'!\n");
 
 	strlcpy(async_probe_drv_names, buf, ASYNC_DRV_NAMES_MAX_LEN);
-	return 0;
+	return 1;
 }
 __setup("driver_async_probe=", save_async_options);
 
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA8501028
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345551AbiDNNxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345111AbiDNNpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE66A0BE4;
        Thu, 14 Apr 2022 06:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32AF061D68;
        Thu, 14 Apr 2022 13:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B40C385A5;
        Thu, 14 Apr 2022 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943731;
        bh=B7iP0fhFtuzC5RIPTN4X4kWqSQBwh3wnlKttlydx0YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxWas5vD2jJ2xA8P5A2IyfJdDe0/dDTMBmvWeeHJLFva9iJQUcA1iaCStxl9YLj9g
         7gNbR4qcixbFNH7hxegkSsiQeoPkb3zbcYDD16AyDylLubYFBBmOKy68t0vGE5lYYj
         4J3t4HCuBqcL+IA/GWzPWzDQ43V86RGR4bQcJRKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 259/475] driver core: dd: fix return value of __setup handler
Date:   Thu, 14 Apr 2022 15:10:44 +0200
Message-Id: <20220414110902.358734880@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index cf7e5b4afc1b..26cd4ce3ac75 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -747,7 +747,7 @@ static int __init save_async_options(char *buf)
 			"Too long list of driver names for 'driver_async_probe'!\n");
 
 	strlcpy(async_probe_drv_names, buf, ASYNC_DRV_NAMES_MAX_LEN);
-	return 0;
+	return 1;
 }
 __setup("driver_async_probe=", save_async_options);
 
-- 
2.34.1




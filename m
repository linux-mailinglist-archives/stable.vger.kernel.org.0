Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3435E6DD46A
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 09:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDKHlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 03:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjDKHlA (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 11 Apr 2023 03:41:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3678C1733
        for <Stable@vger.kernel.org>; Tue, 11 Apr 2023 00:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B305261DEC
        for <Stable@vger.kernel.org>; Tue, 11 Apr 2023 07:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA926C433D2;
        Tue, 11 Apr 2023 07:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681198858;
        bh=fQNMGINbwst6lOTeKAmMGyZ3Ex9dz4HbbbPSux5ZoKg=;
        h=Subject:To:From:Date:From;
        b=GU9O+tNvVgALy2J0p+JzAovhXKui+VPnRlQKtGWKEoQuintWINpt/e1LRG+5XQNZ2
         M8mUW+kfcikeftDNB5tBzS8x4ko+7bQpuWUrZoJ8T5jE/2a+HaXhN9rL+STJaXvtbj
         QyUKecba2msm8hcSWSZ0KrEYEqjzCefFQCG8nAx4=
Subject: patch "iio: dac: ad5755: Add missing fwnode_handle_put()" added to char-misc-linus
To:     windhl@126.com, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 09:40:45 +0200
Message-ID: <2023041144-spider-overwrite-70fe@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: ad5755: Add missing fwnode_handle_put()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ffef73791574b8da872cfbf881d8e3e9955fc130 Mon Sep 17 00:00:00 2001
From: Liang He <windhl@126.com>
Date: Wed, 22 Mar 2023 11:56:27 +0800
Subject: iio: dac: ad5755: Add missing fwnode_handle_put()

In ad5755_parse_fw(), we should add fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Fixes: 3ac27afefd5d ("iio:dac:ad5755: Switch to generic firmware properties and drop pdata")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20230322035627.1856421-1-windhl@126.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ad5755.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/dac/ad5755.c b/drivers/iio/dac/ad5755.c
index beadfa938d2d..404865e35460 100644
--- a/drivers/iio/dac/ad5755.c
+++ b/drivers/iio/dac/ad5755.c
@@ -802,6 +802,7 @@ static struct ad5755_platform_data *ad5755_parse_fw(struct device *dev)
 	return pdata;
 
  error_out:
+	fwnode_handle_put(pp);
 	devm_kfree(dev, pdata);
 	return NULL;
 }
-- 
2.40.0



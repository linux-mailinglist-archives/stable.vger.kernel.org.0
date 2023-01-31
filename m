Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B63768298C
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjAaJwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjAaJws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 04:52:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E876814492
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 01:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C9686148B
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 09:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D07C433EF;
        Tue, 31 Jan 2023 09:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158765;
        bh=GYwPb/KkDMUg/XIDKgnprFKSRnEOYKtUdgJabTOE6Ao=;
        h=Subject:To:From:Date:From;
        b=vSzmlXqZAItPTzzJgfYNuwIrT7EdHrrxlkaOA7ZkN+NuYBQl2cBs4Xh0I3/NZorRM
         XyUvoNrprTUXmg4xuQ9668ilESsQP75opMGsu5Q8tSRevn1ZnUDLXJiy0lJMSASx/a
         LLGegsQPkiUlsDLkd6TzlLUrZADHGTQJ+dwLpUek=
Subject: patch "iio: adc: xilinx-ams: fix devm_krealloc() return value check" added to char-misc-linus
To:     marpagan@redhat.com, Jonathan.Cameron@huawei.com,
        michal.simek@amd.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:37 +0100
Message-ID: <167515875752143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: xilinx-ams: fix devm_krealloc() return value check

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6794ed0cfcc6ce737240eccc48b3e8190df36703 Mon Sep 17 00:00:00 2001
From: Marco Pagani <marpagan@redhat.com>
Date: Fri, 25 Nov 2022 12:31:12 +0100
Subject: iio: adc: xilinx-ams: fix devm_krealloc() return value check

The clang-analyzer reported a warning: "Value stored to 'ret'
is never read".

Fix the return value check if devm_krealloc() fails to resize
ams_channels.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20221125113112.219290-1-marpagan@redhat.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/xilinx-ams.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index 5b4bdf3a26bb..a507d2e17079 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -1329,7 +1329,7 @@ static int ams_parse_firmware(struct iio_dev *indio_dev)
 
 	dev_channels = devm_krealloc(dev, ams_channels, dev_size, GFP_KERNEL);
 	if (!dev_channels)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	indio_dev->channels = dev_channels;
 	indio_dev->num_channels = num_channels;
-- 
2.39.1



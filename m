Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B1D6DD484
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 09:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjDKHnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 03:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjDKHmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 03:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8A619AB
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 00:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 849476226A
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D3FC433EF;
        Tue, 11 Apr 2023 07:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681198946;
        bh=ujdjpJGFjDHHujcILNgxV7JnHal6cpaJQs49qzaIkdQ=;
        h=Subject:To:From:Date:From;
        b=GGaxgFg6eGQUHNa5Q9mtwVnTpwRdY6z/bDYcfgBP/hccstQxiEwku4V/+7gDFDB86
         r9J7kcHhY63DIbJnrLJ4KZu2xROUCOtL4FffJhOUHPt3wKtxWZkEZKdrLVMJctJ3cJ
         C9Tvxvk/yF1+JA87XOezhw6NOZ/ah17fEfYy3kDU=
Subject: patch "fpga: m10bmc-sec: Fix rsu_send_data() to return" added to char-misc-linus
To:     ilpo.jarvinen@linux.intel.com, russell.h.weight@intel.com,
        stable@vger.kernel.org, yilun.xu@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 09:42:24 +0200
Message-ID: <2023041124-sludge-kimono-2ea1@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    fpga: m10bmc-sec: Fix rsu_send_data() to return

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c3d79fda250ac5df73d089f08311eb87138b04f3 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 8 Feb 2023 10:08:46 +0200
Subject: fpga: m10bmc-sec: Fix rsu_send_data() to return
 FW_UPLOAD_ERR_HW_ERROR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

rsu_send_data() should return FW_UPLOAD_ERR_* error codes instead of
normal -Exxxx codes. Convert <0 return from ->rsu_status() to
FW_UPLOAD_ERR_HW_ERROR.

Fixes: 001a734a55d0 ("fpga: m10bmc-sec: Make rsu status type specific")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Russ Weight <russell.h.weight@intel.com>
Cc: <stable@vger.kernel.org>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20230208080846.10795-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 drivers/fpga/intel-m10-bmc-sec-update.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
index f0acedc80182..d7e2f9f461bc 100644
--- a/drivers/fpga/intel-m10-bmc-sec-update.c
+++ b/drivers/fpga/intel-m10-bmc-sec-update.c
@@ -474,7 +474,7 @@ static enum fw_upload_err rsu_send_data(struct m10bmc_sec *sec)
 
 	ret = sec->ops->rsu_status(sec);
 	if (ret < 0)
-		return ret;
+		return FW_UPLOAD_ERR_HW_ERROR;
 	status = ret;
 
 	if (!rsu_status_ok(status)) {
-- 
2.40.0



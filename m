Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75200676D1F
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjAVNWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjAVNWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:22:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F06C16AFE
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:22:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D78B80AD2
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84236C433EF;
        Sun, 22 Jan 2023 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393746;
        bh=TNdHm9xtO5TvSDibFfm0W/wud5ONwbwvIRhE+CSVM1o=;
        h=Subject:To:Cc:From:Date:From;
        b=JgQOeWRv2+RfzDbU1rL5Fwf8NWb0RLD5wXnoRXAvsWrLYbEpr7sVm82Nv6HQLOfyD
         S8Uwuh/OtRmiB3ttj2zckLzbqrPgCoEtqXvkc6rL2PKtr32b/5nx0Qx47Yh1jW8K/x
         j1rGoEDKonCxS9PT/mZuB+lr4CBEQomanL8Btcps=
Subject: FAILED: patch "[PATCH] mei: bus: fix unlink on bus in error path" failed to apply to 5.10-stable tree
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:22:21 +0100
Message-ID: <1674393741211134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a43866856125 ("mei: bus: fix unlink on bus in error path")
2cca3465147d ("mei: bus: add client dma interface")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a43866856125c3c432e2fbb6cc63cee1539ec4a7 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 13 Dec 2022 00:02:46 +0200
Subject: [PATCH] mei: bus: fix unlink on bus in error path

Unconditional call to mei_cl_unlink in mei_cl_bus_dev_release leads
to call of the mei_cl_unlink without corresponding mei_cl_link.
This leads to miscalculation of open_handle_count (decrease without
increase).

Call unlink in mei_cldev_enable fail path and remove blanket unlink
from mei_cl_bus_dev_release.

Fixes: 34f1166afd67 ("mei: bus: need to unlink client before freeing")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221212220247.286019-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 4a08b624910a..a81b890c7ee6 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -702,13 +702,15 @@ void *mei_cldev_dma_map(struct mei_cl_device *cldev, u8 buffer_id, size_t size)
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
 
 	ret = mei_cl_dma_alloc_and_map(cl, NULL, buffer_id, size);
-out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 	if (ret)
 		return ERR_PTR(ret);
@@ -758,7 +760,7 @@ int mei_cldev_enable(struct mei_cl_device *cldev)
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
@@ -785,6 +787,9 @@ int mei_cldev_enable(struct mei_cl_device *cldev)
 	}
 
 out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 
 	return ret;
@@ -1277,7 +1282,6 @@ static void mei_cl_bus_dev_release(struct device *dev)
 	mei_cl_flush_queues(cldev->cl, NULL);
 	mei_me_cl_put(cldev->me_cl);
 	mei_dev_bus_put(cldev->bus);
-	mei_cl_unlink(cldev->cl);
 	kfree(cldev->cl);
 	kfree(cldev);
 }


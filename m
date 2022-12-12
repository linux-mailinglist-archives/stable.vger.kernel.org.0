Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C543164A9E4
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 23:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiLLWDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 17:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLLWDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 17:03:05 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9839F03F;
        Mon, 12 Dec 2022 14:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670882584; x=1702418584;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aFPYcOucgIFUlz+4+w4V1tHgUceYUOkHyxLBqX/JX8Q=;
  b=A0IsyqR0oGkXe3usUL+ZMPHY401VVdNMogMiLESvSu6CGygSGysOxQ1F
   4EzU2XRkgshpCUoZZrVYoWJakWZ3NZOCCu71FwpG9xiteF2zOLMh0awbt
   WbJF4SfnVICCJhhz+HxJf/YvLJcPuUAVjnhKYJimYHMhKor7sG1yUo4kO
   ohiXAPeYY0EH1WYkQMGSEp1PTotVpMekrRSNUAfoOWREVm6xrw7VRIeO1
   9eJB/LvYET2vQLJw3ayNeRx5KCGNjInss4RKvOzzZ839/kOWndJOG+INx
   Kvj1jFwQl48taOtHlA2uRvR0wt+u9XQ0v04XbgxKfkE7Rrgn8GUgHfIR9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="297653647"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="297653647"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 14:03:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="772749655"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="772749655"
Received: from twinkler-lnx.jer.intel.com ([10.12.87.42])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 14:02:59 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 1/2] mei: bus: fix unlink on bus in error path
Date:   Tue, 13 Dec 2022 00:02:46 +0200
Message-Id: <20221212220247.286019-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

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
---
 drivers/misc/mei/bus.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index fdb5f7331695..3d24bdb02f0f 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -685,13 +685,15 @@ void *mei_cldev_dma_map(struct mei_cl_device *cldev, u8 buffer_id, size_t size)
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
@@ -741,7 +743,7 @@ int mei_cldev_enable(struct mei_cl_device *cldev)
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
@@ -768,6 +770,9 @@ int mei_cldev_enable(struct mei_cl_device *cldev)
 	}
 
 out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 
 	return ret;
@@ -1135,7 +1140,6 @@ static void mei_cl_bus_dev_release(struct device *dev)
 	mei_cl_flush_queues(cldev->cl, NULL);
 	mei_me_cl_put(cldev->me_cl);
 	mei_dev_bus_put(cldev->bus);
-	mei_cl_unlink(cldev->cl);
 	kfree(cldev->cl);
 	kfree(cldev);
 }
-- 
2.38.1


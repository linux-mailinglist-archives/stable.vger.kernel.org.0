Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048EB68D2E3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjBGJds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjBGJdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:33:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDCE12F24
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:33:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F3E61259
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B52C433D2;
        Tue,  7 Feb 2023 09:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675762423;
        bh=nvBVyqaYhvwu6fvq5hO/R947sVcIO/hHgKksN7PX4vY=;
        h=Subject:To:Cc:From:Date:From;
        b=b59+UjmDD5/7VZoMvVHPyj3sdPpUmxt2GzSDz4CEtjYGzah305zPlkJLXN/BeWj23
         faH214cJLoFxdhtle+sCvxC17VSwfIojH8190nfpSzxI70GrHWHYV6ybrK/dOALFZ2
         7Y/Jyo1SiOpnAHXLEpNoLEZMMoPn+/5cpmIrwCcE=
Subject: FAILED: patch "[PATCH] nvmem: core: fix cell removal on error" failed to apply to 4.19-stable tree
To:     michael@walle.cc, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:33:39 +0100
Message-ID: <167576241991245@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

db3546d58b5a ("nvmem: core: fix cell removal on error")
b985f4cba6db ("nvmem: add support for cell info")
c7235ee3f4b8 ("nvmem: remove the global cell list")
c1de7f43bd84 ("nvmem: use kref")
fa72d847d68d ("nvmem: check the return value of nvmem_add_cells()")
1852183e142e ("nvmem: use list_for_each_entry_safe in nvmem_device_remove_all_cells()")
d7b9fd1669d4 ("nvmem: provide nvmem_dev_name()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From db3546d58b5a0fa581d9c9f2bdc2856fa6c5e43e Mon Sep 17 00:00:00 2001
From: Michael Walle <michael@walle.cc>
Date: Fri, 27 Jan 2023 10:40:13 +0000
Subject: [PATCH] nvmem: core: fix cell removal on error

nvmem_add_cells() could return an error after some cells are already
added to the provider. In this case, the added cells are not removed.
Remove any registered cells if nvmem_add_cells() fails.

Fixes: fa72d847d68d7 ("nvmem: check the return value of nvmem_add_cells()")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-9-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index cbe5df99db82..563116405b3d 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -847,7 +847,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	if (config->cells) {
 		rval = nvmem_add_cells(nvmem, config->cells, config->ncells);
 		if (rval)
-			goto err_teardown_compat;
+			goto err_remove_cells;
 	}
 
 	rval = nvmem_add_cells_from_table(nvmem);
@@ -870,7 +870,6 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 err_remove_cells:
 	nvmem_device_remove_all_cells(nvmem);
-err_teardown_compat:
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
 err_put_device:


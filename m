Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC304EEB33
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbiDAK2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241970AbiDAK2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:28:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C6326E54C
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE996171A
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D13BC2BBE4;
        Fri,  1 Apr 2022 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648808792;
        bh=vqJSttDdl5FpA//uiSaqv6QSXjoT+DF5wzZN1odEU+M=;
        h=Subject:To:Cc:From:Date:From;
        b=BbE9LBaTo5z9IxGLngSQE0B65mQDPUgW8JYLL5qQkFrBZP1w+4jOGGAUDxo+EieGi
         MCqi+y12s4DiKysMr7skAuxmtIeA3ObHlwuGBWqc06PrrpUY7l/nkPPRIKGhTWvtGI
         LRmrNSk0mfTI8LRBzp/Wm1Sk7JFKQ3vjOMp26FHQ=
Subject: FAILED: patch "[PATCH] firmware: stratix10-svc: add missing callback parameter on" failed to apply to 5.4-stable tree
To:     tien.sung.ang@intel.com, dinguyen@kernel.org,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 12:26:25 +0200
Message-ID: <164880878539126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b850b7a8b369322adf699ef48ceff4d902525c8c Mon Sep 17 00:00:00 2001
From: Ang Tien Sung <tien.sung.ang@intel.com>
Date: Wed, 23 Feb 2022 08:41:46 -0600
Subject: [PATCH] firmware: stratix10-svc: add missing callback parameter on
 RSU

Fix a bug whereby, the return response of parameter a1 from an
SMC call is not properly set to the callback data during an
INTEL_SIP_SMC_RSU_ERROR command.

Link: https://lore.kernel.org/lkml/20220216081513.28319-1-tien.sung.ang@intel.com
Fixes: 6b50d882d38d ("firmware: add remote status update client support")
Cc: stable@vger.kernel.org
Signed-off-by: Ang Tien Sung <tien.sung.ang@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20220223144146.399263-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 4bd57a908efe..8177a0fae11d 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -483,7 +483,7 @@ static int svc_normal_to_secure_thread(void *data)
 		case INTEL_SIP_SMC_RSU_ERROR:
 			pr_err("%s: STATUS_ERROR\n", __func__);
 			cbdata->status = BIT(SVC_STATUS_ERROR);
-			cbdata->kaddr1 = NULL;
+			cbdata->kaddr1 = &res.a1;
 			cbdata->kaddr2 = NULL;
 			cbdata->kaddr3 = NULL;
 			pdata->chan->scl->receive_cb(pdata->chan->scl, cbdata);


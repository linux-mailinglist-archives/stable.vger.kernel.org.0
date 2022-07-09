Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C3F56C7E6
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 10:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiGIIRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 04:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiGIIRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 04:17:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BF3747A7
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 01:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6A55B810C5
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 08:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA68C3411C;
        Sat,  9 Jul 2022 08:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657354617;
        bh=qF0GzNROg3mnTdgeS3QD3d1UrfO7Kn1ThEleWoxWLbg=;
        h=Subject:To:Cc:From:Date:From;
        b=zGObvd99RTIE+OUE3z9npi0dMwyPiaPG+ik5SzJdiq72v2LpOsIwsGXw9LE6n+3mK
         S1BEojYqMy5YMpH7GD3dleVafT3yaj+Bb+Luofx0cKaQTzRqGOU4pWIYKBbnGnZZ1w
         odyI8OogVGCkLvvJP145iaIWL6jyMRx/msGprkyA=
Subject: FAILED: patch "[PATCH] cxl/mbox: Fix missing variable payload checks in cmd size" failed to apply to 5.18-stable tree
To:     vishal.l.verma@intel.com, abhi.cs@intel.com,
        alison.schofield@intel.com, dan.j.williams@intel.com,
        ira.weiny@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Jul 2022 10:16:55 +0200
Message-ID: <165735461523382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e35f5718903b093be4b1d3833aa8a32f864a3ef1 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 28 Jun 2022 16:01:09 -0600
Subject: [PATCH] cxl/mbox: Fix missing variable payload checks in cmd size
 validation

The conversion of command sizes to unsigned missed a couple of checks
against variable size payloads during command validation, which made all
variable payload commands unconditionally fail. Add the checks back using
the new CXL_VARIABLE_PAYLOAD scheme.

Fixes: 26f89535a5bb ("cxl/mbox: Use type __u32 for mailbox payload sizes")
Cc: <stable@vger.kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Reported-by: Abhi Cs <abhi.cs@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/20220628220109.633564-1-vishal.l.verma@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 54f434733b56..cbf23beebebe 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -355,11 +355,13 @@ static int cxl_to_mem_cmd(struct cxl_mem_command *mem_cmd,
 		return -EBUSY;
 
 	/* Check the input buffer is the expected size */
-	if (info->size_in != send_cmd->in.size)
+	if ((info->size_in != CXL_VARIABLE_PAYLOAD) &&
+	    (info->size_in != send_cmd->in.size))
 		return -ENOMEM;
 
 	/* Check the output buffer is at least large enough */
-	if (send_cmd->out.size < info->size_out)
+	if ((info->size_out != CXL_VARIABLE_PAYLOAD) &&
+	    (send_cmd->out.size < info->size_out))
 		return -ENOMEM;
 
 	*mem_cmd = (struct cxl_mem_command) {


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10B94F2ACE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355508AbiDEKUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345317AbiDEJWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E8E4338C;
        Tue,  5 Apr 2022 02:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7489B81A12;
        Tue,  5 Apr 2022 09:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4F2C385A2;
        Tue,  5 Apr 2022 09:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149826;
        bh=dOC/qeva2LJb0df2IyTGuQKNhvG4/vpycOtEmcS+tso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRMEqPuwWQ3tg9Zr9GxnR8U5d4nxvdssKVR/uYF4k7m07hIC7EBFY5SD/kw9Fdld6
         aHjjveeA9N0vXhqQgZeJrm0boebnDPnrH26+vMhErU2ADSgva27TEjymyilk2COmo4
         MRgu3hNaZb29sDjw1LKzfvRcHojI+EJzSHK4uIwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0855/1017] media: atomisp: fix bad usage at error handling logic
Date:   Tue,  5 Apr 2022 09:29:28 +0200
Message-Id: <20220405070419.615422796@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Upstream commit fc0b582c858ed73f94c8f3375c203ea46f1f7402 ]

As warned by sparse:
	atomisp: drivers/staging/media/atomisp/pci/atomisp_acc.c:508 atomisp_acc_load_extensions() warn: iterator used outside loop: 'acc_fw'

The acc_fw interactor is used outside the loop, at the error handling
logic. On most cases, this is actually safe there, but, if
atomisp_css_set_acc_parameters() has an error, an attempt to use it
will pick an invalid value for acc_fw.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_acc.c   | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_acc.c b/drivers/staging/media/atomisp/pci/atomisp_acc.c
index 9a1751895ab0..28cb271663c4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_acc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_acc.c
@@ -439,6 +439,18 @@ int atomisp_acc_s_mapped_arg(struct atomisp_sub_device *asd,
 	return 0;
 }
 
+static void atomisp_acc_unload_some_extensions(struct atomisp_sub_device *asd,
+					      int i,
+					      struct atomisp_acc_fw *acc_fw)
+{
+	while (--i >= 0) {
+		if (acc_fw->flags & acc_flag_to_pipe[i].flag) {
+			atomisp_css_unload_acc_extension(asd, acc_fw->fw,
+							 acc_flag_to_pipe[i].pipe_id);
+		}
+	}
+}
+
 /*
  * Appends the loaded acceleration binary extensions to the
  * current ISP mode. Must be called just before sh_css_start().
@@ -479,16 +491,20 @@ int atomisp_acc_load_extensions(struct atomisp_sub_device *asd)
 								     acc_fw->fw,
 								     acc_flag_to_pipe[i].pipe_id,
 								     acc_fw->type);
-				if (ret)
+				if (ret) {
+					atomisp_acc_unload_some_extensions(asd, i, acc_fw);
 					goto error;
+				}
 
 				ext_loaded = true;
 			}
 		}
 
 		ret = atomisp_css_set_acc_parameters(acc_fw);
-		if (ret < 0)
+		if (ret < 0) {
+			atomisp_acc_unload_some_extensions(asd, i, acc_fw);
 			goto error;
+		}
 	}
 
 	if (!ext_loaded)
@@ -497,6 +513,7 @@ int atomisp_acc_load_extensions(struct atomisp_sub_device *asd)
 	ret = atomisp_css_update_stream(asd);
 	if (ret) {
 		dev_err(isp->dev, "%s: update stream failed.\n", __func__);
+		atomisp_acc_unload_extensions(asd);
 		goto error;
 	}
 
@@ -504,13 +521,6 @@ int atomisp_acc_load_extensions(struct atomisp_sub_device *asd)
 	return 0;
 
 error:
-	while (--i >= 0) {
-		if (acc_fw->flags & acc_flag_to_pipe[i].flag) {
-			atomisp_css_unload_acc_extension(asd, acc_fw->fw,
-							 acc_flag_to_pipe[i].pipe_id);
-		}
-	}
-
 	list_for_each_entry_continue_reverse(acc_fw, &asd->acc.fw, list) {
 		if (acc_fw->type != ATOMISP_ACC_FW_LOAD_TYPE_OUTPUT &&
 		    acc_fw->type != ATOMISP_ACC_FW_LOAD_TYPE_VIEWFINDER)
-- 
2.34.1




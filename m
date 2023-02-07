Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438A968D8C5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjBGNM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjBGNMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:12:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87413BDA8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAE37B81990
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23358C433EF;
        Tue,  7 Feb 2023 13:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775189;
        bh=MacZ1whNHk5jZpB3a+BAxtb940aA4gQt/9BRQ1UrugA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u26hmNjeDhUhMuA8XoRYREpKpSDiDT23BGaZnj6P2aCmdWt+h1086u2S4SWPQv5Vi
         RJN5P2O1N84aFnZ5B0jGBIkmYn0Ho3S0xuPxrwOhXe6jjH/u2HRAjDTSp93FFlWy1F
         TcxV8gG1IIer3TN2aidv0VRigOZc0Q40EOKEH49w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Russ Weight <russell.h.weight@intel.com>,
        Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6.1 166/208] fpga: stratix10-soc: Fix return value check in s10_ops_write_init()
Date:   Tue,  7 Feb 2023 13:57:00 +0100
Message-Id: <20230207125641.933198175@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

commit 65ea840afd508194b0ee903256162aa87e46ec30 upstream.

In case of error, the function stratix10_svc_allocate_memory()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().

Fixes: e7eef1d7633a ("fpga: add intel stratix10 soc fpga manager driver")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Reviewed-by: Russ Weight <russell.h.weight@intel.com>
Cc: stable@vger.kernel.org
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20221126071430.19540-1-zhengyongjun3@huawei.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/stratix10-soc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -213,9 +213,9 @@ static int s10_ops_write_init(struct fpg
 	/* Allocate buffers from the service layer's pool. */
 	for (i = 0; i < NUM_SVC_BUFS; i++) {
 		kbuf = stratix10_svc_allocate_memory(priv->chan, SVC_BUF_SIZE);
-		if (!kbuf) {
+		if (IS_ERR(kbuf)) {
 			s10_free_buffers(mgr);
-			ret = -ENOMEM;
+			ret = PTR_ERR(kbuf);
 			goto init_done;
 		}
 



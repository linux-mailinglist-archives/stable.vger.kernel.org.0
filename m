Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78DB6AED10
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCGSBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCGSAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:00:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B16199BCD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB88761469
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29F2C433D2;
        Tue,  7 Mar 2023 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211678;
        bh=d0qWZZXD/D73c/z3EwcK1c2WSdGFjFTE9vadA1Q0FvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1ESs872gsq17lVXrr3o/4HI9nPN40JWbBfoFlg0WQKZ17X8TSoTl2O+IJgtRMyOk
         qJsKrIax9wgnSCXiqQTT6tWDkfsyQnACTOIb05kGHGgmOPXd1nnmWO9XuHA7mb7YeQ
         C4TkTkLUSgf52RQCP1uQGvmaATWazAEZZVrh1KJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.2 0941/1001] media: ipu3-cio2: Fix PM runtime usage_count in driver unbind
Date:   Tue,  7 Mar 2023 18:01:53 +0100
Message-Id: <20230307170102.965363259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 909d3096ac99fa2289f9b8945a3eab2269947a0a upstream.

Get the PM runtime usage_count and forbid PM runtime at driver unbind. The
opposite is being done in probe() already.

Fixes: commit c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Cc: stable@vger.kernel.org # for >= 4.16
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
@@ -1843,6 +1843,9 @@ static void cio2_pci_remove(struct pci_d
 	v4l2_device_unregister(&cio2->v4l2_dev);
 	media_device_cleanup(&cio2->media_dev);
 	mutex_destroy(&cio2->lock);
+
+	pm_runtime_forbid(&pci_dev->dev);
+	pm_runtime_get_noresume(&pci_dev->dev);
 }
 
 static int __maybe_unused cio2_runtime_suspend(struct device *dev)



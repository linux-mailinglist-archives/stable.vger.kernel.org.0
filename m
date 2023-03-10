Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318FE6B498C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbjCJPN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbjCJPNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C0B56533
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 973E061A14
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91006C4339C;
        Fri, 10 Mar 2023 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460638;
        bh=zoq0WZoqgS4xGDnnrrBSPWV3aXx9YaY5UobJ8oT6hlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDt+QQQk6Jop5WR+8++kd6kfXWomTgDtycwMdrAZAhSL8brqTK/ephR6W3t7Ij4ce
         9l8Sd3o8S7Sb80LkS1UuhcE/EyKRNk+KrNLerxxt0aXjuF2hRaaKkSSXq/lc5ZqM9H
         ypQZW/NUNM8V0fcjpfYY6/aTkbhx9RU+SQy/EmyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 401/529] media: ipu3-cio2: Fix PM runtime usage_count in driver unbind
Date:   Fri, 10 Mar 2023 14:39:04 +0100
Message-Id: <20230310133823.576329524@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1831,6 +1831,9 @@ static void cio2_pci_remove(struct pci_d
 	v4l2_device_unregister(&cio2->v4l2_dev);
 	media_device_cleanup(&cio2->media_dev);
 	mutex_destroy(&cio2->lock);
+
+	pm_runtime_forbid(&pci_dev->dev);
+	pm_runtime_get_noresume(&pci_dev->dev);
 }
 
 static int __maybe_unused cio2_runtime_suspend(struct device *dev)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0595AEBE7
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241458AbiIFONM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241200AbiIFOMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:12:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39915876BD;
        Tue,  6 Sep 2022 06:47:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 448B7B81633;
        Tue,  6 Sep 2022 13:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65F6C433C1;
        Tue,  6 Sep 2022 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471977;
        bh=LvdH7vVr1r23YEdZutNO3OHpW6XFVLpbsu0SIYi1q5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/IB+K8m7S8hJtdvQVVd1JOpCrsyPhUDKthcIiwS3vBYa1usd/4lKMATxajxQE6Nu
         Zjhs5qTViGXy4W0RIgVIJcF+vn70DwO5VpS1WUp/YkpwNLzBdSvaAYGioL9QnwB9vD
         JdVeNGFXTFtNTIl+EhX/uy/BR1csooQawVKIwveQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        Russ Weight <russell.h.weight@intel.com>
Subject: [PATCH 5.19 074/155] firmware_loader: Fix use-after-free during unregister
Date:   Tue,  6 Sep 2022 15:30:22 +0200
Message-Id: <20220906132832.553603595@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Russ Weight <russell.h.weight@intel.com>

commit 8b40c38e37492b5bdf8e95b46b5cca9517a9957a upstream.

In the following code within firmware_upload_unregister(), the call to
device_unregister() could result in the dev_release function freeing the
fw_upload_priv structure before it is dereferenced for the call to
module_put(). This bug was found by the kernel test robot using
CONFIG_KASAN while running the firmware selftests.

  device_unregister(&fw_sysfs->dev);
  module_put(fw_upload_priv->module);

The problem is fixed by copying fw_upload_priv->module to a local variable
for use when calling device_unregister().

Fixes: 97730bbb242c ("firmware_loader: Add firmware-upload support")
Cc: stable <stable@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Link: https://lore.kernel.org/r/20220829174557.437047-1-russell.h.weight@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/sysfs_upload.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -377,6 +377,7 @@ void firmware_upload_unregister(struct f
 {
 	struct fw_sysfs *fw_sysfs = fw_upload->priv;
 	struct fw_upload_priv *fw_upload_priv = fw_sysfs->fw_upload_priv;
+	struct module *module = fw_upload_priv->module;
 
 	mutex_lock(&fw_upload_priv->lock);
 	if (fw_upload_priv->progress == FW_UPLOAD_PROG_IDLE) {
@@ -392,6 +393,6 @@ void firmware_upload_unregister(struct f
 
 unregister:
 	device_unregister(&fw_sysfs->dev);
-	module_put(fw_upload_priv->module);
+	module_put(module);
 }
 EXPORT_SYMBOL_GPL(firmware_upload_unregister);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3A0628E01
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 01:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbiKOALc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 19:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiKOALb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 19:11:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93273FCD;
        Mon, 14 Nov 2022 16:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668471090; x=1700007090;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FsCnO8dfjV43Rhk8SsXpTIp9c/a1VWzJN5zR4YvPUrY=;
  b=edoK35KsAncDjzk7rwsxNBqQQPrRMqySyWNkWJedKFMa+ec1V47ULt2L
   JOTcCRLbFR0zs/kRmFe8o6rcxbmvNMwT9NL8qiLTI5c7VnFEuFHYiEhep
   Pm03f7l8Q4vBG4IUufcEl+fPIkNMzTeW0HfORBNOoLQoEyh1dwmnDdyGq
   5M+0BuP2srMF6OSeY0J9DeRLZrmh6N8JhExWHEX6Q2zGPHxTxc8g7LH84
   azZGL+kMNiw+3ohdlb94wr4CELThZrjPzTRyMiydFAwXoixyuXGMNkSDh
   /sr4ev8vbB853cPwakIvrrHsVzYHCze+enRLmAsemn9bZv8/9Oti0xOBo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="398409361"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="398409361"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:11:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="707518156"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="707518156"
Received: from rhweight-mobl.amr.corp.intel.com (HELO rhweight-mobl.ra.intel.com) ([10.209.83.173])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:11:29 -0800
From:   Russ Weight <russell.h.weight@intel.com>
To:     mdf@kernel.org, hao.wu@intel.com, yilun.xu@intel.com,
        trix@redhat.com, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lgoncalv@redhat.com, marpagan@redhat.com,
        matthew.gerlach@linux.intel.com,
        basheer.ahmed.muddebihal@intel.com, tianfei.zhang@intel.com,
        Russ Weight <russell.h.weight@intel.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH v1 1/1] fpga: m10bmc-sec: Fix kconfig dependencies
Date:   Mon, 14 Nov 2022 16:11:27 -0800
Message-Id: <20221115001127.289890-1-russell.h.weight@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The secure update driver depends on the firmware-upload functionality of
the firmware-loader. The firmware-loader is carried in the firmware-class
driver which is enabled with the tristate CONFIG_FW_LOADER option. The
firmware-upload functionality is included in the firmware-class driver if
the bool FW_UPLOAD config is set.

The current dependency statement, "depends on FW_UPLOAD", is not adequate
because it does not implicitly turn on FW_LOADER. Instead of adding a
dependency, follow the convention used by drivers that require the
FW_LOADER_USER_HELPER functionality of the firmware-loader by using
select for both FW_LOADER and FW_UPLOAD.

Fixes: bdf86d0e6ca3 ("fpga: m10bmc-sec: create max10 bmc secure update")
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
---
 drivers/fpga/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index d1a8107fdcb3..6ce143dafd04 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -246,7 +246,9 @@ config FPGA_MGR_VERSAL_FPGA
 
 config FPGA_M10_BMC_SEC_UPDATE
 	tristate "Intel MAX10 BMC Secure Update driver"
-	depends on MFD_INTEL_M10_BMC && FW_UPLOAD
+	depends on MFD_INTEL_M10_BMC
+	select FW_LOADER
+	select FW_UPLOAD
 	help
 	  Secure update support for the Intel MAX10 board management
 	  controller.
-- 
2.25.1


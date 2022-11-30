Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E105763E00B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiK3SxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiK3Sw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5388267E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B746B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C572C433D6;
        Wed, 30 Nov 2022 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834372;
        bh=Totxfezu9bhWZZve0dZ+6YN/1arN0WKEOUyiqCG0Kkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bd21DTmLbBDBqfdHUnZcx+QogpS7mO0svEwmo1jaXdCvBPWOn8G182ZRCPJVNOT2q
         RFZNKmMAkLlIryIb9NZtIeyNI2Vd1CEeW1WZ1EThZbM7WqxuMWc3nFd0fuHb5GvgZw
         XHr6d9tdp52pOoRvyKRWutFJKwjGS0BWj+5jndE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Russ Weight <russell.h.weight@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6.0 202/289] fpga: m10bmc-sec: Fix kconfig dependencies
Date:   Wed, 30 Nov 2022 19:23:07 +0100
Message-Id: <20221130180548.700013161@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russ Weight <russell.h.weight@intel.com>

commit dfd10332596ef11ceafd29c4e21b4117be423fc4 upstream.

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
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20221115001127.289890-1-russell.h.weight@intel.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 6c416955da53..bbe0a7cabb75 100644
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
2.38.1




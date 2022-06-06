Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEE853E6F8
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiFFL7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiFFL7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:59:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B86B183B2
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 969C0CE1A25
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560A9C34119;
        Mon,  6 Jun 2022 11:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654516738;
        bh=XE4QfnbbEu3Pt1Xw5DnNqOnZeDMFGij64uH1lR0ZDRs=;
        h=Subject:To:Cc:From:Date:From;
        b=R2a04fPPebrpzZyZf/aOo1ym2glekMDxQ1VM6LVFQGQ6tEiZgsF74XmGyjjQo+Lmj
         SDOSuhorO/W1Q20MnJR8OGPmVKMfq0wEODzPbnt/BqnLY3i1f57b5HaRydGkUYjS8K
         +ipPYqAXTRHIgONSU4gxJtaEExKdy7w7hAMhEHJc=
Subject: FAILED: patch "[PATCH] iwlwifi: fw: init SAR GEO table only if data is present" failed to apply to 5.15-stable tree
To:     johannes.berg@intel.com, gregory.greenman@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:58:50 +0200
Message-ID: <165451673017188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d1f6530c3e373ddd7c76b05646052a27eead14ad Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 17 May 2022 12:05:08 +0300
Subject: [PATCH] iwlwifi: fw: init SAR GEO table only if data is present

When no table data was read from ACPI, then filling the data
and returning success here will fill zero values, which means
transmit power will be limited to 0 dBm. This is clearly not
intended.

Return an error from iwl_sar_geo_init() if there's no data to
fill into the command structure.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 78a19d5285d9 ("iwlwifi: mvm: Read the PPAG and SAR tables at INIT stage")
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20220517120044.bc45923b74e9.Id2b4362234b7f8ced82c591b95d4075dd2ec12f4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 33aae639ad37..e6d64152c81a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -937,6 +937,9 @@ int iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
 {
 	int i, j;
 
+	if (!fwrt->geo_enabled)
+		return -ENODATA;
+
 	if (!iwl_sar_geo_support(fwrt))
 		return -EOPNOTSUPP;
 


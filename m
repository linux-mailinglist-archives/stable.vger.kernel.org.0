Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7F5415EB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376314AbiFGUnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376937AbiFGUkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:40:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BD71EEBA9;
        Tue,  7 Jun 2022 11:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D5F7B8237E;
        Tue,  7 Jun 2022 18:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCE9C385A2;
        Tue,  7 Jun 2022 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627111;
        bh=DWWQnprN+kklfnxxfGaSSrsNVdWKU38XVsj5mB66ck8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8lOcxAgCrzEjXuPajCV7QG/tHGl1xpWWhb9O9BjC3Y3hw1qe5WPPe2fYmqEejbL1
         Pp/1v0DLSS5lvmE5CJv7sYcOmCnfYwH/dZq2wV6+0bvYQLdZqajYet8VdHXpmR9aWo
         xElTSDYMbX/9jtcDhp6JLIkE77yBYHDXe9inH/Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 5.17 621/772] iwlwifi: fw: init SAR GEO table only if data is present
Date:   Tue,  7 Jun 2022 19:03:33 +0200
Message-Id: <20220607165007.234863541@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Johannes Berg <johannes.berg@intel.com>

commit d1f6530c3e373ddd7c76b05646052a27eead14ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -902,6 +902,9 @@ int iwl_sar_geo_init(struct iwl_fw_runti
 {
 	int i, j;
 
+	if (!fwrt->geo_enabled)
+		return -ENODATA;
+
 	if (!iwl_sar_geo_support(fwrt))
 		return -EOPNOTSUPP;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D36E64F0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbjDRMxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjDRMxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB8C16FB5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B34C963440
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50A6C433D2;
        Tue, 18 Apr 2023 12:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822405;
        bh=K+j/i8K8kMMSszfNupuLxaXZnj31ATwCSwYFwNpMhPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIuqkOTKZKjxC5RSKwnG0OylJS++I0htWMxnWqet1kceGwYd6BcfufC2N1Rcyhs29
         v3skviHmdF4KBBQ1CP7LrqpOg+7K7VVeL3rc8Hb21cH84HpeLtrO+ZRs380//KsVlg
         hndC38ubHexkGZP7eesawaUHCLK5VuMDTmieBiDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tanu Malhotra <tanu.malhotra@intel.com>,
        Shaunak Saha <shaunak.saha@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.2 107/139] HID: intel-ish-hid: Fix kernel panic during warm reset
Date:   Tue, 18 Apr 2023 14:22:52 +0200
Message-Id: <20230418120317.811231086@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanu Malhotra <tanu.malhotra@intel.com>

commit 38518593ec55e897abda4b4be77b2ec8ec4447d1 upstream.

During warm reset device->fw_client is set to NULL. If a bus driver is
registered after this NULL setting and before new firmware clients are
enumerated by ISHTP, kernel panic will result in the function
ishtp_cl_bus_match(). This is because of reference to
device->fw_client->props.protocol_name.

ISH firmware after getting successfully loaded, sends a warm reset
notification to remove all clients from the bus and sets
device->fw_client to NULL. Until kernel v5.15, all enabled ISHTP kernel
module drivers were loaded right after any of the first ISHTP device was
registered, regardless of whether it was a matched or an unmatched
device. This resulted in all drivers getting registered much before the
warm reset notification from ISH.

Starting kernel v5.16, this issue got exposed after the change was
introduced to load only bus drivers for the respective matching devices.
In this scenario, cros_ec_ishtp device and cros_ec_ishtp driver are
registered after the warm reset device fw_client NULL setting.
cros_ec_ishtp driver_register() triggers the callback to
ishtp_cl_bus_match() to match ISHTP driver to the device and causes kernel
panic in guid_equal() when dereferencing fw_client NULL pointer to get
protocol_name.

Fixes: f155dfeaa4ee ("platform/x86: isthp_eclite: only load for matching devices")
Fixes: facfe0a4fdce ("platform/chrome: chros_ec_ishtp: only load for matching devices")
Fixes: 0d0cccc0fd83 ("HID: intel-ish-hid: hid-client: only load for matching devices")
Fixes: 44e2a58cb880 ("HID: intel-ish-hid: fw-loader: only load for matching devices")
Cc: <stable@vger.kernel.org> # 5.16+
Signed-off-by: Tanu Malhotra <tanu.malhotra@intel.com>
Tested-by: Shaunak Saha <shaunak.saha@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -241,8 +241,8 @@ static int ishtp_cl_bus_match(struct dev
 	struct ishtp_cl_device *device = to_ishtp_cl_device(dev);
 	struct ishtp_cl_driver *driver = to_ishtp_cl_driver(drv);
 
-	return guid_equal(&driver->id[0].guid,
-			  &device->fw_client->props.protocol_name);
+	return(device->fw_client ? guid_equal(&driver->id[0].guid,
+	       &device->fw_client->props.protocol_name) : 0);
 }
 
 /**



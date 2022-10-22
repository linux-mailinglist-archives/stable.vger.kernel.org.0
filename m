Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBCA6085BF
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJVHil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiJVHh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:37:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9284C253BD0;
        Sat, 22 Oct 2022 00:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26D8C60AE4;
        Sat, 22 Oct 2022 07:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9186C43149;
        Sat, 22 Oct 2022 07:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424146;
        bh=JFJnt6l5AzW/+GUVBKRpZolRl75WP0tf6bsnS/+TL9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkDp/6ble/hIN4Dt/Mg45MQEu8Mwm3s5le3OeoKXYcbfSYdMAiP3uX6u7aoVncjFc
         Cm7ucJd1/6aPNUx6m9I4T7/XE342bKwFF6WndtVdAyLfPE6zSQja9oX/N404TKfVxk
         AvMFxYLx/k8/MK8M4nw+9BPgYq1nCgmK7SutLzEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Patryk Duda <pdk@semihalf.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.19 042/717] platform/chrome: cros_ec_proto: Update version on GET_NEXT_EVENT failure
Date:   Sat, 22 Oct 2022 09:18:41 +0200
Message-Id: <20221022072422.565259619@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patryk Duda <pdk@semihalf.com>

commit f74c7557ed0d321947e8bb4e9d47c1013f8b2227 upstream.

Some EC based devices (e.g. Fingerpint MCU) can jump to RO part of the
firmware (intentionally or due to device reboot). The RO part doesn't
change during the device lifecycle, so it won't support newer version
of EC_CMD_GET_NEXT_EVENT command.

Function cros_ec_query_all() is responsible for finding maximum
supported MKBP event version. It's usually called when the device is
running RW part of the firmware, so the command version can be
potentially higher than version supported by the RO.

The problem was fixed by updating maximum supported version when the
device returns EC_RES_INVALID_VERSION (mapped to -ENOPROTOOPT). That way
the kernel will use highest common version supported by RO and RW.

Fixes: 3300fdd630d4 ("platform/chrome: cros_ec: handle MKBP more events flag")
Cc: <stable@vger.kernel.org> # 5.10+
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Patryk Duda <pdk@semihalf.com>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220802154128.21175-1-pdk@semihalf.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_proto.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -750,6 +750,7 @@ int cros_ec_get_next_event(struct cros_e
 	u8 event_type;
 	u32 host_event;
 	int ret;
+	u32 ver_mask;
 
 	/*
 	 * Default value for wake_event.
@@ -771,6 +772,37 @@ int cros_ec_get_next_event(struct cros_e
 		return get_keyboard_state_event(ec_dev);
 
 	ret = get_next_event(ec_dev);
+	/*
+	 * -ENOPROTOOPT is returned when EC returns EC_RES_INVALID_VERSION.
+	 * This can occur when EC based device (e.g. Fingerprint MCU) jumps to
+	 * the RO image which doesn't support newer version of the command. In
+	 * this case we will attempt to update maximum supported version of the
+	 * EC_CMD_GET_NEXT_EVENT.
+	 */
+	if (ret == -ENOPROTOOPT) {
+		dev_dbg(ec_dev->dev,
+			"GET_NEXT_EVENT returned invalid version error.\n");
+		ret = cros_ec_get_host_command_version_mask(ec_dev,
+							EC_CMD_GET_NEXT_EVENT,
+							&ver_mask);
+		if (ret < 0 || ver_mask == 0)
+			/*
+			 * Do not change the MKBP supported version if we can't
+			 * obtain supported version correctly. Please note that
+			 * calling EC_CMD_GET_NEXT_EVENT returned
+			 * EC_RES_INVALID_VERSION which means that the command
+			 * is present.
+			 */
+			return -ENOPROTOOPT;
+
+		ec_dev->mkbp_event_supported = fls(ver_mask);
+		dev_dbg(ec_dev->dev, "MKBP support version changed to %u\n",
+			ec_dev->mkbp_event_supported - 1);
+
+		/* Try to get next event with new MKBP support version set. */
+		ret = get_next_event(ec_dev);
+	}
+
 	if (ret <= 0)
 		return ret;
 



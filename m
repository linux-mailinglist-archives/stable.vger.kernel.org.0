Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FCD59D7D8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242597AbiHWJlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351684AbiHWJkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5FD48E8F;
        Tue, 23 Aug 2022 01:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4319361458;
        Tue, 23 Aug 2022 08:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A089C433D6;
        Tue, 23 Aug 2022 08:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244038;
        bh=t5e8m7zUSZLlKDZ0aO+vYJnddTUtFWDaqH96W3GXM0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh5P11yMlIoDuaItuE7nf+PUSBZVv/6tq+o0pfGkPUuGCLT/Ehueq8iyO2R6I980a
         nh2YSjGEzEQcoCzw4NxaH0fbwpEIoNRXd0NIT2AMDKrjpHgDAaYNVOyzYpEmosa9Bm
         xrKgtb/1sHKks29pFdB3oekcUf0cuB153LZDm/+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 027/244] can: ems_usb: fix clangs -Wunaligned-access warning
Date:   Tue, 23 Aug 2022 10:23:06 +0200
Message-Id: <20220823080059.964579394@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit a4cb6e62ea4d36e53fb3c0f18ea4503d7b76674f upstream.

clang emits a -Wunaligned-access warning on struct __packed
ems_cpc_msg.

The reason is that the anonymous union msg (not declared as packed) is
being packed right after some non naturally aligned variables (3*8
bits + 2*32) inside a packed struct:

| struct __packed ems_cpc_msg {
| 	u8 type;	/* type of message */
| 	u8 length;	/* length of data within union 'msg' */
| 	u8 msgid;	/* confirmation handle */
| 	__le32 ts_sec;	/* timestamp in seconds */
| 	__le32 ts_nsec;	/* timestamp in nano seconds */
|	/* ^ not naturally aligned */
|
| 	union {
| 	/* ^ not declared as packed */
| 		u8 generic[64];
| 		struct cpc_can_msg can_msg;
| 		struct cpc_can_params can_params;
| 		struct cpc_confirm confirmation;
| 		struct cpc_overrun overrun;
| 		struct cpc_can_error error;
| 		struct cpc_can_err_counter err_counter;
| 		u8 can_state;
| 	} msg;
| };

Starting from LLVM 14, having an unpacked struct nested in a packed
struct triggers a warning. c.f. [1].

Fix the warning by marking the anonymous union as packed.

[1] https://github.com/llvm/llvm-project/issues/55520

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Link: https://lore.kernel.org/all/20220802094021.959858-1-mkl@pengutronix.de
Cc: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>
Cc: Sebastian Haas <haas@ems-wuensche.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -194,7 +194,7 @@ struct __packed ems_cpc_msg {
 	__le32 ts_sec;	/* timestamp in seconds */
 	__le32 ts_nsec;	/* timestamp in nano seconds */
 
-	union {
+	union __packed {
 		u8 generic[64];
 		struct cpc_can_msg can_msg;
 		struct cpc_can_params can_params;



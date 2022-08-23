Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45B59D34F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbiHWINz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242140AbiHWIMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:12:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142B46BD73;
        Tue, 23 Aug 2022 01:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 187026123D;
        Tue, 23 Aug 2022 08:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12749C433D6;
        Tue, 23 Aug 2022 08:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242143;
        bh=t5e8m7zUSZLlKDZ0aO+vYJnddTUtFWDaqH96W3GXM0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eat9G/JtCA4ktfCfn9LAwxsk6mrPrNXfU1h/KGWhpek/NgXlDKTPr819ephEvkTyg
         vVe/XpITKuzrj1hN1BxuUeEmmxoyy29rtsd2yZN3LCuihYzyfYzmxh60V3LlL4oG58
         nMTV/xRDKJUDtv+3+gL/O0QEZkZ/q/GLNmeCC62c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.19 040/365] can: ems_usb: fix clangs -Wunaligned-access warning
Date:   Tue, 23 Aug 2022 09:59:01 +0200
Message-Id: <20220823080119.870866102@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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



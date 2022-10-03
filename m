Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796845F2A5E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiJCHfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiJCHef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDC452E51;
        Mon,  3 Oct 2022 00:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4D8BB808BF;
        Mon,  3 Oct 2022 07:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A598C433D6;
        Mon,  3 Oct 2022 07:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781644;
        bh=3xrLfcjB9Quar55K3szE0jM1nPIp3xL1u/a7utKu0B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4cio6DYnwGtj/v9/RhvXHpI3w8/riLfSszyzBqJSrg2g8VCpeU/NqsI6xxeQOguV
         /Ei77f4wj3xDiMbY896ztUG8mVfcJVsT7jUDXNoqiY1lxYON0RnsAdacTBFCXa31f3
         Y2yosBViIoYENHAlgEEmXTi4lxrowHuxNuuOvgkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 12/52] thunderbolt: Explicitly reset plug events delay back to USB4 spec value
Date:   Mon,  3 Oct 2022 09:11:19 +0200
Message-Id: <20221003070719.091702858@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 31f87f705b3c1635345d8e8a493697099b43e508 upstream.

If any software has interacted with the USB4 registers before the Linux
USB4 CM runs, it may have modified the plug events delay. It has been
observed that if this value too large, it's possible that hotplugged
devices will negotiate a fallback mode instead in Linux.

To prevent this, explicitly align the plug events delay with the USB4
spec value of 10ms.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2046,6 +2046,7 @@ int tb_switch_configure(struct tb_switch
 		 * additional capabilities.
 		 */
 		sw->config.cmuv = USB4_VERSION_1_0;
+		sw->config.plug_events_delay = 0xa;
 
 		/* Enumerate the switch */
 		ret = tb_sw_write(sw, (u32 *)&sw->config + 1, TB_CFG_SWITCH,



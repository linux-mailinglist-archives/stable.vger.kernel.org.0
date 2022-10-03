Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D2E5F2908
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJCHM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJCHMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:12:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90A33F1F4;
        Mon,  3 Oct 2022 00:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8139860F9A;
        Mon,  3 Oct 2022 07:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94015C433D6;
        Mon,  3 Oct 2022 07:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781137;
        bh=BgZzQqLPqIirT3vR3QB0OlreZGbOrUkEFdJUep8FaqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzksTy28ayoE1usI3I3F+IoeHc5ufDI5nwp8SqvbLXKBo0D6fgSDNwBuNe/24Hoz5
         3PG4dspifhaX6Se1+iKbj7Bgr9y2lWiRGnA5/LIY/KpZk98vlOGE1aeFqU8VQmgRGO
         0ED27qqiQQoalG+B9VV2M9qje1MX3FGxtcv9I50I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.19 011/101] thunderbolt: Explicitly reset plug events delay back to USB4 spec value
Date:   Mon,  3 Oct 2022 09:10:07 +0200
Message-Id: <20221003070724.785501424@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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
@@ -2413,6 +2413,7 @@ int tb_switch_configure(struct tb_switch
 		 * additional capabilities.
 		 */
 		sw->config.cmuv = USB4_VERSION_1_0;
+		sw->config.plug_events_delay = 0xa;
 
 		/* Enumerate the switch */
 		ret = tb_sw_write(sw, (u32 *)&sw->config + 1, TB_CFG_SWITCH,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6BD5F29EB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiJCH1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiJCH1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:27:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C14D254;
        Mon,  3 Oct 2022 00:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34BF960FA7;
        Mon,  3 Oct 2022 07:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420B2C433D6;
        Mon,  3 Oct 2022 07:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781413;
        bh=J9P75/5S0RATD9l47s7hFoGzMQDgVknonjFIUC+Vo2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2SOj6FmIVIYYuiF4NRMrJtxtTdZz981cNznAP6Vv+iy3e1RSJ5Fe4YWhj1+HkFv5
         X+/kPN3fO4zMUXFAiBzCiDsGjl1J3EvC5dPUFa4KLFHcaMTM7sY3eIcCPi85tPCo3k
         E8j6RVfydvRv0RemEzYe8Ixg0QmtAolM09UOP3o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 11/83] thunderbolt: Explicitly reset plug events delay back to USB4 spec value
Date:   Mon,  3 Oct 2022 09:10:36 +0200
Message-Id: <20221003070722.268664803@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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
@@ -2281,6 +2281,7 @@ int tb_switch_configure(struct tb_switch
 		 * additional capabilities.
 		 */
 		sw->config.cmuv = USB4_VERSION_1_0;
+		sw->config.plug_events_delay = 0xa;
 
 		/* Enumerate the switch */
 		ret = tb_sw_write(sw, (u32 *)&sw->config + 1, TB_CFG_SWITCH,



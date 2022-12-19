Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0AB65131A
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiLST1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiLST1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:27:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E166E6F
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:26:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B65E60F93
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCE3C433F1;
        Mon, 19 Dec 2022 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478011;
        bh=cFZDr3iGcfKiX9rWgBaBaE9vpKVOax1baPuaHLrzF6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQYnxBuk7iWsHWF1/fypIDSDG9gLna0Aa/6bVDCtcyI4nDxKmOT5YmtJKeg++QT/t
         NQ3TWOq+97EE3EJL+bd2qhEYiXjoQ0u7GTEaaGxliwtgE4WvI3ooTeJPXjk9DJ+trQ
         7AwRcUhd819GQOI9cFzE3LTXLPK5swx6FlePQous=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akihiko Odaki <akihiko.odaki@daynix.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 21/28] igb: Initialize mailbox message for VF reset
Date:   Mon, 19 Dec 2022 20:23:08 +0100
Message-Id: <20221219182945.105856338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
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

From: Tony Nguyen <anthony.l.nguyen@intel.com>

commit de5dc44370fbd6b46bd7f1a1e00369be54a041c8 upstream.

When a MAC address is not assigned to the VF, that portion of the message
sent to the VF is not set. The memory, however, is allocated from the
stack meaning that information may be leaked to the VM. Initialize the
message buffer to 0 so that no information is passed to the VM in this
case.

Fixes: 6ddbc4cf1f4d ("igb: Indicate failure on vf reset for empty mac address")
Reported-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221212190031.3983342-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7522,7 +7522,7 @@ static void igb_vf_reset_msg(struct igb_
 {
 	struct e1000_hw *hw = &adapter->hw;
 	unsigned char *vf_mac = adapter->vf_data[vf].vf_mac_addresses;
-	u32 reg, msgbuf[3];
+	u32 reg, msgbuf[3] = {};
 	u8 *addr = (u8 *)(&msgbuf[1]);
 
 	/* process all the same items cleared in a function level reset */



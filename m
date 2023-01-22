Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FAA676F3F
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjAVPTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjAVPTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB122004D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA1FBB80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E9BC433EF;
        Sun, 22 Jan 2023 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400757;
        bh=FX485JoELyltwI6CBgeMkqmSIouASLh9ZMnJCq/TH1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty9Q0zkEvHQD2G0qEWrGuFIHQa7UNofwrBP/PEdYzKdBJOxco0tAZh36ApPEUzB9y
         x9aMOAjmrkf0Og6kDNwoJEV5u90ZuxTLIXYxr4ArmwCb5V/FOGMbfQqlkq8oAtFUKW
         RvjX/5kyLm7+tgHSdeic9FU43WBlykAm0TLSLs+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 068/117] thunderbolt: Use correct function to calculate maximum USB3 link rate
Date:   Sun, 22 Jan 2023 16:04:18 +0100
Message-Id: <20230122150235.617270111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e8ff07fb33026c5c1bb5b81293496faba5d68059 upstream.

We need to take minimum of both sides of the USB3 link into consideration,
not just the downstream port. Fix this by calling tb_usb3_max_link_rate()
instead.

Fixes: 0bd680cd900c ("thunderbolt: Add USB3 bandwidth management")
Cc: stable@vger.kernel.org
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1262,7 +1262,7 @@ static void tb_usb3_reclaim_available_ba
 		return;
 	} else if (!ret) {
 		/* Use maximum link rate if the link valid is not set */
-		ret = usb4_usb3_port_max_link_rate(tunnel->src_port);
+		ret = tb_usb3_max_link_rate(tunnel->dst_port, tunnel->src_port);
 		if (ret < 0) {
 			tb_tunnel_warn(tunnel, "failed to read maximum link rate\n");
 			return;



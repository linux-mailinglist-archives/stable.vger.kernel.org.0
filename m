Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC5E676EB1
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjAVPNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjAVPNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:13:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409131E2A4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB894B80B0E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF08C433D2;
        Sun, 22 Jan 2023 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400395;
        bh=OFZJJFjmXKLWX06TI+ZB4nZjXpu3+R4HHckCiWzQKuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRmSBZPQyYJHEzMpAa6QbYqZKiqY+1cOOb6/Tj8X+vY5i11mFDXHQ9qaSdmH+N7+r
         hteYx2HPG/RSUGIVTVYrbSxSRPDG2v/QwB/aDfHOgQRuZv4h/b+4QG4ITmSxv7M20i
         OHNS/OeTRuYQ6e7TZXi9WWKYHaZxrvOKgbTrEOx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 59/98] thunderbolt: Use correct function to calculate maximum USB3 link rate
Date:   Sun, 22 Jan 2023 16:04:15 +0100
Message-Id: <20230122150231.973436471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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
@@ -956,7 +956,7 @@ static void tb_usb3_reclaim_available_ba
 		return;
 	} else if (!ret) {
 		/* Use maximum link rate if the link valid is not set */
-		ret = usb4_usb3_port_max_link_rate(tunnel->src_port);
+		ret = tb_usb3_max_link_rate(tunnel->dst_port, tunnel->src_port);
 		if (ret < 0) {
 			tb_tunnel_warn(tunnel, "failed to read maximum link rate\n");
 			return;



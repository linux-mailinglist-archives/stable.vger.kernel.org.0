Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6606DEF84
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjDLIvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjDLIvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B15974E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C769E628BA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E65C4339B;
        Wed, 12 Apr 2023 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289405;
        bh=4h7XxP2l6FPHUUSG7kgVsDjORIV0/8sty62BgSyJBu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMaABO/ZBFkIj5ZZCOlR3VnAcI5uZDBDNBCJcjU42iBvjGnTnBpI6KpAzWGqU3uAl
         CL5T7JStSUGLU4XsHJ/ARwRPVKMiBlTQySqOW4jyCmnDk4OiBR7agK/hM8fx94RacG
         JNh4l1XXRxRpD38b7gmKx+ORYnwzf9Otl3up/RUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 6.2 085/173] tty: serial: fsl_lpuart: fix crash in lpuart_uport_is_active
Date:   Wed, 12 Apr 2023 10:33:31 +0200
Message-Id: <20230412082841.492525782@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

commit 178e00f36f934a88682d96aa046c1f90cb6f83a7 upstream.

For serdev framework, tty->dev is a NULL pointer, lpuart_uport_is_active
calling device_may_wakeup() may cause kernel NULL pointer crash, so here
add the NULL pointer check before using it.

Fixes: 4f5cb8c5e915 ("tty: serial: fsl_lpuart: enable wakeup source for lpuart")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230323110923.24581-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2896,7 +2896,7 @@ static bool lpuart_uport_is_active(struc
 	tty = tty_port_tty_get(port);
 	if (tty) {
 		tty_dev = tty->dev;
-		may_wake = device_may_wakeup(tty_dev);
+		may_wake = tty_dev && device_may_wakeup(tty_dev);
 		tty_kref_put(tty);
 	}
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF4559486C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344918AbiHOXMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbiHOXMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:12:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CC87667;
        Mon, 15 Aug 2022 13:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 935F160FD8;
        Mon, 15 Aug 2022 20:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829FEC433C1;
        Mon, 15 Aug 2022 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593622;
        bh=cdnhM6keGBCbekNFSqz0/UM3k8voCBSTZYS+WXXc1WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unsyrNhhB0r7ctUVGJGgPxb1QvAEZoWqriUcd+FsSvc4g0MY0hI+Y6ot/j0lclWCh
         Y3RpMNs6eyx93QLaWMB1+n5ECV2OCNSRzsKHeF2vcDfnN93TkLPeXUC4U9l/64m7rB
         7iQw1st3OvzR+hNaX8pMWoiWhtB4jGn6sVW3lJE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        Xie Shaowen <studentxswpy@163.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.18 0977/1095] Input: gscps2 - check return value of ioremap() in gscps2_probe()
Date:   Mon, 15 Aug 2022 20:06:16 +0200
Message-Id: <20220815180509.534782564@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Xie Shaowen <studentxswpy@163.com>

commit e61b3125a4f036b3c6b87ffd656fc1ab00440ae9 upstream.

The function ioremap() in gscps2_probe() can fail, so
its return value should be checked.

Fixes: 4bdc0d676a643 ("remove ioremap_nocache and devm_ioremap_nocache")
Cc: <stable@vger.kernel.org> # v5.6+
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: Xie Shaowen <studentxswpy@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/gscps2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -350,6 +350,10 @@ static int __init gscps2_probe(struct pa
 	ps2port->port = serio;
 	ps2port->padev = dev;
 	ps2port->addr = ioremap(hpa, GSC_STATUS + 4);
+	if (!ps2port->addr) {
+		ret = -ENOMEM;
+		goto fail_nomem;
+	}
 	spin_lock_init(&ps2port->lock);
 
 	gscps2_reset(ps2port);



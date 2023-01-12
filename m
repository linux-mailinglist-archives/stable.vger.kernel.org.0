Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48925667797
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbjALOpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239879AbjALOpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:45:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2261259FBB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:33:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CF9B60A69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C7BC433D2;
        Thu, 12 Jan 2023 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533999;
        bh=zafvU+hyAbfGaeKEBejgUefE+wk0/vtGTxF2hYoyDoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6QcPYfZv7eu2e6QrHbdpVkvfeT4ivliWMdo8VGVWNT0eEZT0T4/QMARAu6dyG9z3
         OzFeJp9GDXOEtnYGnKKK+5mdD7vz9ZlQ7PSjFru0yKXcFM3CXtD64R0H7TTRCASrnV
         iToMefUY808Lsl13j/iA0NLpetFo0ahqORJeeOTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saravana Kannan <saravanak@google.com>,
        "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: [PATCH 5.10 660/783] driver core: Fix bus_type.match() error handling in __driver_attach()
Date:   Thu, 12 Jan 2023 14:56:16 +0100
Message-Id: <20230112135554.946762058@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 27c0d217340e47ec995557f61423ef415afba987 upstream.

When a driver registers with a bus, it will attempt to match with every
device on the bus through the __driver_attach() function. Currently, if
the bus_type.match() function encounters an error that is not
-EPROBE_DEFER, __driver_attach() will return a negative error code, which
causes the driver registration logic to stop trying to match with the
remaining devices on the bus.

This behavior is not correct; a failure while matching a driver to a
device does not mean that the driver won't be able to match and bind
with other devices on the bus. Update the logic in __driver_attach()
to reflect this.

Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Link: https://lore.kernel.org/r/20220921001414.4046492-1-isaacmanjarres@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1088,7 +1088,11 @@ static int __driver_attach(struct device
 		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
-		return ret;
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} /* ret > 0 means positive match */
 
 	if (driver_allows_async_probing(drv)) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166FE551A2A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244259AbiFTNFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244815AbiFTNEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802F1929F;
        Mon, 20 Jun 2022 05:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1AE0B811A0;
        Mon, 20 Jun 2022 12:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40453C3411B;
        Mon, 20 Jun 2022 12:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729917;
        bh=sHsXTox6zXc52iWCMVLZETrIvLTuw2UPYLMvDA+1G08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdONSvaEIES9dhW740bQYLaXRHhebA1ocJmL8xRgCGwTndChE8UvgTqNKiAJIEyXq
         IeAOYcE5Fw4NpRt2IEbl0+a0fsSUSWni5nTvpx7TXdC3GUPgvPGyVZTKpvsKbY3Oyo
         88rKv7s4mDZdGbwd5ep8+KRsdsiCpzhn9kqT4hgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.18 115/141] tty: n_gsm: Debug output allocation must use GFP_ATOMIC
Date:   Mon, 20 Jun 2022 14:50:53 +0200
Message-Id: <20220620124732.946064778@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit e74024b2eccbb784824a0f9feaeaaa3b47514b79 upstream.

Dan Carpenter <dan.carpenter@oracle.com> reported the following Smatch
warning:

drivers/tty/n_gsm.c:720 gsm_data_kick()
warn: sleeping in atomic context

This is because gsm_control_message() is holding a spin lock so
gsm_hex_dump_bytes() needs to use GFP_ATOMIC instead of GFP_KERNEL.

Fixes: 925ea0fa5277 ("tty: n_gsm: Fix packet data hex dump output")
Cc: stable <stable@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20220523155052.57129-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -455,7 +455,7 @@ static void gsm_hex_dump_bytes(const cha
 		return;
 	}
 
-	prefix = kasprintf(GFP_KERNEL, "%s: ", fname);
+	prefix = kasprintf(GFP_ATOMIC, "%s: ", fname);
 	if (!prefix)
 		return;
 	print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_OFFSET, 16, 1, data, len,



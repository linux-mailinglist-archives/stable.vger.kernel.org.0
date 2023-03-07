Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FD26AF47F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbjCGTRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjCGTQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30918AF742
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0B0961518
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5168C433EF;
        Tue,  7 Mar 2023 19:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215601;
        bh=OfCAphGqPWlbb7MAHf5cQJQpFhLLN5E3FCimHbgheq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4e09dbVyXAyEMIpBqbPSmayKNFS5WbFxwVHgTPs3T27JIYmCO1sslrzq3E9DnHKl
         030a2ttvJhTUwIpfNFdoFjTyA/FwZI1Cqf9hg7Ww1WuSb+y4ac8qAh6XdjymlMCj06
         uGb5S58cnLgElNyk7ea9UhdnBK4RcB5N91DNvbnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/567] usb: early: xhci-dbc: Fix a potential out-of-bound memory access
Date:   Tue,  7 Mar 2023 18:00:50 +0100
Message-Id: <20230307165919.478978130@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a4a97ab3db5c081eb6e7dba91306adefb461e0bd ]

If xdbc_bulk_write() fails, the values in 'buf' can be anything. So the
string is not guaranteed to be NULL terminated when xdbc_trace() is called.

Reserve an extra byte, which will be zeroed automatically because 'buf' is
a static variable, in order to avoid troubles, should it happen.

Fixes: aeb9dd1de98c ("usb/early: Add driver for xhci debug capability")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d6a7562c5e839a195cee85db6dc81817f9372cb1.1675016180.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/early/xhci-dbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/early/xhci-dbc.c b/drivers/usb/early/xhci-dbc.c
index 6c0434100e38c..b0c4071f0b167 100644
--- a/drivers/usb/early/xhci-dbc.c
+++ b/drivers/usb/early/xhci-dbc.c
@@ -871,7 +871,8 @@ static int xdbc_bulk_write(const char *bytes, int size)
 
 static void early_xdbc_write(struct console *con, const char *str, u32 n)
 {
-	static char buf[XDBC_MAX_PACKET];
+	/* static variables are zeroed, so buf is always NULL terminated */
+	static char buf[XDBC_MAX_PACKET + 1];
 	int chunk, ret;
 	int use_cr = 0;
 
-- 
2.39.2




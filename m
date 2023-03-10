Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8C56B434B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjCJOMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjCJOMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:12:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE2E11A9A9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:11:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BEECB822B9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AB5C4339B;
        Fri, 10 Mar 2023 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457475;
        bh=E9dtm9d4GQtF08b5rfr/y72R21hIOL/iumZCcyKmVjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjYsCpTJ9A3ssRlPRWcMdPLiQyq6+3jRM1geCtDhw97Lh6S16G64fjETbNRqPfXP4
         LgZWOPtOK1UUd0SZxYXy2ZQrPo3AdG/EBPbUE7KH3oe5w6NLV1ksx4Abp+fhIVmtuo
         NR7r3m4n4dWofxg90v78O7EAhDQHh/5rwW0dapIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/200] USB: isp1362: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:17 +0100
Message-Id: <20230310133721.730170579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit c26e682afc14caa87d44beed271eec8991e93c65 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20230202153235.2412790-7-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/isp1362-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 0e14d1d07709d..b0da143ef4be9 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2170,7 +2170,7 @@ static void create_debug_file(struct isp1362_hcd *isp1362_hcd)
 
 static void remove_debug_file(struct isp1362_hcd *isp1362_hcd)
 {
-	debugfs_remove(debugfs_lookup("isp1362", usb_debug_root));
+	debugfs_lookup_and_remove("isp1362", usb_debug_root);
 }
 
 /*-------------------------------------------------------------------------*/
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2555E6AA545
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjCCXDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjCCXDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:03:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED442E80E;
        Fri,  3 Mar 2023 15:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50EF8B819FD;
        Fri,  3 Mar 2023 21:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEB1C4339C;
        Fri,  3 Mar 2023 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879877;
        bh=ud9bS8BBNwLLLwu18K43YklUIaPteLlRkmPLAfIeqBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blreYikKCVAcrznSRuK2dJlZXLJZG2SYQfpn1a9ZMBOsjpZMjuRwCVOJoiYi6wnx2
         azXFUnUp8Vx4oAtkgTXzOnzSVBGtfooeEQhvKkif+8pF5DkK2Ca1qtxJ2gd3m+gdE8
         ab1KwoyD3KaqPxOLqmt2NXiYjBSC5fhRJPtvy7YPjLQFbucuuu69zi70L9jvA6NaGx
         y3uuVCy7ETpqdn/N2tTOdFv9v7TdcLgWLdOnV0iIi8fOt866COTYFxgZy0vwqTQCJX
         iNtsvkRmj7NZe5+Ke3QfJhsg06ToquqZm89tEEdVMuZPyslVABQHLudxJiYL2fjl7R
         u0CniuvZOYDFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Miaoqian Lin <linmq006@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 36/60] USB: gadget: lpc32xx_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:50 -0500
Message-Id: <20230303214315.1447666-36-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit e3965acaf3739fde9d74ad82979b46d37c6c208f ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-10-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index cea10cdb83ae5..fe62db32dd0eb 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -532,7 +532,7 @@ static void create_debug_file(struct lpc32xx_udc *udc)
 
 static void remove_debug_file(struct lpc32xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(debug_filename, NULL));
+	debugfs_lookup_and_remove(debug_filename, NULL);
 }
 
 #else
-- 
2.39.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158076AA222
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjCCVqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjCCVo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E646265C63;
        Fri,  3 Mar 2023 13:44:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA05F61919;
        Fri,  3 Mar 2023 21:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A685C433EF;
        Fri,  3 Mar 2023 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879754;
        bh=ud9bS8BBNwLLLwu18K43YklUIaPteLlRkmPLAfIeqBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XD9cvrbgtls3CdF7Cg12q6OS0RsOgXpi9e9lbSX7GSIkkPmnIfp7fFmeDQfR+XJ/4
         +YX4FtRFPTmnBBWfylJl/3uoLp96QMZ9t0nlXBaQ/+DodC6wMKB9gRkWuwSxD7t6z6
         69Yv2tfXj0ujPjA6L7fz/nx5wkXZ6dJnomZRwCb8CyU5TAEzTo5C1HsmcvTRhZeQTf
         vZG7mBR2cZUzZN94dEBfRBSTJNAhwcwQlBGO7VQCBNwnwI6C1anw47CwCU+7DFhvy1
         c3LQKymR7IRr9w70psrPTgKEhXM+8VyBxETMsTG4ngQQ1GmAuMT/xT05VV5qpRlIeY
         64CKSzKuMoCbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Miaoqian Lin <linmq006@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 40/64] USB: gadget: lpc32xx_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:40:42 -0500
Message-Id: <20230303214106.1446460-40-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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


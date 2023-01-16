Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B5E66C7B7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbjAPQeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjAPQdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:33:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE92521953
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75D9D61041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7E1C433D2;
        Mon, 16 Jan 2023 16:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886069;
        bh=2KndtAhOkAJrzwFY49r5OkKk0ML9BK70QC9mRXvqCng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mtxx1bU0mLBRSSuVjbzppe3h0ikivNfZMWOymWAxa+avQtQauFgGxFp1RfU0Fm6TL
         0R/yhUyE99f7OWoGrwEbyRNYiaPKCWBwxs0UwhCxhxTSTx+JQ0HS2sv8leK1JJ/6uz
         i4QeIpEQglzaWOEnrfWEaWopY3buOHf2HqG1b558=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 283/658] usb: typec: Check for ops->exit instead of ops->enter in altmode_exit
Date:   Mon, 16 Jan 2023 16:46:11 +0100
Message-Id: <20230116154922.524640504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit b6ddd180e3d9f92c1e482b3cdeec7dda086b1341 ]

typec_altmode_exit checks if ops->enter is not NULL but then calls
ops->exit a few lines below. Fix that and check for the function
pointer it's about to call instead.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114165924.33487-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
index c950171556d8..0369ad92a1c8 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -126,7 +126,7 @@ int typec_altmode_exit(struct typec_altmode *adev)
 	if (!adev || !adev->active)
 		return 0;
 
-	if (!pdev->ops || !pdev->ops->enter)
+	if (!pdev->ops || !pdev->ops->exit)
 		return -EOPNOTSUPP;
 
 	/* Moving to USB Safe State */
-- 
2.35.1




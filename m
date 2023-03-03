Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8036AA3D4
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjCCWIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbjCCWIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:08:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8096B5CA;
        Fri,  3 Mar 2023 13:58:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 020E8618EF;
        Fri,  3 Mar 2023 21:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F82C4339B;
        Fri,  3 Mar 2023 21:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879982;
        bh=XpyjYdKvWPBnU6vlnDaEnzH6dHN5Ax1fBwYFy3tqwnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIGaWxvtrOG1Jo0G/CXAnt1WCzEOhaFdtBAV8ZpFq1ZSUVWXvB5Iv7LMeNAWS9Atz
         pWaLf2aJiGqvrqs0pe5v7+H9ZL2z1bM//bSogaWvw6zBkNjEXbsm+gzRYp8xU+Tbzz
         TMLUirLbLcCxPRHSzFKggfBRNc85Yq670EAuiLZccnHb9CPLrSVS9Gb78ghdmI8dq2
         PaW9T4jgeou4/f7l/cYbA2SU9zfj+kiGyIq9Es+xJ2BmmevbQu9b9jgiV+TRcFgsBj
         nyojDtT6fY+R8bICO6Hkd+sK//TziZVnT9jNCY+sOVPWjZLKNRHH8D2jOQAz8X3Gon
         hDFf9iYQPSMlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/50] USB: sl811: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:05 -0500
Message-Id: <20230303214531.1450154-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
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

[ Upstream commit e1523c4dbc54e164638ff8729d511cf91e27be04 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20230202153235.2412790-4-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/sl811-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 85623731a5162..825ff67273102 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1501,7 +1501,7 @@ static void create_debug_file(struct sl811 *sl811)
 
 static void remove_debug_file(struct sl811 *sl811)
 {
-	debugfs_remove(debugfs_lookup("sl811h", usb_debug_root));
+	debugfs_lookup_and_remove("sl811h", usb_debug_root);
 }
 
 /*-------------------------------------------------------------------------*/
-- 
2.39.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5A76AA23C
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjCCVqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjCCVpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:45:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC0B64263;
        Fri,  3 Mar 2023 13:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA3661935;
        Fri,  3 Mar 2023 21:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAA5C4339B;
        Fri,  3 Mar 2023 21:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879852;
        bh=FUCWLS/7vbF+P+R1E0PQ2GUZNu+Szjwa/c5dSR33D+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLhadH+DFiu2YcpuCXIUFD7cnSB6q/K9+aO6LgEwWgJshJb0+m6AOchfG9YaJVhgw
         XHJhHXd27GY8Bg5IEvWamqdtffn0k/O2QvDMUih8X7E562MHICskvHhAI5bB+uLtf0
         6/aT6dQcrmsScvlaDep1VuWxIhqXaJcYSGduhDgB9fcXK+AA4dwc0Ds69QzEqW2AUd
         tKcnKcecNuxuDMMMSmGgv3wnrlKUHSH5QoJRrqOVoowFoAwffIfa7Mvagk4ZakaMXR
         /vs67aRJxXDVJZG/ThWf45O9jPSF38YeAqJc9+Nr+ZlJgRVRSqh9ZsJ2c50SMtSkzK
         5poN2v2dC1qRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 27/60] USB: chipidea: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:41 -0500
Message-Id: <20230303214315.1447666-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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

[ Upstream commit ff35f3ea3baba5b81416ac02d005cfbf6dd182fa ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230202153235.2412790-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index faf6b078b6c44..bbc610e5bd69c 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -364,5 +364,5 @@ void dbg_create_files(struct ci_hdrc *ci)
  */
 void dbg_remove_files(struct ci_hdrc *ci)
 {
-	debugfs_remove(debugfs_lookup(dev_name(ci->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(ci->dev), usb_debug_root);
 }
-- 
2.39.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CB16B4ADF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbjCJP10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbjCJP1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:27:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53F47C3F1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04B461A2D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BDDC433D2;
        Fri, 10 Mar 2023 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461324;
        bh=YX/21BYrmjlYFBFWNNqTXN4rfX0UhjUGZkGvfSZuZ9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYCYkW5Ou2b90kp/jsMNBPTJvVv4AacblwLgVNLADoclDKByshU86TliLsXkJki1w
         Zb7NySx9z0CRHxacuewsw1yh3+Cgk9UQqj5DjlQgFHiVMkZAkeVoc/H3jRjkEDsGVR
         6mlzQXUNY7oY1E4XWIWforDMyzjopMxe1qjA8gYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/136] USB: fotg210: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:43:42 +0100
Message-Id: <20230310133710.178322261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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

[ Upstream commit 6b4040f452037a7e95472577891d57c6b18c89c5 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230202153235.2412790-5-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fotg210-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 4b02ace09f3dc..d9a3fd8af7a01 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -862,7 +862,7 @@ static inline void remove_debug_files(struct fotg210_hcd *fotg210)
 {
 	struct usb_bus *bus = &fotg210_to_hcd(fotg210)->self;
 
-	debugfs_remove(debugfs_lookup(bus->bus_name, fotg210_debug_root));
+	debugfs_lookup_and_remove(bus->bus_name, fotg210_debug_root);
 }
 
 /* handshake - spin reading hc until handshake completes or fails
-- 
2.39.2




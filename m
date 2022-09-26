Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAF35EA2C3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbiIZLOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiIZLNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF57762A8F;
        Mon, 26 Sep 2022 03:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D631A60B4A;
        Mon, 26 Sep 2022 10:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3B6C433D6;
        Mon, 26 Sep 2022 10:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188571;
        bh=/LwboeMHQ9jjCKQzk1kISly+XMNQ5oJ0citGDmjs+oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyCgzlot1JhVZhd0QMzZqT3vO9gD1mOmoF94MAmKXCxcgXurmtMDBwJNTjRiKD8eM
         b9s+EKPqhnGohBY5sgKBMVhdEUcB71QNX0+pwx01gFovJTY9pOxDwYCeYrUo/P7xuN
         zXnVQlOBbuh1AyMDWYmOeU+cWU8TzbTu8yHzhq80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 020/148] USB: core: Fix RST error in hub.c
Date:   Mon, 26 Sep 2022 12:10:54 +0200
Message-Id: <20220926100756.824063971@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 766a96dc558385be735a370db867e302c8f22153 upstream.

A recent commit added an invalid RST expression to a kerneldoc comment
in hub.c.  The fix is trivial.

Fixes: 9c6d778800b9 ("USB: core: Prevent nested device-reset calls")
Cc: <stable@vger.kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YxDDcsLtRZ7c20pq@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -6044,7 +6044,7 @@ re_enumerate_no_bos:
  *
  * Return: The same as for usb_reset_and_verify_device().
  * However, if a reset is already in progress (for instance, if a
- * driver doesn't have pre_ or post_reset() callbacks, and while
+ * driver doesn't have pre_reset() or post_reset() callbacks, and while
  * being unbound or re-bound during the ongoing reset its disconnect()
  * or probe() routine tries to perform a second, nested reset), the
  * routine returns -EINPROGRESS.



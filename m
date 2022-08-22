Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE1359BC95
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiHVJRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiHVJRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:17:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4571115E
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 02:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB163B80EF2
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 09:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137CEC433C1;
        Mon, 22 Aug 2022 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661159830;
        bh=1OpYerxaqOfX+vPksrg5XdAV6kHZnpcVzuiCUzqe6E4=;
        h=Subject:To:Cc:From:Date:From;
        b=n0zsZgmdNdL4wJKpAf8ZaiU3mjNiz+Ah0XA2PWRHAQf7/AV0a22f9XCn3ia6xqbKc
         beYOvKZdTI6yjA1yLPEUJqSgY6W+US2r2j5eMEBsvDs4AmYum/kZMamhn6oAF04DCA
         8Sjxn5Q/Wqul6VK8wDx6SS5cvY5YWGqoCO1ADpX8=
Subject: FAILED: patch "[PATCH] NTB: ntb_tool: uninitialized heap data in tool_fn_write()" failed to apply to 4.14-stable tree
To:     dan.carpenter@oracle.com, jdmason@kudzu.us
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 11:16:42 +0200
Message-ID: <166115980236194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 45e1058b77feade4e36402828bfe3e0d3363177b Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 20 Jul 2022 21:28:18 +0300
Subject: [PATCH] NTB: ntb_tool: uninitialized heap data in tool_fn_write()

The call to:

	ret = simple_write_to_buffer(buf, size, offp, ubuf, size);

will return success if it is able to write even one byte to "buf".
The value of "*offp" controls which byte.  This could result in
reading uninitialized data when we do the sscanf() on the next line.

This code is not really desigined to handle partial writes where
*offp is non-zero and the "buf" is preserved and re-used between writes.
Just ban partial writes and replace the simple_write_to_buffer() with
copy_from_user().

Fixes: 578b881ba9c4 ("NTB: Add tool test client")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>

diff --git a/drivers/ntb/test/ntb_tool.c b/drivers/ntb/test/ntb_tool.c
index b7bf3f863d79..5ee0afa621a9 100644
--- a/drivers/ntb/test/ntb_tool.c
+++ b/drivers/ntb/test/ntb_tool.c
@@ -367,14 +367,16 @@ static ssize_t tool_fn_write(struct tool_ctx *tc,
 	u64 bits;
 	int n;
 
+	if (*offp)
+		return 0;
+
 	buf = kmalloc(size + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = simple_write_to_buffer(buf, size, offp, ubuf, size);
-	if (ret < 0) {
+	if (copy_from_user(buf, ubuf, size)) {
 		kfree(buf);
-		return ret;
+		return -EFAULT;
 	}
 
 	buf[size] = 0;


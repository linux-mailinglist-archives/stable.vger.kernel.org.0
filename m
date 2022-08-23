Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B4659DED7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiHWMNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240207AbiHWMNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:13:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BE2E42F9;
        Tue, 23 Aug 2022 02:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C264561460;
        Tue, 23 Aug 2022 09:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A60C433C1;
        Tue, 23 Aug 2022 09:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247504;
        bh=UfA2D+Yn9Vkzxi9TLQAdixu5obpAF7LAI9CvtDbERPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ej1JgRVCZvZbIGqYUkIdX2gbLgxdyMLmrEQyf4+deSyUfj1+wzEUwJZsRfA1VlWGn
         c7SyGr9nS6NEdpOXq1+/tFUkSuosaFjCRc1vR5yI1hhGdbivILATyP4kYyFEArtRTu
         HnOfHhSauuk4ps8/bgY6m168ySXah7x0CwmwCEq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.10 057/158] NTB: ntb_tool: uninitialized heap data in tool_fn_write()
Date:   Tue, 23 Aug 2022 10:26:29 +0200
Message-Id: <20220823080048.389818110@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 45e1058b77feade4e36402828bfe3e0d3363177b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/test/ntb_tool.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/ntb/test/ntb_tool.c
+++ b/drivers/ntb/test/ntb_tool.c
@@ -367,14 +367,16 @@ static ssize_t tool_fn_write(struct tool
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



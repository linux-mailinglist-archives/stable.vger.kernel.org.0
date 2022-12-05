Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB89643157
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiLETOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbiLETNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:13:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297541F2F9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7F276130B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84E3C433D7;
        Mon,  5 Dec 2022 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267628;
        bh=RaN0rz4QkZYvnSrfkoyhWbOXmcWVT/v6ZH0psLftSJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5+mfDazqZkmfYa1yocuHVg4wGPWY5/9Y3rogJkCx3qmoImJf/Mkvtr0UQifrNKWw
         iJUf6tEtutJFLfVg/c88i07cMBTh3+zX/nQp+5OdZU+X/4s5ceZyuaDL+sG2tEVWBn
         O9lrz4uj3tRbRiLfM6CF6yvZG1bpqSnb/JpNBP0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ulrich Hecht <uli+cip@fpond.eu>
Subject: [PATCH 4.9 56/62] Revert "fbdev: fb_pm2fb: Avoid potential divide by zero error"
Date:   Mon,  5 Dec 2022 20:09:53 +0100
Message-Id: <20221205190800.194717678@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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

From: Ulrich Hecht <uli+cip@fpond.eu>

This reverts commit 6577e903a9e193ad70f2db92eba57c4f335afd1a. It's a
duplicate of a commit that is already in this tree
(0f1174f4972ea9fad6becf8881d71adca8e9ca91).

Signed-off-by: Ulrich Hecht <uli+cip@fpond.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pm2fb.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -619,11 +619,6 @@ static int pm2fb_check_var(struct fb_var
 		return -EINVAL;
 	}
 
-	if (!var->pixclock) {
-		DPRINTK("pixclock is zero\n");
-		return -EINVAL;
-	}
-
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));



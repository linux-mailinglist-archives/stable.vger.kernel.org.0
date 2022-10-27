Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64F460FDBC
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiJ0Q63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiJ0Q62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1700016D8BA
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D0CC623EC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F83C433D6;
        Thu, 27 Oct 2022 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889907;
        bh=pEjoXFLzwBOzGkb5od/GN6OwHCtgQZw+Phbg6TJLxaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoVOSta7/0pn/IQ7vTFzpkQkSdIrCJCpiyXmwKauK9K02wyP9PGOqSrOC3aSlZ1on
         /Wn8fI9nF/bAV+t7RprqRhQfuvwPuXdWWQ3IwmIfg51Mi+DZZ4nE/ybA6uoAlhXYt7
         PLtIXR5/Xts9i5dI2S790AJ6S4rXxlvEwXEhru8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaobo Liu <cppcoffee@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 43/94] net/atm: fix proc_mpc_write incorrect return value
Date:   Thu, 27 Oct 2022 18:54:45 +0200
Message-Id: <20221027165058.868614488@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaobo Liu <cppcoffee@gmail.com>

[ Upstream commit d8bde3bf7f82dac5fc68a62c2816793a12cafa2a ]

Then the input contains '\0' or '\n', proc_mpc_write has read them,
so the return value needs +1.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/mpoa_proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 829db9eba0cb..aaf64b953915 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -219,11 +219,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (!page)
 		return -ENOMEM;
 
-	for (p = page, len = 0; len < nbytes; p++, len++) {
+	for (p = page, len = 0; len < nbytes; p++) {
 		if (get_user(*p, buff++)) {
 			free_page((unsigned long)page);
 			return -EFAULT;
 		}
+		len += 1;
 		if (*p == '\0' || *p == '\n')
 			break;
 	}
-- 
2.35.1




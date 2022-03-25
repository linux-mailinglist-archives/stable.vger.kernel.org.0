Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BFE4E7687
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344617AbiCYPP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376496AbiCYPNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:13:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3045BD12;
        Fri, 25 Mar 2022 08:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BCB8B82889;
        Fri, 25 Mar 2022 15:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A67C340E9;
        Fri, 25 Mar 2022 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220988;
        bh=3blvbOJ/SC66Hgz1697krpEydocZp9jkAp2w2f2xFwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZg4ID+/T3oItDohyEA56GfN7f/BxiDOSGJYUrH3hK7zMsyk53Gd+4BRyCHqS697l
         NR440jPn2C1uXSqCudL14NxXaVijKY6bl0WWlS48LhedFp0vNmg0hvxa0JZpZNXfkO
         s3b1KXv0n7kp0cu0+I1ie/lus9wu9437GClyfGDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Li <chenli@uniontech.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10 03/38] exfat: avoid incorrectly releasing for root inode
Date:   Fri, 25 Mar 2022 16:04:47 +0100
Message-Id: <20220325150419.858945508@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Li <chenli@uniontech.com>

commit 839a534f1e853f1aec100d06040c0037b89c2dc3 upstream.

In d_make_root, when we fail to allocate dentry for root inode,
we will iput root inode and returned value is NULL in this function.

So we do not need to release this inode again at d_make_root's caller.

Signed-off-by: Chen Li <chenli@uniontech.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -690,7 +690,7 @@ static int exfat_fill_super(struct super
 	if (!sb->s_root) {
 		exfat_err(sb, "failed to get the root dentry");
 		err = -ENOMEM;
-		goto put_inode;
+		goto free_table;
 	}
 
 	return 0;



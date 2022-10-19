Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A1D6042B6
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiJSLIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiJSLI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:08:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFACC17C54C;
        Wed, 19 Oct 2022 03:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8C59B8239F;
        Wed, 19 Oct 2022 09:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C54C433B5;
        Wed, 19 Oct 2022 09:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170401;
        bh=+NwEIh0CKLU+P0/6RuqD9Lvp0NWwOKt/Z49Pb8qKbWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+T1nxJKfd6c8vze6LZXnj3cEaI7TiDn4PaAlbMlvn9X0P18yGrd21MKJS64oH56i
         rg2mwdKJZKcyYzOSUp2/Kz2b6v+mVSgucqn3bT2aBtwLlbrrd8Gq/yxY7oQegphEKF
         /cS4QgrIQ9dOdgrOIPepA0aj0EheDQhUPr0O11Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 606/862] ipc: mqueue: fix possible memory leak in init_mqueue_fs()
Date:   Wed, 19 Oct 2022 10:31:33 +0200
Message-Id: <20221019083316.717671409@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit c579d60f0d0cd87552f64fdebe68b5d941d20309 ]

commit db7cfc380900 ("ipc: Free mq_sysctls if ipc namespace creation
failed")

Here's a similar memory leak to the one fixed by the patch above.
retire_mq_sysctls need to be called when init_mqueue_fs fails after
setup_mq_sysctls.

Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lkml.kernel.org/r/20220715062301.19311-1-hbh25y@gmail.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index f98de32aeea1..9cf314b3f079 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1746,6 +1746,7 @@ static int __init init_mqueue_fs(void)
 	unregister_filesystem(&mqueue_fs_type);
 out_sysctl:
 	kmem_cache_destroy(mqueue_inode_cachep);
+	retire_mq_sysctls(&init_ipc_ns);
 	return error;
 }
 
-- 
2.35.1




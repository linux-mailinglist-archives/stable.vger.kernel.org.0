Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8496088D8
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiJVIXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbiJVIVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:21:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774C146DAF;
        Sat, 22 Oct 2022 00:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCFC8B82E2E;
        Sat, 22 Oct 2022 07:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D7DC433D6;
        Sat, 22 Oct 2022 07:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425503;
        bh=6WiXUIWdNpTJTFRKsmuUuF0DqLK4FwROa9QJifzyzlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNvstZjkZyO/LdRxKWbaNCxOKH3bXM3F/6WH2NeasAzHnOs58/0+2zc66QOyfInTQ
         J9YPf3yVbKjHKKg2YqNlAtJAq/gb3dd+SFL0GBCr2zNpWtG12YDUvn+I2xGGXnMu5y
         GT89+ns63CipFZTrqH1mEysxqVeceKYCzrgAAlyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 492/717] ipc: mqueue: fix possible memory leak in init_mqueue_fs()
Date:   Sat, 22 Oct 2022 09:26:11 +0200
Message-Id: <20221022072520.065627399@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 12ad7860bb88..83370fef8879 100644
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




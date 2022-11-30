Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B08163DF01
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiK3Sm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiK3Smn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:42:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FB51BEAE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F1ADB81CA2
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9452C433C1;
        Wed, 30 Nov 2022 18:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833759;
        bh=2SKjAlkTzfz+gVf6+kacCL/BLdPqrrHctYG/wPi0w7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHHgP3NRVsDKuSJEREItcNFV8ZQBRSsCRc7vx2/honRmo7xMmraEN/EfMNlf5RJdo
         UXT9BuU418wljebYqvC5CQMcFolUNuVqkBvKd8L8nrKMyUzMSOVAWi736bes2OYcCY
         BNfcL30bbjoGY6tPyMtWWHEINmaUMfGjSt89W8OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 201/206] btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()
Date:   Wed, 30 Nov 2022 19:24:13 +0100
Message-Id: <20221130180538.134158321@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

commit ffdbb44f2f23f963b8f5672e35c3a26088177a62 upstream.

Although kset_unregister() can eventually remove all attribute files,
explicitly rolling back with the matching function makes the code logic
look clearer.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/sysfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -2035,8 +2035,11 @@ int __init btrfs_init_sysfs(void)
 
 #ifdef CONFIG_BTRFS_DEBUG
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_debug_feature_attr_group);
-	if (ret)
-		goto out2;
+	if (ret) {
+		sysfs_unmerge_group(&btrfs_kset->kobj,
+				    &btrfs_static_feature_attr_group);
+		goto out_remove_group;
+	}
 #endif
 
 	return 0;



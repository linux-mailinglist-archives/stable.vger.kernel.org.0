Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61E6566BE5
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiGEMJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiGEMIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3C18E34;
        Tue,  5 Jul 2022 05:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2810C6196E;
        Tue,  5 Jul 2022 12:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA24C341C7;
        Tue,  5 Jul 2022 12:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022882;
        bh=MBJP8763CP6eiBBT5O2UGaORmhp+Lsz7FI9nKnKSilo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6D+S0fzcZjs5ewYNcNRYwlTaVW9FDP/HdvCEWi6rPvjT4sxqNZRpG0jfqEtreaCU
         lPnOO/+/MwLZWJJ40S7SXUIsXCpERRVFcMBwYGla588wFn5L2f+kQhPe/CZwosPMMQ
         oAvv/aR436JDeCJAwf7LBkvxl/6+MkeNDK/+8K+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 45/84] xfs: fix xfs_trans slab cache name
Date:   Tue,  5 Jul 2022 13:58:08 +0200
Message-Id: <20220705115616.639475839@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Iliopoulos <ailiop@suse.com>

commit 25dfa65f814951a33072bcbae795989d817858da upstream.

Removal of kmem_zone_init wrappers accidentally changed a slab cache
name from "xfs_trans" to "xf_trans". Fix this so that userspace
consumers of /proc/slabinfo and /sys/kernel/slab can find it again.

Fixes: b1231760e443 ("xfs: Remove slab init wrappers")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1934,7 +1934,7 @@ xfs_init_zones(void)
 	if (!xfs_ifork_zone)
 		goto out_destroy_da_state_zone;
 
-	xfs_trans_zone = kmem_cache_create("xf_trans",
+	xfs_trans_zone = kmem_cache_create("xfs_trans",
 					   sizeof(struct xfs_trans),
 					   0, 0, NULL);
 	if (!xfs_trans_zone)



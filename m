Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626416AF19B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjCGSpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbjCGSpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:45:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C813AAD033
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:35:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BA766152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FFFC433D2;
        Tue,  7 Mar 2023 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214015;
        bh=gfRlo4YFg8bSFzFPjhGJLXLES0gbHRs/xxajiyVKsVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDCJ8oY/HQnQmtf1gWMN3nNXd0r3ZlyI3hki6QACJ1yHTbtk3Tlqkagjbb5+xdjYL
         v3/wM0GRHs+Zoit+GPRHm7nGqPjSipZ1eMrIYlXXVpWmpbQ7hCSkjcG2FRQukJ6TCO
         KtxWdC9Awm/YNy2i7GFsntTaSpL13cuo8VDZyy0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 693/885] exfat: redefine DIR_DELETED as the bad cluster number
Date:   Tue,  7 Mar 2023 18:00:27 +0100
Message-Id: <20230307170032.210318922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sungjong Seo <sj1557.seo@samsung.com>

commit bdaadfd343e3cba49ad0b009ff4b148dad0fa404 upstream.

When a file or a directory is deleted, the hint for the cluster of
its parent directory in its in-memory inode is set as DIR_DELETED.
Therefore, DIR_DELETED must be one of invalid cluster numbers. According
to the exFAT specification, a volume can have at most 2^32-11 clusters.
However, DIR_DELETED is wrongly defined as 0xFFFF0321, which could be
a valid cluster number. To fix it, let's redefine DIR_DELETED as
0xFFFFFFF7, the bad cluster number.

Fixes: 1acf1a564b60 ("exfat: add in-memory and on-disk structures and headers")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/exfat_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -41,7 +41,7 @@ enum {
 #define ES_2_ENTRIES		2
 #define ES_ALL_ENTRIES		0
 
-#define DIR_DELETED		0xFFFF0321
+#define DIR_DELETED		0xFFFFFFF7
 
 /* type values */
 #define TYPE_UNUSED		0x0000



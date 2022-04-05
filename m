Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893824F3460
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350285AbiDEJ5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238821AbiDEJQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4443BD1CCC;
        Tue,  5 Apr 2022 02:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE601B81A12;
        Tue,  5 Apr 2022 09:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A30AC385A0;
        Tue,  5 Apr 2022 09:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149305;
        bh=c4RVyvYRsj9YXVP3ghCAxHj+YV5+ROVijwrQU5DYrUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bnFFliwoRLqJGWIFTkqzDx8GPEo2eRxhf6S5f7Jp1KpEtAfLMnomicvgMGB9CvM5
         nWW1Dndu6CSp0V3jvXQ5OjHUoxdhwkEA9w+9RkpdBDPEJOXs+fB1/U3MbZLWVNB+xl
         TUmVgerJj1mPiG5BGRxZj95JSuekEKR0yYf34l1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0667/1017] NFS: Use of mapping_set_error() results in spurious errors
Date:   Tue,  5 Apr 2022 09:26:20 +0200
Message-Id: <20220405070414.081004263@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6c984083ec2453dfd3fcf98f392f34500c73e3f2 ]

The use of mapping_set_error() in conjunction with calls to
filemap_check_errors() is problematic because every error gets reported
as either an EIO or an ENOSPC by filemap_check_errors() in functions
such as filemap_write_and_wait() or filemap_write_and_wait_range().
In almost all cases, we prefer to use the more nuanced wb errors.

Fixes: b8946d7bfb94 ("NFS: Revalidate the file mapping on all fatal writeback errors")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 9b7619ce17a7..7a23b4644507 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -315,7 +315,10 @@ static void nfs_mapping_set_error(struct page *page, int error)
 	struct address_space *mapping = page_file_mapping(page);
 
 	SetPageError(page);
-	mapping_set_error(mapping, error);
+	filemap_set_wb_err(mapping, error);
+	if (mapping->host)
+		errseq_set(&mapping->host->i_sb->s_wb_err,
+			   error == -ENOSPC ? -ENOSPC : -EIO);
 	nfs_set_pageerror(mapping);
 }
 
-- 
2.34.1




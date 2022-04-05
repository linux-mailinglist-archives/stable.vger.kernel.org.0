Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BFF4F3482
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbiDEI06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239406AbiDEIUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B408F989;
        Tue,  5 Apr 2022 01:12:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F9A660AFB;
        Tue,  5 Apr 2022 08:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93431C385A0;
        Tue,  5 Apr 2022 08:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146360;
        bh=ylwCQIZNfgvvrGBmkmEPItXjHwJURBiYmINh6czOb5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyC1/vuHz+iVs4Zq9vSXXkWV6c1JqgoBZ3lOhwm1mmFXgR1mhY416lSXKQxIHjJJ7
         e64HTpuEjf0I1WmD2uUmxIqY5Zb6uzfhwyaEgfRgStjZN5DfjJnpuwucOVNlSMJuDT
         Wgd6JPMmHL1G+v0069i3HvUJ9X4OrLz3bJ9z/HAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0736/1126] NFS: Use of mapping_set_error() results in spurious errors
Date:   Tue,  5 Apr 2022 09:24:43 +0200
Message-Id: <20220405070429.192529937@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 987a187bd39a..da7e57645dcf 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -316,7 +316,10 @@ static void nfs_mapping_set_error(struct page *page, int error)
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




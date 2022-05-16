Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD5C528E8A
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiEPTtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346182AbiEPTsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:48:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CC342EF8;
        Mon, 16 May 2022 12:44:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06389B81618;
        Mon, 16 May 2022 19:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597F4C385AA;
        Mon, 16 May 2022 19:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730285;
        bh=Br3lB6GtFz/MXTAndSiBppGFrOKcpvhd6MgDFSkSPQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGXqZvTUDU0ixYf1mtFy6We7g7RN0Njk/jSuqotCUTOVhsbRGzKnIuXcJaaIVgrJ4
         F7Dw4Vv7xpRuCxe01EMtykiqKymYSlx0Rh++6sXOU+Dr156MsFPRvSYW8uAfP+EkPJ
         ZumQg4tYG++4Lp5oW86QcpbicNYyiCJu7McZt16Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan.aloni@vastdata.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/66] nfs: fix broken handling of the softreval mount option
Date:   Mon, 16 May 2022 21:36:16 +0200
Message-Id: <20220516193619.887269240@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan.aloni@vastdata.com>

[ Upstream commit 085d16d5f949b64713d5e960d6c9bbf51bc1d511 ]

Turns out that ever since this mount option was added, passing
`softreval` in NFS mount options cancelled all other flags while not
affecting the underlying flag `NFS_MOUNT_SOFTREVAL`.

Fixes: c74dfe97c104 ("NFS: Add mount option 'softreval'")
Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 05b39e8f97b9..d60c086c6e9c 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -476,7 +476,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		if (result.negated)
 			ctx->flags &= ~NFS_MOUNT_SOFTREVAL;
 		else
-			ctx->flags &= NFS_MOUNT_SOFTREVAL;
+			ctx->flags |= NFS_MOUNT_SOFTREVAL;
 		break;
 	case Opt_posix:
 		if (result.negated)
-- 
2.35.1




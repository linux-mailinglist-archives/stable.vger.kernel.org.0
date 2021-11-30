Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92A14637A8
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhK3Oz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242912AbhK3Ox1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998FCC061399;
        Tue, 30 Nov 2021 06:48:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5BE4CE1A3B;
        Tue, 30 Nov 2021 14:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FFAC53FCD;
        Tue, 30 Nov 2021 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283731;
        bh=FRi5dsC27p9HD4piJU2LSXegq6lq0R5jmMM/g+XQRng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sO536xbOxReBXBEly/ygCobxCvV2KKgUyp7gpBH8vXc9COAknL2ja3K0os2OvHXVU
         3d4LisAjFhjbAYAn0uRiO5Ckk+5CQnKYjjxvNBlPNCf7+09X8cmYaBtSQSXsq2ND8W
         eI0QpzJpCkuz2RFTBcY45GThYudliQaVPdUMVH3gI6W5PxkqT0Qv5Qwmu2syKGMLCb
         q5c/rV2fo7i+1o06fPhwsU7FzyDMKU+2oFewbt/gX9rDX4+sL76cqkOaMGZhDE/vhr
         5I4/C2idy1xrgHWdH2BnAWvyqHAEEGwkuwlHhJ804V6UcvmD2pXhjRegB5wnN5FZt2
         3rlrSNGsaVslw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 38/68] cifs: populate server_hostname for extra channels
Date:   Tue, 30 Nov 2021 09:46:34 -0500
Message-Id: <20211130144707.944580-38-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 5112d80c162f456b3956dd4f5c58e9f0c6498516 ]

Recently, a new field got added to the smb3_fs_context struct
named server_hostname. While creating extra channels, pick up
this field from primary channel.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/sess.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 23e02db7923f6..dfa4ee7eda9a7 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -204,6 +204,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	/* Auth */
 	ctx.domainauto = ses->domainAuto;
 	ctx.domainname = ses->domainName;
+	ctx.server_hostname = ses->server->hostname;
 	ctx.username = ses->user_name;
 	ctx.password = ses->password;
 	ctx.sectype = ses->sectype;
-- 
2.33.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6FB348F0F
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCYLZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhCYLZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C104961A31;
        Thu, 25 Mar 2021 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671524;
        bh=5YJl6L9oXrrCDxxPTrxzhW1TMVxXP40JoRhfG+XLU+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M64e/dJsDf7Q3JWkmSib8SaZJVEpPcVUY980IZ66K3SP9YWv/nA80wbS+XgWmrjHi
         Wj5+B4fqXiKPmCv/ogwjmBhGe3xNWJT7hZMeU0XZqnmkIp/d0k0fINm0BScVye9ZpQ
         iqs5zQ8Xr8DW3otUoaztKu/8tDl079L5DprBPpkPQjFvxGpGSIuuguuYJHbxRuSqRh
         MaLJH15KG5uY36ykqoX9cT9ctf/CvlMv9YZ0+SsRFzL5itGksv/WOFFcK5VMYew7Nx
         xln2SEeEOYeh3oNSV6BzpmFsVUKc6S8Jpt/nDDlH0h4xcsmFmBxHU8ae9wk7yyt7YS
         hyFk2MwnkRgFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Bruce Fields <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 19/44] NFSD: fix error handling in NFSv4.0 callbacks
Date:   Thu, 25 Mar 2021 07:24:34 -0400
Message-Id: <20210325112459.1926846-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit b4250dd868d1b42c0a65de11ef3afbee67ba5d2f ]

When the server tries to do a callback and a client fails it due to
authentication problems, we need the server to set callback down
flag in RENEW so that client can recover.

Suggested-by: Bruce Fields <bfields@redhat.com>
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Link: https://lore.kernel.org/linux-nfs/FB84E90A-1A03-48B3-8BF7-D9D10AC2C9FE@oracle.com/T/#t
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 052be5bf9ef5..7325592b456e 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1189,6 +1189,7 @@ static void nfsd4_cb_done(struct rpc_task *task, void *calldata)
 		switch (task->tk_status) {
 		case -EIO:
 		case -ETIMEDOUT:
+		case -EACCES:
 			nfsd4_mark_cb_down(clp, task->tk_status);
 		}
 		break;
-- 
2.30.1


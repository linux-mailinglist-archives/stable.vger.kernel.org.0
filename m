Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC8A353DF9
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbhDEJDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237609AbhDEJDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:03:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EED46128A;
        Mon,  5 Apr 2021 09:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613390;
        bh=hswCQyZZ2Qmd89Jdq4tJKYt9JtQSZWQ6mdU4q/xSxXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cs+7QFmVETiHlNbkkqUbHq/5K3RBw5CO4LM0+dF6+PkCuwdlYTQfv8qWxCVw/2FVi
         9dBqYIp6+wVAxe+7ZmqKQCCp3qsy8h8Zl2gUZ7UmcnJ0r9XS9Rt04pMW3okWvljQQk
         251QjeNsuWEajDDXouxVvu4uXJKkJWoGHZM9sQY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Fields <bfields@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/74] NFSD: fix error handling in NFSv4.0 callbacks
Date:   Mon,  5 Apr 2021 10:53:43 +0200
Message-Id: <20210405085025.344874301@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index efe55d101b0e..3c50d18fe8a9 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1121,6 +1121,7 @@ static void nfsd4_cb_done(struct rpc_task *task, void *calldata)
 		switch (task->tk_status) {
 		case -EIO:
 		case -ETIMEDOUT:
+		case -EACCES:
 			nfsd4_mark_cb_down(clp, task->tk_status);
 		}
 		break;
-- 
2.30.1




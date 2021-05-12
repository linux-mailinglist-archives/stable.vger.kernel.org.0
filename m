Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F2E37C9A9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240717AbhELQUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237893AbhELQOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C592361D50;
        Wed, 12 May 2021 15:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834139;
        bh=7bOzLSCmkraFAqNJTmCTyezkbLsr9FsR8ClmoawT8xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcV19vMkwcixIm5oreOnizEmI1aRyjTZ91fYZwAVUcEjjEhS0OZwq6rQltZT0xI/2
         cw+o77oIEFtCZUorABotkT3XriUBDjUQTz2USm+Hj+gfzQHfspkZtSlllHgta6+KEb
         2Z7DowD89ES0P6hZWR2zdK+J/xXUcbWN0Z1sOZi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 423/601] fs: dlm: fix missing unlock on error in accept_from_sock()
Date:   Wed, 12 May 2021 16:48:20 +0200
Message-Id: <20210512144841.759688949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 2fd8db2dd05d895961c7c7b9fa02d72f385560e4 ]

Add the missing unlock before return from accept_from_sock()
in the error handling case.

Fixes: 6cde210a9758 ("fs: dlm: add helper for init connection")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 372c34ff8594..f7d2c52791f8 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -908,6 +908,7 @@ static int accept_from_sock(struct listen_connection *con)
 			result = dlm_con_init(othercon, nodeid);
 			if (result < 0) {
 				kfree(othercon);
+				mutex_unlock(&newcon->sock_mutex);
 				goto accept_err;
 			}
 
-- 
2.30.2




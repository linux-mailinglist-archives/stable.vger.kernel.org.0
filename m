Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68470B8715
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405742AbfISWKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405738AbfISWKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:10:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6CA821929;
        Thu, 19 Sep 2019 22:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931042;
        bh=+PpyBe9AIAsblW3JyysaNGodo98udWJcx/rWMlVM3eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vS3nVAfYq0487Q19v1mH3KTdQfSXJvRh6bUVvFUQQ/xBY1u82Wucf/8v1PGH0eEO4
         DoX1h8JOyc5edNVqTH6z0usksN6wV+OQwRpw3/vZPp9Ur7hmGMrW4XelM7TTD34LXb
         HSdUnnbZwpPL6lcWpiNkNpTJc1XRmdLMgMevLU54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 074/124] NFSv2: Fix write regression
Date:   Fri, 20 Sep 2019 00:02:42 +0200
Message-Id: <20190919214821.693331447@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d33d4beb522987d1c305c12500796f9be3687dee ]

Ensure we update the write result count on success, since the
RPC call itself does not do so.

Reported-by: Jan Stancek <jstancek@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index ec79d2214a78c..0f7288b94633b 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -616,8 +616,10 @@ static int nfs_proc_pgio_rpc_prepare(struct rpc_task *task,
 
 static int nfs_write_done(struct rpc_task *task, struct nfs_pgio_header *hdr)
 {
-	if (task->tk_status >= 0)
+	if (task->tk_status >= 0) {
+		hdr->res.count = hdr->args.count;
 		nfs_writeback_update_inode(hdr);
+	}
 	return 0;
 }
 
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3C4A8A58
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732226AbfIDP7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732222AbfIDP7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5745022DBF;
        Wed,  4 Sep 2019 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612741;
        bh=+PpyBe9AIAsblW3JyysaNGodo98udWJcx/rWMlVM3eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMjeTWpBfql8weIbqMAcRKBFa6putFfMakXzh1FtdtW7G1OfG0jyVSDiRH10lVN2z
         p4AI0gJhySufpFq3sDV4erlNdwFqNQIL9oQpMa2uHfFa/8Xpem32iY/pGUhVQ+rkkE
         SuUwBdRNMyBqUXQZlJ04xECGjj5O17CS7tleF9dk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Jan Stancek <jstancek@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 54/94] NFSv2: Fix write regression
Date:   Wed,  4 Sep 2019 11:56:59 -0400
Message-Id: <20190904155739.2816-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


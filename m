Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA2B7BA4F
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 09:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfGaHOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 03:14:08 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:9819 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfGaHOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 03:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564557247; x=1596093247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=KIvchryCSfe3e7an04klHyFpRztUDZpdp1WQ0mhih4I=;
  b=gBYREGsFMwgTf30MtPNAyjii5G3opHiBxSv5D4UOjTFrA22gRQchFnu5
   xzY6BxZa/IRHIE3qiDh1pxPxFC9inSkYOXWlKP5QDuNC1PJnkvdb6AMT1
   ztSGopS6BWhlgwoQXLnRnVkrmZ6l6RsziTiy+zDLpKLzmgAWx6Kd9oke6
   U=;
X-IronPort-AV: E=Sophos;i="5.64,329,1559520000"; 
   d="scan'208";a="413182833"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 Jul 2019 07:13:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 172FCA1EBC;
        Wed, 31 Jul 2019 07:13:57 +0000 (UTC)
Received: from EX13D17UWB003.ant.amazon.com (10.43.161.42) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:13:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D17UWB003.ant.amazon.com (10.43.161.42) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:13:56 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 31 Jul 2019 07:13:56 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id 812B187441; Wed, 31 Jul 2019 00:13:56 -0700 (PDT)
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <trond.myklebust@hammerspace.com>,
        Qian Lu <luqia@amazon.com>
Subject: [PATCH 1/4] NFS: Fix dentry revalidation on NFSv4 lookup
Date:   Wed, 31 Jul 2019 00:13:24 -0700
Message-ID: <20190731071327.28701-2-luqia@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
In-Reply-To: <20190731071327.28701-1-luqia@amazon.com>
References: <20190731071327.28701-1-luqia@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit be189f7e7f03de35887e5a85ddcf39b91b5d7fc1 upstream.

We need to ensure that inode and dentry revalidation occurs correctly
on reopen of a file that is already open. Currently, we can end up
not revalidating either in the case of NFSv4.0, due to the 'cached open'
path.
Let's fix that by ensuring that we only do cached open for the special
cases of open recovery and delegation return.

Reported-by: Stan Hu <stanhu@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Qian Lu <luqia@amazon.com>
---
 fs/nfs/nfs4proc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a225f98c9903..dd0d333974dc 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1315,12 +1315,20 @@ static bool nfs4_mode_match_open_stateid(struct nfs4_state *state,
 	return false;
 }
 
-static int can_open_cached(struct nfs4_state *state, fmode_t mode, int open_mode)
+static int can_open_cached(struct nfs4_state *state, fmode_t mode,
+		int open_mode, enum open_claim_type4 claim)
 {
 	int ret = 0;
 
 	if (open_mode & (O_EXCL|O_TRUNC))
 		goto out;
+	switch (claim) {
+	case NFS4_OPEN_CLAIM_NULL:
+	case NFS4_OPEN_CLAIM_FH:
+		goto out;
+	default:
+		break;
+	}
 	switch (mode & (FMODE_READ|FMODE_WRITE)) {
 		case FMODE_READ:
 			ret |= test_bit(NFS_O_RDONLY_STATE, &state->flags) != 0
@@ -1615,7 +1623,7 @@ static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 
 	for (;;) {
 		spin_lock(&state->owner->so_lock);
-		if (can_open_cached(state, fmode, open_mode)) {
+		if (can_open_cached(state, fmode, open_mode, claim)) {
 			update_open_stateflags(state, fmode);
 			spin_unlock(&state->owner->so_lock);
 			goto out_return_state;
@@ -2139,7 +2147,8 @@ static void nfs4_open_prepare(struct rpc_task *task, void *calldata)
 	if (data->state != NULL) {
 		struct nfs_delegation *delegation;
 
-		if (can_open_cached(data->state, data->o_arg.fmode, data->o_arg.open_flags))
+		if (can_open_cached(data->state, data->o_arg.fmode,
+					data->o_arg.open_flags, claim))
 			goto out_no_action;
 		rcu_read_lock();
 		delegation = rcu_dereference(NFS_I(data->state->inode)->delegation);
-- 
2.15.3.AMZN


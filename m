Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA4638EBC2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhEXPHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhEXPDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8980561582;
        Mon, 24 May 2021 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867835;
        bh=4Tp/SERZQmLQ/K2VWWhcZ4juLVgNdw9drvms0grBHk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBh6fLWT5Kseoece6RCWLFM1vDAodr5qyTvTSWnA0ryDMKtGdIVQZGBzwQ2w1mrjW
         cMhADOqGC3QxU3SL+qT2aBhWZz21T1WrxW7UB9EIHENWuNQl0ocHGeTZwMs6egjGx3
         nMYl0vgUqWcjuzItzGvTy6Xyvaf4X/D+JcFKuWQTT14dvUMDdr1xUOisWIRSalokQ9
         shkK6o8f8V+3zqGg6PnAYSSg5eO3lwGrZ5fQkKYR7SLjLPBcvmutzG6Q8y7mK6HS+/
         z3gpgw7Du0SNyUaruRdVDCMAtnTbqNIa9inIu+slfu9ZiK5Avq78ygT/zUOy4ReQty
         0yxVO2qoCCgbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Stefan Metzmacher <metze@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.19 22/25] SMB3: incorrect file id in requests compounded with open
Date:   Mon, 24 May 2021 10:50:05 -0400
Message-Id: <20210524145008.2499049-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit c0d46717b95735b0eacfddbcca9df37a49de9c7a ]

See MS-SMB2 3.2.4.1.4, file ids in compounded requests should be set to
0xFFFFFFFFFFFFFFFF (we were treating it as u32 not u64 and setting
it incorrectly).

Signed-off-by: Steve French <stfrench@microsoft.com>
Reported-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ee824131c02e..8e3863004ebb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3117,10 +3117,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 			 * Related requests use info from previous read request
 			 * in chain.
 			 */
-			shdr->SessionId = 0xFFFFFFFF;
+			shdr->SessionId = 0xFFFFFFFFFFFFFFFF;
 			shdr->TreeId = 0xFFFFFFFF;
-			req->PersistentFileId = 0xFFFFFFFF;
-			req->VolatileFileId = 0xFFFFFFFF;
+			req->PersistentFileId = 0xFFFFFFFFFFFFFFFF;
+			req->VolatileFileId = 0xFFFFFFFFFFFFFFFF;
 		}
 	}
 	if (remaining_bytes > io_parms->length)
-- 
2.30.2


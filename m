Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA55D38EAAD
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhEXO5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233629AbhEXOzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29B2761434;
        Mon, 24 May 2021 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867730;
        bh=C+RxOjDBzBqPwV2etjbQBoC+YSMce/i9mz9PawOxT9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFEpCcRKj9uUhgtEOhxBPkBJcQhjVnDa3RDrr3sfyZ8LruJ9eSAEM4rGZTVGYuEVu
         u+TwSsoJxEYRSfcNgF9dvh1HtsVFE3ovg0W1cFHuPt9hy9oja2KoVOuD+rzJyVyp+o
         ihF4VzFE/wnPFl41eMqgHoAqWbCIvWO/0RGmyjQaD5gc9KM0ulq6EWHaaaGt8IoFhp
         XN/+HEM0dqDakQCXW0SW8HOJT9tva0bhY5laWarVE39t0qScYuuprdgx+vH33JxepE
         1TvSIcQzkAuBCS3Lpt+jXLGFvnPgfAw3EWng/aQrqRcp+IQBk8KjelFR30/ojgxHVW
         eCkNQBniptaaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Stefan Metzmacher <metze@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 54/62] SMB3: incorrect file id in requests compounded with open
Date:   Mon, 24 May 2021 10:47:35 -0400
Message-Id: <20210524144744.2497894-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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
index d424f431263c..562f88443b31 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3891,10 +3891,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
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


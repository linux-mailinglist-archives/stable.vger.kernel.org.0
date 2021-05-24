Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8C438E9DA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhEXOvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233373AbhEXOt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29431613F4;
        Mon, 24 May 2021 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867652;
        bh=SANci1l2kd2HyT03ifQY0Mx5DajHhe6nIAvJeyfFj7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxjBciGPZeHX/5vaa+btNZpTg6T3MOSUNTSGyBYHRkSb99G21o+a3zIqJX05euOj2
         SFf0UHtHpIxgAVXyfqZcvImjWp3jtFsqLbONQ2DKDmbHuN+88TP/YgpDuDqVtM1odo
         7Hapf1tQWhqOUWFI6N5w94XvL/W5Ih5XC33vwvDDrM0pBeK20MkgJR43mZiU4INK+w
         s2N0IjR0oX1qrMwhLJb03nRVSW7UTs8VyOpTksqoYIu3karHAFcSNuDA24vw2/g7QG
         hm8R2pujvmDzYtunth49Zp5vnDsr+Mo/vgHzXATJqx77/2Uinzd5V3eLFof5MnHMj3
         Ow44gKk7aIRVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Stefan Metzmacher <metze@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.12 55/63] SMB3: incorrect file id in requests compounded with open
Date:   Mon, 24 May 2021 10:46:12 -0400
Message-Id: <20210524144620.2497249-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 29272d99102c..ab1f44f50804 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3900,10 +3900,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
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


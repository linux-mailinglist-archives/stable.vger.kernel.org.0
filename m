Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B238EBCD
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhEXPIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235087AbhEXPFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5433615A0;
        Mon, 24 May 2021 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867864;
        bh=VrtYBmNnianniO00dxS8V0QD4bR7ffHy19vt9sjE4yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeC5+kwAFVCmWdNnbXkidHYTmxGoVfe9rHQS2GWKiPRW54hQS4FFnhWNRmmTdRPy0
         sjTMVWW09pNqE9eWubG92qaIlmrUXZO2jogF39OCFSaCShBYxelqqtJZ5YlHACaPwQ
         E8n4kpZPVPppm46k1N2T4+4B7+vXb6tNoFOdqJcUrQmLXNhtIwKblfJyqUTf8B4WJj
         E/L2qU4yIKDttmfeyO9XQmF0w331XmLXp0x5cxkrk5q3C5V1r3sL+3IJwhkPNvse/q
         lCaC1pmzSdbrPywTs66xzaaL2n1pqduqhgNZksQGU/8RSq3dbWd4JtyzbCnMvufscn
         ODB8n5Ek+Lprw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Stefan Metzmacher <metze@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 20/21] SMB3: incorrect file id in requests compounded with open
Date:   Mon, 24 May 2021 10:50:39 -0400
Message-Id: <20210524145040.2499322-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
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
index 2097b5fd51ba..77a9aeaf2cb1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2518,10 +2518,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
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


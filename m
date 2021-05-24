Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8038538EB7A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhEXPD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234217AbhEXPA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7853861465;
        Mon, 24 May 2021 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867802;
        bh=KifeVjuCg6hmIuHIzWoq1VW3ZxNBLP/mJWS4HHiD/UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8xTH6fuBWoLDNnNIfxlb8+DZYGBYCsBoB3TrKJerzDm4E0cA7aNOBBdeiQpedyuC
         N+0UDvNfeJHpHgRfjaS4mMy15ainF5jj5Mtya3ApuVWh5oXU8Xt/TDTnBAckYkeN/r
         VK9Gb0NLXD/qphVnBjeC68av3uYPPLyLJOSrsJNU9Rke1ttTU46qKyeU6Xo5rTaZyL
         tydKii/QoG7KSBMgRPzYqtX/Hn7zofSXsSlcHK46Zjubo41P7txdboe3UYUlGPbt05
         gicfhgsIboGoUdFwKOWR0pKQnGbqXNJe5GN3652ZsOhEnt+xSYIbxyk0ueE61s9c/a
         8t+jzZY8FpVzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Stefan Metzmacher <metze@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 48/52] SMB3: incorrect file id in requests compounded with open
Date:   Mon, 24 May 2021 10:48:58 -0400
Message-Id: <20210524144903.2498518-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index 81d9c4ea0e8f..5ca7d903331a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3604,10 +3604,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
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


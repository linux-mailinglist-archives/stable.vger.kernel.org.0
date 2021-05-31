Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B973960BE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhEaObN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233729AbhEaO3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7754A61621;
        Mon, 31 May 2021 13:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468882;
        bh=++LW60jO3k9mXh6igm2eVWQTWvkp/K+wt3ocYKaL7h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGzAz0YpD0PGizC+khFFReS1DoFfExmExUQr6zTp7IeO6Qsk8NyU9cOJnxniG5jFv
         a6pTDa0E2IB7JnwuSAQ0cojd6LmHHv75hbK3OTk+gibqvCHyLxHj5pR6C+/OCgwB0C
         WRPJAXZYtTs/IsCXcRDlBMbarRbGFCIJS4OWup2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Stefan Metzmacher <metze@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/177] SMB3: incorrect file id in requests compounded with open
Date:   Mon, 31 May 2021 15:14:47 +0200
Message-Id: <20210531130652.425371951@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c02983ebd763..e068f82ffedd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3611,10 +3611,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
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




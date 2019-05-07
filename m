Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE69F159E5
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfEGFlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfEGFk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 520B521655;
        Tue,  7 May 2019 05:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207659;
        bh=pBvqJq9KybAlgRuI+BIKTZnJZ7Dwrfn+zeyx2dxlZIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T42delRmi2wBgbDfyxBMZ6WZzE5ry98vfjZiuseRezLA93j6WOx0cXskBkpBncmIR
         6XuXkJNZWqg//23ppKb/9cXh8WKDtfVZMEsTr4kqY2AaC0SlVcwUPVv1jKsDrDGluv
         fkCs77r+dFZk8owF7pC2EDh72mmeaA8St3H/LL0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 83/95] cifs: fix memory leak in SMB2_read
Date:   Tue,  7 May 2019 01:38:12 -0400
Message-Id: <20190507053826.31622-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 05fd5c2c61732152a6bddc318aae62d7e436629b ]

Commit 088aaf17aa79300cab14dbee2569c58cfafd7d6e introduced a leak where
if SMB2_read() returned an error we would return without freeing the
request buffer.

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 fs/cifs/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index fd2d199dd413..7936eac5a38a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2699,6 +2699,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 			cifs_dbg(VFS, "Send error in read = %d\n", rc);
 		}
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+		cifs_small_buf_release(req);
 		return rc == -ENODATA ? 0 : rc;
 	}
 
-- 
2.20.1


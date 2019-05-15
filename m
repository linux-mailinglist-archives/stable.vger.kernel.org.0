Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9853A1F17A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbfEOLTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbfEOLTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E0620843;
        Wed, 15 May 2019 11:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919143;
        bh=fWiBpcA0mNflmgw9MMCsQMXAFnICxrrOYc/DvDCiKxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdQwYSdwW3sP+jbwukWCd5m+xZr+i2faXcpeqtp5C1I8xK0aFE0X6Z20R7V+1zoT1
         Zil+MX0nMtGso9NZkJ3Ve3AqYOxkWc2XuJj+lXCwf9rjQxOz8SaEJuoI6ujJYZJJQL
         SgV54Ure+8tKOzs5nrYGk7vWw0/mSyKEbsIUeQ7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 082/115] cifs: fix memory leak in SMB2_read
Date:   Wed, 15 May 2019 12:56:02 +0200
Message-Id: <20190515090705.305124547@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index fd2d199dd413e..7936eac5a38a2 100644
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




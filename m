Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584761CADA1
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgEHMuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgEHMuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3369424958;
        Fri,  8 May 2020 12:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942200;
        bh=44MdXW0/tQSc7zi1YMwilVS4B9vWAuvAITdw+uxpS34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rv+qV0YIdIkGYepJR8QZWINF90jg1fUqFNz5tnznvcggRzjlg99vN57DWXLRQaoB1
         IE6mVb+jFJDLVmHRKU8jx+PgKrhJjrJqWTJX8RgPPUwTbaGDA2kUFWDWxJXMzl+hYe
         anwvqwudDQuOAk3x8DfBT32JBdGADMSACkWiY7jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/18] cifs: protect updating server->dstaddr with a spinlock
Date:   Fri,  8 May 2020 14:35:11 +0200
Message-Id: <20200508123032.833331177@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123030.497793118@linuxfoundation.org>
References: <20200508123030.497793118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit fada37f6f62995cc449b36ebba1220594bfe55fe ]

We use a spinlock while we are reading and accessing the destination address for a server.
We need to also use this spinlock to protect when we are modifying this address from
reconn_set_ipaddr().

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f2707ff795d45..c018d161735c4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -341,8 +341,10 @@ static int reconn_set_ipaddr(struct TCP_Server_Info *server)
 		return rc;
 	}
 
+	spin_lock(&cifs_tcp_ses_lock);
 	rc = cifs_convert_address((struct sockaddr *)&server->dstaddr, ipaddr,
 				  strlen(ipaddr));
+	spin_unlock(&cifs_tcp_ses_lock);
 	kfree(ipaddr);
 
 	return !rc ? -1 : 0;
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1221BFAA9
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgD3NzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgD3NzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:55:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 298C72137B;
        Thu, 30 Apr 2020 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254900;
        bh=B0THgzLB98z6nynqqw9dkSLS0zUCJgWl0JwEXxMV4wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FA44ig/uLEEH1luvErhGj0VPfOPWhXLQCXIbmxposSeoP9IxVXwkM2qNRGKtSElC6
         L7QHk1o+0cR9w79L4hjgWugfwqMcIsHPGTbx6DCVDodIjS91sAD4+tfZp7aM/nFxBe
         MBoU2ws1TG4Qgl4fCtorqkwVqyOdZzQFX1uu3mEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.4 05/11] cifs: protect updating server->dstaddr with a spinlock
Date:   Thu, 30 Apr 2020 09:54:47 -0400
Message-Id: <20200430135453.21353-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135453.21353-1-sashal@kernel.org>
References: <20200430135453.21353-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cf104bbe30a14..c9793ce0d3368 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -338,8 +338,10 @@ static int reconn_set_ipaddr(struct TCP_Server_Info *server)
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0515B1862FB
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgCPCe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbgCPCe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9D720726;
        Mon, 16 Mar 2020 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326065;
        bh=NdXj8AobCtKW15pxvIDIVPmaMMy5Xo0phZ+4bEez/Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/y5ynkTIvIXN+pj2twIprvP5D9W8Pbo/Kjv1WfH2Y8QB6vOOA5DU7pibUIwvKFyT
         UjDxt3KzRuw5Chjj4GZNu7BhKDWuUMexiU5rc51rEDZQhFXzPhdVWjitt44b7ch6pl
         56laEcxJuxGI5a+6vO2uIj9LgOhx4/MTK8iWFHu8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 12/35] cifs: add missing mount option to /proc/mounts
Date:   Sun, 15 Mar 2020 22:33:48 -0400
Message-Id: <20200316023411.1263-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit ec57010acd03428a749d2600bf09bd537eaae993 ]

We were not displaying the mount option "signloosely" in /proc/mounts
for cifs mounts which some users found confusing recently

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 637624ab6e464..115f063497ffa 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -530,6 +530,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
 	if (tcon->seal)
 		seq_puts(s, ",seal");
+	else if (tcon->ses->server->ignore_signature)
+		seq_puts(s, ",signloosely");
 	if (tcon->nocase)
 		seq_puts(s, ",nocase");
 	if (tcon->local_lease)
-- 
2.20.1


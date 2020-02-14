Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35615DDCD
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389133AbgBNQAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389130AbgBNQAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6284624686;
        Fri, 14 Feb 2020 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696022;
        bh=z0rNwAgT4RhdH7E/PP6WgAWT6eALymRlsnU1oUbYAkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX5uYjo14RoUo0mKmIA63bF/X7mYTDH9F6r7wXcbaOWZMvv9s7YW8vK1J8ZEPlXk8
         ALv1s+9r6qDVwOZ0E7hCtGCfICyUGc275clpX88nyKBGqlnZ0QprSKlNhAYLHlpJps
         1AJOMGQT1h6TwWuPXtKvv5hJSqiE+dZK8aPURcSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Oleg Kravtsov <oleg@tuxera.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.5 537/542] cifs: log warning message (once) if out of disk space
Date:   Fri, 14 Feb 2020 10:48:49 -0500
Message-Id: <20200214154854.6746-537-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit d6fd41905ec577851734623fb905b1763801f5ef ]

We ran into a confusing problem where an application wasn't checking
return code on close and so user didn't realize that the application
ran out of disk space.  log a warning message (once) in these
cases. For example:

  [ 8407.391909] Out of space writing to \\oleg-server\small-share

Signed-off-by: Steve French <stfrench@microsoft.com>
Reported-by: Oleg Kravtsov <oleg@tuxera.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0a3b37abc5e12..6c9497c18f0b8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4029,6 +4029,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
 				     wdata->cfile->fid.persistent_fid,
 				     tcon->tid, tcon->ses->Suid, wdata->offset,
 				     wdata->bytes, wdata->result);
+		if (wdata->result == -ENOSPC)
+			printk_once(KERN_WARNING "Out of space writing to %s\n",
+				    tcon->treeName);
 	} else
 		trace_smb3_write_done(0 /* no xid */,
 				      wdata->cfile->fid.persistent_fid,
-- 
2.20.1


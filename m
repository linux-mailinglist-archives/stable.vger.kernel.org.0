Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB1F15EADB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389970AbgBNRQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391801AbgBNQLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A29024684;
        Fri, 14 Feb 2020 16:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696690;
        bh=FJog/hBzuEntMPGFGJZEiaIKgbnfeYjzMZKVtSXEULw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPSZ/se4fPuJOhuTYltKJ2lyDAJ1OliJDnw+06kY9X8agwikD1EKjzejuxLR/aJk9
         7qiLAXGNh+w6BPTi/Saj+F7N2WEF1ON0ERa6csG08Tn8keJz+cqdSwmATtkxmNTmxu
         a4B30X80s3UuMaULLtjnfX6BYxYweeyF9nlOggEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Oleg Kravtsov <oleg@tuxera.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 456/459] cifs: log warning message (once) if out of disk space
Date:   Fri, 14 Feb 2020 11:01:46 -0500
Message-Id: <20200214160149.11681-456-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 06d932ed097e5..c6fc6582ee7bc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3917,6 +3917,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
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


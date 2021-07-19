Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A43CE1C2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344504AbhGSP1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348165AbhGSPYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E55161455;
        Mon, 19 Jul 2021 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710550;
        bh=+ICVfWQGiw/CqEw3V7m9n5QANmSfcNPfR7eNKcoAasM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4LKreBR8E+Jzn1qZ7k4+DrAiaQQJKdDsnX8pALKsQPSVKVm14u+eou1Yap6yDhJ7
         MDcbMBrQ4OuQZyJ/UYyHt/3z26RSMxLw5m+WorML8P37IDdZ7YfI9wFPBXwEutW6Uc
         0qHl4ISe1LneLiyKCN9G3iWwKqLvHMYVFMJFkv8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 003/351] cifs: Do not use the original cruid when following DFS links for multiuser mounts
Date:   Mon, 19 Jul 2021 16:49:09 +0200
Message-Id: <20210719144944.649280274@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 50630b3f1ada0bf412d3f28e73bac310448d9d6f upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213565

cruid should only be used for the initial mount and after this we should use the current
users credentials.
Ignore the original cruid mount argument when creating a new context for a multiuser mount
following a DFS link.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Cc: stable@vger.kernel.org # 5.11+
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_dfs_ref.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -208,6 +208,10 @@ char *cifs_compose_mount_options(const c
 		else
 			noff = tkn_e - (sb_mountdata + off) + 1;
 
+		if (strncasecmp(sb_mountdata + off, "cruid=", 6) == 0) {
+			off += noff;
+			continue;
+		}
 		if (strncasecmp(sb_mountdata + off, "unc=", 4) == 0) {
 			off += noff;
 			continue;



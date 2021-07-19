Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762CF3CE42A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbhGSPm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235709AbhGSPhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF9E606A5;
        Mon, 19 Jul 2021 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711460;
        bh=+ICVfWQGiw/CqEw3V7m9n5QANmSfcNPfR7eNKcoAasM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ9dMes3TCiAJg6QCt8gJNN3vvFT/q0j+LElp2fdw0x8dqf7DKokhJCpLN5OjPZmC
         +Iu8FKntyqxw4xhmG86NIrzGkVzebCUb9J9fePK7dIPaRPbTQGOCPluTj9tZ5NFC+I
         OHof8vi0jp+2zf/XkEk3B8KcMm0fFKoe5V5cejOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 003/292] cifs: Do not use the original cruid when following DFS links for multiuser mounts
Date:   Mon, 19 Jul 2021 16:51:05 +0200
Message-Id: <20210719144942.629302443@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E633D3E25D5
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbhHFIW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244380AbhHFIVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB9061246;
        Fri,  6 Aug 2021 08:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238069;
        bh=GsUR3eFBk9QBw/kYGHobqfEsbKBD2IC+iY9bTejvPtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TvNqKIs6SodradlfU1LuGhjebasbAwMe2xHv7M4j8UMJ0sYNLwM/BMrPEl6xigtN
         WF03xKAAyPSwzU+rxFkb8iW41NA1Mav4idrJfSDwkDgxQxtumM3xNSRafcZvY0VR+S
         28NCRhXkTNKXF2v4IG1PiHDy4d3oR+9H0mSFQ7as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Xiaoli Feng <xifeng@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 08/35] cifs: add missing parsing of backupuid
Date:   Fri,  6 Aug 2021 10:16:51 +0200
Message-Id: <20210806081113.982390511@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit b946dbcfa4df80ec81b442964e07ad37000cc059 ]

We lost parsing of backupuid in the switch to new mount API.
Add it back.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: <stable@vger.kernel.org> # v5.11+
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/fs_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 553adfbcc22a..72742eb1df4a 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -918,6 +918,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->cred_uid = uid;
 		ctx->cruid_specified = true;
 		break;
+	case Opt_backupuid:
+		uid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(uid))
+			goto cifs_parse_mount_err;
+		ctx->backupuid = uid;
+		ctx->backupuid_specified = true;
+		break;
 	case Opt_backupgid:
 		gid = make_kgid(current_user_ns(), result.uint_32);
 		if (!gid_valid(gid))
-- 
2.30.2




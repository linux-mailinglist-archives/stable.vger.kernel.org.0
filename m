Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B303ED5B7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbhHPNNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239673AbhHPNLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB5A4632A3;
        Mon, 16 Aug 2021 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119413;
        bh=IC1s8pHOx+eWqDP4dqbjls1BNy06Guk4cTZ4nHCDvzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHabQwM2mFt7Em1cEHY5dFxWfJAtL8zEJWRk8XeaptWULcj+VR1Ho0zSYyLspfeXM
         LFhJzfG9F0cIoZ+bbaYb0H59CwIDr+0iX0s0Iu7rbci+v36kOx3YjAuGlrYiGEN2UK
         B3NJMxyUijFjlPklVCbB9iv1ZShGkYNWgEPAAhsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        Brian foster <bfoster@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 017/151] cifs: use the correct max-length for dentry_path_raw()
Date:   Mon, 16 Aug 2021 15:00:47 +0200
Message-Id: <20210816125444.644727358@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 981567bd965329df7e64b13e92a54da816c1e0a4 upstream.

RHBZ: 1972502

PATH_MAX is 4096 but PAGE_SIZE can be >4096 on some architectures
such as ppc and would thus write beyond the end of the actual object.

Cc: <stable@vger.kernel.org>
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Suggested-by: Brian foster <bfoster@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -112,7 +112,7 @@ build_path_from_dentry_optional_prefix(s
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
 		pplen = cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
 
-	s = dentry_path_raw(direntry, page, PAGE_SIZE);
+	s = dentry_path_raw(direntry, page, PATH_MAX);
 	if (IS_ERR(s))
 		return s;
 	if (!s[1])	// for root we want "", not "/"



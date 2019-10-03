Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69A9CAB03
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390068AbfJCRQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388487AbfJCQXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76C7A21A4C;
        Thu,  3 Oct 2019 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119821;
        bh=Zm2B1F/uU1HKxIqJj3bpcXBykbAxzVxXbPe7Q9uwm8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hApamAAWKVIiATdQP1m7xAJbbpNwLXrPzYmRugg8wY5S89/Y1uVG6C9gwN0s7PZ3c
         4I96riGrjm8MXwV2AuJQxUG+ZmiVqapgr5RdxuI2eN53yYxgSKjuZFktzXL+ZCHF4m
         Nsf6nR2z2g64doWSYqwwTayaw4MHYTuzaduBOM9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 206/211] CIFS: fix max ea value size
Date:   Thu,  3 Oct 2019 17:54:32 +0200
Message-Id: <20191003154530.333286038@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

commit 63d37fb4ce5ae7bf1e58f906d1bf25f036fe79b2 upstream.

It should not be larger then the slab max buf size. If user
specifies a larger size, it passes this check and goes
straightly to SMB2_set_info_init performing an insecure memcpy.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -31,7 +31,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 
-#define MAX_EA_VALUE_SIZE 65535
+#define MAX_EA_VALUE_SIZE CIFSMaxBufSize
 #define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
 #define CIFS_XATTR_ATTRIB "cifs.dosattrib"  /* full name: user.cifs.dosattrib */
 #define CIFS_XATTR_CREATETIME "cifs.creationtime"  /* user.cifs.creationtime */



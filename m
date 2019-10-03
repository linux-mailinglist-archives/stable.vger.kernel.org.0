Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48006CA922
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392093AbfJCQhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392077AbfJCQhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:37:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF6252086A;
        Thu,  3 Oct 2019 16:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120667;
        bh=Zm2B1F/uU1HKxIqJj3bpcXBykbAxzVxXbPe7Q9uwm8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3xnBi1FVY90x+7hmNyzQx56xqRYvZNluO1MJjMCiiLPwfyhY1aS/KAeP2vRxtlD3
         0eVIB48bUVi4xVRuDlPIdjZ+8qMdz2IBgD1dQAGHgY9xjPw3WW2CDV9OnNUwmdYrMU
         zEBxx52lHEI1AgrX9HvjiueRVihf4scBFeIJ7kRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.2 307/313] CIFS: fix max ea value size
Date:   Thu,  3 Oct 2019 17:54:45 +0200
Message-Id: <20191003154603.440540789@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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



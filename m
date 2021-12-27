Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DAB4800ED
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhL0Pvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240809AbhL0Ptu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:49:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8511DC0698C5;
        Mon, 27 Dec 2021 07:44:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2306261047;
        Mon, 27 Dec 2021 15:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C1FC36AE7;
        Mon, 27 Dec 2021 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619870;
        bh=vbcrYyhJAaPWDX0i/5Q3IZ6fDKkpvQPv/oI6sihBTUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QscYpWjSfsjLqyJTVkKUzGkZqeb5h1ajAli9dBIb1VNBmEed54FfyphcCIxGhDJu5
         Bd9Xjs5tmNHvOLMXF0EBX/5hApuRMzN0R8kjc0xVQv4jqwuUa2OXhl9C3Nc38gUFXx
         5WWGF4KM7iF4cQrbQpM1vue9V2B2v3mk8XrBxaHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 099/128] ksmbd: fix uninitialized symbol pntsd_size
Date:   Mon, 27 Dec 2021 16:31:14 +0100
Message-Id: <20211227151334.828936587@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit f2e78affc48dee29b989c1d9b0d89b503dcd1204 upstream.

No check for if "rc" is an error code for build_sec_desc().
This can cause problems with using uninitialized pntsd_size.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org # v5.15
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2964,6 +2964,10 @@ int smb2_open(struct ksmbd_work *work)
 							    &pntsd_size, &fattr);
 					posix_acl_release(fattr.cf_acls);
 					posix_acl_release(fattr.cf_dacls);
+					if (rc) {
+						kfree(pntsd);
+						goto err_out;
+					}
 
 					rc = ksmbd_vfs_set_sd_xattr(conn,
 								    user_ns,



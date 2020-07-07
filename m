Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E952171F5
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgGGP1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgGGP1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:27:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8568020663;
        Tue,  7 Jul 2020 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135625;
        bh=u4HwCGcn8HVCMtu5Ujk7nqwfMT0GJpyjK2Cnff1ZIuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zw8LiUQxe495sMw90BiPRqOFxqXfv8fSpk7EkwUD7qPvQF449q2VPvieDUd/5EGL6
         OkB145yqEYcNwIPNXuObm6bELgkbz+tGQ74fDkZH1d1zFxyRza4Ce6P7wroNUbcTuq
         ZXFmivxy+bpanR5EJFnuiNTYWkHmIwrAbEKUjBKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Aurich <paul@darkrain42.org>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 5.7 092/112] SMB3: Honor handletimeout flag for multiuser mounts
Date:   Tue,  7 Jul 2020 17:17:37 +0200
Message-Id: <20200707145805.355148460@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Aurich <paul@darkrain42.org>

commit 6b356f6cf941d5054d7fab072cae4a5f8658e3db upstream.

Fixes: ca567eb2b3f0 ("SMB3: Allow persistent handle timeout to be configurable on mount")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5309,6 +5309,7 @@ cifs_construct_tcon(struct cifs_sb_info
 	vol_info->no_lease = master_tcon->no_lease;
 	vol_info->resilient = master_tcon->use_resilient;
 	vol_info->persistent = master_tcon->use_persistent;
+	vol_info->handle_timeout = master_tcon->handle_timeout;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
 	vol_info->linux_ext = master_tcon->posix_extensions;
 	vol_info->sectype = master_tcon->ses->sectype;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1082622F17F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgG0Ocw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731224AbgG0OS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5045F2070A;
        Mon, 27 Jul 2020 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859508;
        bh=0ZJWlq1G8erVgH9EJ/RuAJrxn1aUU9FfBEqTpkzpFxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKMBjkNHoKRWaGZxXSKU2FVTDQqChUDaNEbz6HYI5w3Vi12lkLiklR+v0IEC0RMYE
         1ehOKKYb33MQf51fNWZyRxSCAnRuRpA7c6HlZihLFxKneBNoK19jF94xIqEzNhDerr
         fzprGb2iEDSVs3Tnr3xY0RX79Wrrmmd0wwFw1jxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Patrick Fernie <patrick.fernie@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Subject: [PATCH 5.4 107/138] Revert "cifs: Fix the target file was deleted when rename failed."
Date:   Mon, 27 Jul 2020 16:05:02 +0200
Message-Id: <20200727134930.819342802@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 0e6705182d4e1b77248a93470d6d7b3013d59b30 upstream.

This reverts commit 9ffad9263b467efd8f8dc7ae1941a0a655a2bab2.

Upon additional testing with older servers, it was found that
the original commit introduced a regression when using the old SMB1
dialect and rsyncing over an existing file.

The patch will need to be respun to address this, likely including
a larger refactoring of the SMB1 and SMB3 rename code paths to make
it less confusing and also to address some additional rename error
cases that SMB3 may be able to workaround.

Signed-off-by: Steve French <stfrench@microsoft.com>
Reported-by: Patrick Fernie <patrick.fernie@gmail.com>
CC: Stable <stable@vger.kernel.org>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Pavel Shilovsky <pshilov@microsoft.com>
Acked-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1791,7 +1791,6 @@ cifs_rename2(struct inode *source_dir, s
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	unsigned int xid;
 	int rc, tmprc;
-	bool new_target = d_really_is_negative(target_dentry);
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -1868,13 +1867,8 @@ cifs_rename2(struct inode *source_dir, s
 	 */
 
 unlink_target:
-	/*
-	 * If the target dentry was created during the rename, try
-	 * unlinking it if it's not negative
-	 */
-	if (new_target &&
-	    d_really_is_positive(target_dentry) &&
-	    (rc == -EACCES || rc == -EEXIST)) {
+	/* Try unlinking the target dentry if it's not negative */
+	if (d_really_is_positive(target_dentry) && (rc == -EACCES || rc == -EEXIST)) {
 		if (d_is_dir(target_dentry))
 			tmprc = cifs_rmdir(target_dir, target_dentry);
 		else



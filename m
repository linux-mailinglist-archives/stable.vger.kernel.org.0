Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252722A15C6
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgJaLgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgJaLgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:36:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F65820791;
        Sat, 31 Oct 2020 11:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144170;
        bh=G3P4MoamZRbhF09JUZQrLzlhHsn0SlkUTzcqxSWXGS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHyIENgl55dNiSsR+/afbh9u4bRc4BHd0GCc00Ef1Gcp2Cys99QxhgQ2yA3x1lh3/
         tgZn3/FiY86FH9vU/Y92bVlyT55army4FI2Za8KlbO5I/rmuccozsi7mR3Zv+8PjyW
         PhqS5XChdl2LXKyxo0RZ6wHRW6Mfp15K7bMzmNMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.4 09/49] efivarfs: Replace invalid slashes with exclamation marks in dentries.
Date:   Sat, 31 Oct 2020 12:35:05 +0100
Message-Id: <20201031113455.894752796@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Schaller <misch@google.com>

commit 336af6a4686d885a067ecea8c3c3dd129ba4fc75 upstream.

Without this patch efivarfs_alloc_dentry creates dentries with slashes in
their name if the respective EFI variable has slashes in its name. This in
turn causes EIO on getdents64, which prevents a complete directory listing
of /sys/firmware/efi/efivars/.

This patch replaces the invalid shlashes with exclamation marks like
kobject_set_name_vargs does for /sys/firmware/efi/vars/ to have consistently
named dentries under /sys/firmware/efi/vars/ and /sys/firmware/efi/efivars/.

Signed-off-by: Michael Schaller <misch@google.com>
Link: https://lore.kernel.org/r/20200925074502.150448-1-misch@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/efivarfs/super.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -141,6 +141,9 @@ static int efivarfs_callback(efi_char16_
 
 	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
 
+	/* replace invalid slashes like kobject_set_name_vargs does for /sys/firmware/efi/vars. */
+	strreplace(name, '/', '!');
+
 	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0,
 				   is_removable);
 	if (!inode)



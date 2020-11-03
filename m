Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E682A5575
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbgKCVSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388466AbgKCVJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF0F7205ED;
        Tue,  3 Nov 2020 21:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437756;
        bh=nqUWH7qrzBm7yLCgxxq27EhWc7fb88HHtfPF7aPKomU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azz92gHuxKUZTJrZQUSkBASZsfaNL3WBliowRD7kCgi7tAm78YWFju3XqvMVPaZOk
         mmsacQGpygIon9bdYPYIeSYsjMeTqaJbQTl7DTWwWWGeARn19kLEtp1YlZMIDpgOuh
         GaRawAa2YqFI9PHI53Hm7etaa+Jf7CJ4T8KxQxd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 4.14 003/125] efivarfs: Replace invalid slashes with exclamation marks in dentries.
Date:   Tue,  3 Nov 2020 21:36:20 +0100
Message-Id: <20201103203156.913655523@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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
@@ -145,6 +145,9 @@ static int efivarfs_callback(efi_char16_
 
 	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
 
+	/* replace invalid slashes like kobject_set_name_vargs does for /sys/firmware/efi/vars. */
+	strreplace(name, '/', '!');
+
 	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0,
 				   is_removable);
 	if (!inode)



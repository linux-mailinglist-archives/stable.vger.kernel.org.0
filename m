Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3538F2ABDBA
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgKINtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgKIM4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B8762076E;
        Mon,  9 Nov 2020 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926560;
        bh=QPDitiwk1e0uTubLFjFO0gM5Pz3/FzAyD3oDhoEkEDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pr2kNjcl7m2H0UZdeqjK+A6WBO/TqBBbt6zURtdg5KR06ye62YlnVFeVtEzyHOvsv
         ppv2wQVe6QmpSBb0AUnoJp1duSIu5VLXmdJ2pHJ9yrn1CuFsXme8PGA+RzWkL36KfJ
         QMk6++nl6J6Lg+uFWufAmlT+tyFPx40Qg3x33oyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 4.4 04/86] efivarfs: Replace invalid slashes with exclamation marks in dentries.
Date:   Mon,  9 Nov 2020 13:54:11 +0100
Message-Id: <20201109125021.071442087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
@@ -147,6 +147,9 @@ static int efivarfs_callback(efi_char16_
 
 	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
 
+	/* replace invalid slashes like kobject_set_name_vargs does for /sys/firmware/efi/vars. */
+	strreplace(name, '/', '!');
+
 	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0,
 				   is_removable);
 	if (!inode)



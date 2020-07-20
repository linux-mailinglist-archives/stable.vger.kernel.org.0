Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCD8226905
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgGTQEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732368AbgGTQEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6522064B;
        Mon, 20 Jul 2020 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261073;
        bh=E1QkEjrG728q+aKZmD25tBYamtN2VrS2xZW5m+cyQ2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrUQpGE7A3thgl5PKKkikJeigE+7wN5wBzktQiNuU3qpFwvvMGr5U9TXBHSeqiyR/
         n9OcJSjXXYmNHgQ86m3JxKrJE3s3RhW54ULhe1E1kciZrcKQ42pPxlsM7mDvI5nade
         oLf+2+O6isRXr6CWxok/DMN3MS3uEMxLh7c78yN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian <godi.beat@gmx.net>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 169/215] ovl: fix regression with re-formatted lower squashfs
Date:   Mon, 20 Jul 2020 17:37:31 +0200
Message-Id: <20200720152828.210251105@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit a888db310195400f050b89c47673f0f8babfbb41 upstream.

Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of lower
fs") relaxed the requirement for non null uuid with single lower layer to
allow enabling index and nfs_export features with single lower squashfs.

Fabian reported a regression in a setup when overlay re-uses an existing
upper layer and re-formats the lower squashfs image.  Because squashfs
has no uuid, the origin xattr in upper layer are decoded from the new
lower layer where they may resolve to a wrong origin file and user may
get an ESTALE or EIO error on lookup.

To avoid the reported regression while still allowing the new features
with single lower squashfs, do not allow decoding origin with lower null
uuid unless user opted-in to one of the new features that require
following the lower inode of non-dir upper (index, xino, metacopy).

Reported-by: Fabian <godi.beat@gmx.net>
Link: https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid of lower fs")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/super.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1258,6 +1258,18 @@ static bool ovl_lower_uuid_ok(struct ovl
 	if (!ofs->config.nfs_export && !ofs->upper_mnt)
 		return true;
 
+	/*
+	 * We allow using single lower with null uuid for index and nfs_export
+	 * for example to support those features with single lower squashfs.
+	 * To avoid regressions in setups of overlay with re-formatted lower
+	 * squashfs, do not allow decoding origin with lower null uuid unless
+	 * user opted-in to one of the new features that require following the
+	 * lower inode of non-dir upper.
+	 */
+	if (!ofs->config.index && !ofs->config.metacopy && !ofs->config.xino &&
+	    uuid_is_null(uuid))
+		return false;
+
 	for (i = 0; i < ofs->numlowerfs; i++) {
 		/*
 		 * We use uuid to associate an overlay lower file handle with a



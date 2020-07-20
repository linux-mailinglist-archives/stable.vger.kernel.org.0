Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9035B226835
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732901AbgGTQOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387612AbgGTQOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEEF02064B;
        Mon, 20 Jul 2020 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261694;
        bh=IvdeRcr2fUcV5Y+91mu8sLHw7p8jStSIF+Q/2YVitMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U83VtkTSUiIUeKRc8V9K1FZvT9HlZjoXuhXJwUf+N4aTHGckVCBihfZX016kuLGMN
         vSofvO9UAHsw00ezqS+m7GC6Js+PYF/mpkvVPHwN9pQOkgb3ZTRyUEq5qAdjP9HJM1
         dGHWGOERaf4WBBCC/33gw2sFVXjb9D+t/bCV25Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian <godi.beat@gmx.net>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 178/244] ovl: fix regression with re-formatted lower squashfs
Date:   Mon, 20 Jul 2020 17:37:29 +0200
Message-Id: <20200720152834.306030297@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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
@@ -1331,6 +1331,18 @@ static bool ovl_lower_uuid_ok(struct ovl
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
 	for (i = 0; i < ofs->numfs; i++) {
 		/*
 		 * We use uuid to associate an overlay lower file handle with a



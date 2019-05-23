Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAEA288B5
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391734AbfEWT2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391727AbfEWT2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:28:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38499206BA;
        Thu, 23 May 2019 19:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639688;
        bh=ZKAWL+TfWyCxI4eR1wQK7z52Plma/GdthdPmEGtd6Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWnIUEEP7+z8+fj8jCbybQpQqEysyFm0wsDIuqSvr8xkDXIH43luv98vrvzEtP3f0
         273knjPXjoVnvwc/JDAYvthhR7LMUE3h29Mek2NwwZp/xpD6Mqt9Y+kkVbnKxUspix
         UOr8qGHM2BLsAeN3TZOCGFCMvcd3Ax6N9Mj5GBV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.1 058/122] PNFS fallback to MDS if no deviceid found
Date:   Thu, 23 May 2019 21:06:20 +0200
Message-Id: <20190523181712.487406914@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit b1029c9bc078a6f1515f55dd993b507dcc7e3440 upstream.

If we fail to find a good deviceid while trying to pnfs instead of
propogating an error back fallback to doing IO to the MDS. Currently,
code with fals the IO with EINVAL.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: 8d40b0f14846f ("NFS filelayout:call GETDEVICEINFO after pnfs_layout_process completes"
Cc: stable@vger.kernel.org # v4.11+
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/filelayout/filelayout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -904,7 +904,7 @@ fl_pnfs_update_layout(struct inode *ino,
 	status = filelayout_check_deviceid(lo, fl, gfp_flags);
 	if (status) {
 		pnfs_put_lseg(lseg);
-		lseg = ERR_PTR(status);
+		lseg = NULL;
 	}
 out:
 	return lseg;



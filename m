Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF3A1FB8EA
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbgFPP7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732382AbgFPPxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:53:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B29207C4;
        Tue, 16 Jun 2020 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322815;
        bh=CsmU7ymn6SkmOal5pl7XmtF+1V/WOn0gWqxHgLpj0P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eer1RDK6tx6r6g9E4gae3CDgNQN6dHmVl2dYwWBTGiOgVS/CbwRuzKsQ0M60LeqXw
         n9tNsNzlW2EqjZegg5Lp6bY/7RSs88MrTuOoXJJNv/G7wVFRW0L/FwbRH6y9ccAhJf
         DVRvp739Av1Ra8+nV71P6V59/jqat1eiex31snng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
Subject: [PATCH 5.6 115/161] ovl: fix out of bounds access warning in ovl_check_fb_len()
Date:   Tue, 16 Jun 2020 17:35:05 +0200
Message-Id: <20200616153111.834564988@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 522f6e6cba6880a038e2bd88e10390b84cd3febd upstream.

syzbot reported out of bounds memory access from open_by_handle_at()
with a crafted file handle that looks like this:

  { .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }

handle_bytes gets rounded down to 0 and we end up calling:
  ovl_check_fh_len(fh, 0) => ovl_check_fb_len(fh + 3, -3)

But fh buffer is only 2 bytes long, so accessing struct ovl_fb at
fh + 3 is illegal.

Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
Reported-and-tested-by: syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> # v5.5
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/overlayfs.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -339,6 +339,9 @@ int ovl_check_fb_len(struct ovl_fb *fb,
 
 static inline int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
 {
+	if (fh_len < sizeof(struct ovl_fh))
+		return -EINVAL;
+
 	return ovl_check_fb_len(&fh->fb, fh_len - OVL_FH_WIRE_OFFSET);
 }
 



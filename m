Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50851FBA01
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgFPQH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732216AbgFPPqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5538820776;
        Tue, 16 Jun 2020 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322396;
        bh=JMlBOiZ+vCeIqMWFevpV9y3+A1JmqSlgaldOXzG2dsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vf6xSHM577ciPFz67LuUyGpHOgD2jqicayJix/gx+rNBnIV9B2yu100VYaW+8olaF
         dwFCV5dZjq+7yOgQKUdDec5+1Yn5o2TwafY5/0IR+MUXxzQTxjwzL248xgqGrnmG9T
         F65tLOGTQJJ5vU688w7Sh4+d8/niEKNhQWjsB5Gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
Subject: [PATCH 5.7 115/163] ovl: fix out of bounds access warning in ovl_check_fb_len()
Date:   Tue, 16 Jun 2020 17:34:49 +0200
Message-Id: <20200616153112.311331992@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
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
@@ -355,6 +355,9 @@ int ovl_check_fb_len(struct ovl_fb *fb,
 
 static inline int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
 {
+	if (fh_len < sizeof(struct ovl_fh))
+		return -EINVAL;
+
 	return ovl_check_fb_len(&fh->fb, fh_len - OVL_FH_WIRE_OFFSET);
 }
 



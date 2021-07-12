Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7333C4C00
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbhGLHBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241431AbhGLHAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCDEA61004;
        Mon, 12 Jul 2021 06:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073077;
        bh=NNahF+fov1ZaCOcTBuZtRh7Qg7VDLkUNy31LawXhav4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgHBrF1EkZPuYJU8/Z4MKE9hkRsPj0IFTJuVwAoU0c6wb/yriTJ14L19oAoAx+jsy
         Pjwt1kGtppUol3uXNe/oBlQ9QGk/Q/0XXjj3czlb2oybikNNstEnKoEbAlvETWTcO3
         GdGho/T0+6kDG8orWDs8+bbElMvRkfW8R4FFWkrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.12 117/700] fuse: reject internal errno
Date:   Mon, 12 Jul 2021 08:03:20 +0200
Message-Id: <20210712060941.472655185@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 49221cf86d18bb66fe95d3338cb33bd4b9880ca5 upstream.

Don't allow userspace to report errors that could be kernel-internal.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Fixes: 334f485df85a ("[PATCH] FUSE - device functions")
Cc: <stable@vger.kernel.org> # v2.6.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1867,7 +1867,7 @@ static ssize_t fuse_dev_do_write(struct
 	}
 
 	err = -EINVAL;
-	if (oh.error <= -1000 || oh.error > 0)
+	if (oh.error <= -512 || oh.error > 0)
 		goto copy_finish;
 
 	spin_lock(&fpq->lock);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D973E1B3D71
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgDVKOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgDVKOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:14:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5925F2071E;
        Wed, 22 Apr 2020 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550489;
        bh=lzAr4ppCgdjZHX3lpnDUbHFj+hcvIzVExwUEm8K4/hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1Ao0dv753hrRcKzu/otFrr3T6BRpjW5dyfbulS5vKWEegEE8gkWfk+E+AUqfuPan
         ok2PNJItVJUVF/nv3Ym5lLk/Xpcp1CXDFD0bZNwSdBdZlvJfK6ZDXfANOS3ujQGmC5
         gIxP/LpjpqjU8i05BGZIDBpzU4JxLZEPtp68L5JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/64] um: ubd: Prevent buffer overrun on command completion
Date:   Wed, 22 Apr 2020 11:57:21 +0200
Message-Id: <20200422095019.630791494@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 6e682d53fc1ef73a169e2a5300326cb23abb32ee ]

On the hypervisor side, when completing commands and the pipe is full,
we retry writing only the entries that failed, by offsetting
io_req_buffer, but we don't reduce the number of bytes written, which
can cause a buffer overrun of io_req_buffer, and write garbage to the
pipe.

Cc: Martyn Welch <martyn.welch@collabora.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 83c470364dfb3..748bd0921dfff 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1574,7 +1574,9 @@ int io_thread(void *arg)
 		written = 0;
 
 		do {
-			res = os_write_file(kernel_fd, ((char *) io_req_buffer) + written, n);
+			res = os_write_file(kernel_fd,
+					    ((char *) io_req_buffer) + written,
+					    n - written);
 			if (res >= 0) {
 				written += res;
 			} else {
-- 
2.20.1




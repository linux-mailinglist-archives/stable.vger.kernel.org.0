Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF083C478A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhGLGdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236377AbhGLGbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35AE3610FA;
        Mon, 12 Jul 2021 06:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071347;
        bh=uKCn08mFNTDEs2VDHheiX5A27DDjKgQICietutQ1vXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrwcWldt1dN09ueAKEFZoWKNRI27/5ZTx59oJTkrRkycLxIEMxiK+EvyqZTbUYelR
         hX/+TIsTf0iyNNLS2PfS5Ze1dcHOBVta/1lnu+rozpc2j1h5XZcBmZnel6LdqGQJXy
         J5x0tq6Kr3Q4aOD0IyJ7cf/e+RgYq7RQa5GCJrs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 032/593] [xarray] iov_iter_fault_in_readable() should do nothing in xarray case
Date:   Mon, 12 Jul 2021 08:03:12 +0200
Message-Id: <20210712060846.711181815@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 0e8f0d67401589a141950856902c7d0ec8d9c985 upstream.

... and actually should just check it's given an iovec-backed iterator
in the first place.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/iov_iter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -434,7 +434,7 @@ int iov_iter_fault_in_readable(struct io
 	int err;
 	struct iovec v;
 
-	if (!(i->type & (ITER_BVEC|ITER_KVEC))) {
+	if (iter_is_iovec(i)) {
 		iterate_iovec(i, bytes, v, iov, skip, ({
 			err = fault_in_pages_readable(v.iov_base, v.iov_len);
 			if (unlikely(err))



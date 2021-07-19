Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11D3CD77F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbhGSORB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241729AbhGSOQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1857A610D2;
        Mon, 19 Jul 2021 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706657;
        bh=I571YPo00Y1iW2EkPSB4vjU3c0tNYyBsoATlg8SU2SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IqIihuq6zZ+8P6CfTODsLWT0FSKgLXF6QKIGAs/pYcdI+RMIWAHdaUARqr+Bi3rV
         Kt5Ls3XPBF1QKdzIuFgSbJpnnbyLNuVwNZ5FDMid5F4yTsGSSxsKtcpMCjnNHRQTW1
         siHuKrD/61UmpzLmSirkGQgAVWiKvsB5pje0D5wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.4 008/188] [xarray] iov_iter_fault_in_readable() should do nothing in xarray case
Date:   Mon, 19 Jul 2021 16:49:52 +0200
Message-Id: <20210719144914.999967305@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
@@ -311,7 +311,7 @@ int iov_iter_fault_in_readable(struct io
 	int err;
 	struct iovec v;
 
-	if (!(i->type & (ITER_BVEC|ITER_KVEC))) {
+	if (iter_is_iovec(i)) {
 		iterate_iovec(i, bytes, v, iov, skip, ({
 			err = fault_in_multipages_readable(v.iov_base,
 					v.iov_len);



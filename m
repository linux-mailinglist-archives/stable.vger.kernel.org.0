Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BD53CDA8D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243937AbhGSOg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242934AbhGSOfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B48DF61073;
        Mon, 19 Jul 2021 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707742;
        bh=F0w0s7w+eNqG3dW22PiqmAiIK3HNiG8ONcVUQHSGjoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwdeaSdJUCjDS1uHUMB75uxcvQAEAvRn6+KLM/WTn/VnVxugqeJRH8zcYyFF4P9GJ
         KcnhZvcTJf6YIxcR/e548H+SDVlAMpsfewCC446+guZJtOdUtmIfYCWLtSlk6fieG3
         jWrMP4BbbVxtqJFjWQTHMKGnhcqOTcvjZ7yi0Qzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.14 008/315] [xarray] iov_iter_fault_in_readable() should do nothing in xarray case
Date:   Mon, 19 Jul 2021 16:48:17 +0200
Message-Id: <20210719144943.147494793@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
@@ -417,7 +417,7 @@ int iov_iter_fault_in_readable(struct io
 	int err;
 	struct iovec v;
 
-	if (!(i->type & (ITER_BVEC|ITER_KVEC))) {
+	if (iter_is_iovec(i)) {
 		iterate_iovec(i, bytes, v, iov, skip, ({
 			err = fault_in_pages_readable(v.iov_base, v.iov_len);
 			if (unlikely(err))



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3931A2F9E63
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390464AbhARLi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390431AbhARLiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4AB722B48;
        Mon, 18 Jan 2021 11:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969800;
        bh=iHSkN9xp5sledIAznCv/z8d5eSdg8jx0XvfifiAQIxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPg9nKdP5m5g0MiFFaJj/OFhX2J7o1Gk0ScmTMBYnMtB8dMYllhNwVl21sonfTlWr
         9UcsWZtcQFydXtWnRNxiXN8r8rYaR4Gl+DGXRPl3lV0iLCSW2GHPz/1k0bNO01LG9K
         QGZEmK0lsbo9XTTEodohrcGn4ahR/oaiHXB9SDQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 31/43] NFS/pNFS: Fix a leak of the layout plh_outstanding counter
Date:   Mon, 18 Jan 2021 12:34:54 +0100
Message-Id: <20210118113336.453327439@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit cb2856c5971723910a86b7d1d0cf623d6919cbc4 upstream.

If we exit _lgopen_prepare_attached() without setting a layout, we will
currently leak the plh_outstanding counter.

Fixes: 411ae722d10a ("pNFS: Wait for stale layoutget calls to complete in pnfs_update_layout()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2147,6 +2147,7 @@ static void _lgopen_prepare_attached(str
 					     &rng, GFP_KERNEL);
 	if (!lgp) {
 		pnfs_clear_first_layoutget(lo);
+		nfs_layoutget_end(lo);
 		pnfs_put_layout_hdr(lo);
 		return;
 	}



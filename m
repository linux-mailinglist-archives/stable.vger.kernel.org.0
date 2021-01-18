Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3D82F9F87
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391439AbhARM06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390847AbhARLpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5235422D6F;
        Mon, 18 Jan 2021 11:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970316;
        bh=8CMz/bME5YdXX6mQsDZ4Gcjcpskr5q6ee6RmYiymFR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oDDVjRQ+1rWA89VsCsdSzFeu0nXjJwL4bwHgp1x4l9rAZVY4oPCND1IzbvSElrJG
         CRw+FpiYgnTx5SYJcLAD19b3+KulX+Rh0RbX0XO2YuiMNs77/iAIh0i8XoMzdkbcU7
         ZknN7XNRzgSwrXtW/HbywFKlYlnzlWCVlG+SePHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 128/152] NFS/pNFS: Fix a leak of the layout plh_outstanding counter
Date:   Mon, 18 Jan 2021 12:35:03 +0100
Message-Id: <20210118113358.859203240@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
@@ -2245,6 +2245,7 @@ static void _lgopen_prepare_attached(str
 					     &rng, GFP_KERNEL);
 	if (!lgp) {
 		pnfs_clear_first_layoutget(lo);
+		nfs_layoutget_end(lo);
 		pnfs_put_layout_hdr(lo);
 		return;
 	}



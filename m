Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A0B2FA96C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393739AbhARS5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:57:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390623AbhARLka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D282223E;
        Mon, 18 Jan 2021 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970014;
        bh=u/dJKaleSbyEGEYN9JJqcsV87cG+q62wlSBasnOqUtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKIddApcWy2dJCJZ3Vj/bxZIQT2RohaKU0TalsmRbYoTXWh1hEl0HOYUQ977Z9/qj
         Sq7/+Z60YmCX0iAI4tSVSUrbQlrMBoypDIuAfM3nuKRj1TBFvHuyrN69bj7gvto3W6
         aYcTHHGTr3yyWoF6riRjCN64tREZbvThEbgQQyVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 59/76] NFS/pNFS: Fix a leak of the layout plh_outstanding counter
Date:   Mon, 18 Jan 2021 12:34:59 +0100
Message-Id: <20210118113343.798707597@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -2215,6 +2215,7 @@ static void _lgopen_prepare_attached(str
 					     &rng, GFP_KERNEL);
 	if (!lgp) {
 		pnfs_clear_first_layoutget(lo);
+		nfs_layoutget_end(lo);
 		pnfs_put_layout_hdr(lo);
 		return;
 	}



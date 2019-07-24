Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A1374634
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391061AbfGYFnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391068AbfGYFnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E32121850;
        Thu, 25 Jul 2019 05:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033418;
        bh=SmSxi14AoMHKWYqCMhqZheNF2R5QiOX/e7UiVlLGLzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBUClhNwVP1SmcEcGbML2ZLL9wF9uQHlk/f+LGl7KPFUdT19+F51ksFYyl+2kc9FJ
         z1J6ah3Wre3XmADOb441tEY4dQmHCMkLGsBQd5ReqFxagSrqPk+/YlZkbQNBNhOnJR
         jlLtnuMNFwrbjUSDnuzxOaZGEwJnfMfYG6bNZMjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 200/271] pnfs/flexfiles: Fix PTR_ERR() dereferences in ff_layout_track_ds_error
Date:   Wed, 24 Jul 2019 21:21:09 +0200
Message-Id: <20190724191712.240675847@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 8e04fdfadda75a849c649f7e50fe7d97772e1fcb upstream.

mirror->mirror_ds can be NULL if uninitialised, but can contain
a PTR_ERR() if call to GETDEVICEINFO failed.

Fixes: 65990d1afbd2 ("pNFS/flexfiles: Fix a deadlock on LAYOUTGET")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # 4.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/flexfilelayout/flexfilelayoutdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -307,7 +307,7 @@ int ff_layout_track_ds_error(struct nfs4
 	if (status == 0)
 		return 0;
 
-	if (mirror->mirror_ds == NULL)
+	if (IS_ERR_OR_NULL(mirror->mirror_ds))
 		return -EINVAL;
 
 	dserr = kmalloc(sizeof(*dserr), gfp_flags);



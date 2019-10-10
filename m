Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542DDD2397
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388842AbfJJIn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388809AbfJJIn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:43:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD6DB21A4A;
        Thu, 10 Oct 2019 08:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697037;
        bh=wWycjSe87ABTArlAOL+ByNftzpQs1CTCAGwPbq6zjpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5EAKk90js6e4OdjR1ZNh/ySa6lkP8Fjdcz4StJBH4Tig3PJ6N2iXAM82LW3RuRn3
         Kj91BeTIks52P5UONG9whGYqAASnI2pj0JJ2G5QOUSucGuZoZamlbklFwd2uATPV/i
         n5P2SdkDG2QNswbHfJ2un+HXRUZjWKnEscmHgeVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.3 145/148] staging: erofs: add two missing erofs_workgroup_put for corrupted images
Date:   Thu, 10 Oct 2019 10:36:46 +0200
Message-Id: <20191010083621.070554441@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 138e1a0990e80db486ab9f6c06bd5c01f9a97999 upstream.

As reported by erofs-utils fuzzer, these error handling
path will be entered to handle corrupted images.

Lack of erofs_workgroup_puts will cause unmounting
unsuccessfully.

Fix these return values to EFSCORRUPTED as well.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-4-gaoxiang25@huawei.com
[ Gao Xiang: Older kernel versions don't have length validity check
             and EFSCORRUPTED, thus backport pageofs check for now. ]
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/unzip_vle.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -393,7 +393,11 @@ z_erofs_vle_work_lookup(const struct z_e
 	/* if multiref is disabled, `primary' is always true */
 	primary = true;
 
-	DBG_BUGON(work->pageofs != f->pageofs);
+	if (work->pageofs != f->pageofs) {
+		DBG_BUGON(1);
+		erofs_workgroup_put(egrp);
+		return ERR_PTR(-EIO);
+	}
 
 	/*
 	 * lock must be taken first to avoid grp->next == NIL between



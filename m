Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DA42A161F
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgJaLmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgJaLmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5656320719;
        Sat, 31 Oct 2020 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144522;
        bh=cGhOKTRW40cD0lhMTa4QTllFZlDMJSEHYok7z5/T8jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s396n0HOkZ0VJmId4QnM3C4vQ+FoHhayheJDOi0FoUh4vNOZ5FIpwWF+0xdXkgXHl
         jQ/rDvMudXOzTxqGr4QnTIm+CMQ6ZSaRTIWDlODMvu0x8+t85ZxnvZt34BNxWhpYLA
         Hkebixb6eILLO9wmGwZ+RLrMili4VJuvHFP2Xq/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongyu Jin <hongyu.jin@unisoc.com>,
        Chao Yu <yuchao0@huawei.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.8 49/70] erofs: avoid duplicated permission check for "trusted." xattrs
Date:   Sat, 31 Oct 2020 12:36:21 +0100
Message-Id: <20201031113501.848403905@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit d578b46db69d125a654f509bdc9091d84e924dc8 upstream.

Don't recheck it since xattr_permission() already
checks CAP_SYS_ADMIN capability.

Just follow 5d3ce4f70172 ("f2fs: avoid duplicated permission check for "trusted." xattrs")

Reported-by: Hongyu Jin <hongyu.jin@unisoc.com>
[ Gao Xiang: since it could cause some complex Android overlay
  permission issue as well on android-5.4+, it'd be better to
  backport to 5.4+ rather than pure cleanup on mainline. ]
Cc: <stable@vger.kernel.org> # 5.4+
Link: https://lore.kernel.org/r/20200811070020.6339-1-hsiangkao@redhat.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/erofs/xattr.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -473,8 +473,6 @@ static int erofs_xattr_generic_get(const
 			return -EOPNOTSUPP;
 		break;
 	case EROFS_XATTR_INDEX_TRUSTED:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
 		break;
 	case EROFS_XATTR_INDEX_SECURITY:
 		break;



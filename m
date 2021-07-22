Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FAE3D28FB
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhGVQAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232927AbhGVP7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5188610F7;
        Thu, 22 Jul 2021 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972027;
        bh=MpoZvcM/5BK8c+vc/7urRevLkFZIw8q0tlEIgfHqjC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPPEymlAwXkC0XQoRm9onMkZOmsyW6pN/BFY5RZVR3cBRjecNeOxqgJ+NdV2+4y/+
         rWP4zuCAkCXR2tiQk/L4Ln+KaHKhECkMf3lOTxVCQ78uyWyPmCSib78rkSYXnglV1o
         DdrwdiqkI9RTAgLOrrr4F7RoSjT1FZX0QFzWsmes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 084/125] f2fs: Show casefolding support only when supported
Date:   Thu, 22 Jul 2021 18:31:15 +0200
Message-Id: <20210722155627.482328533@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

commit 39307f8ee3539478c28e71b4909b5b028cce14b1 upstream.

The casefolding feature is only supported when CONFIG_UNICODE is set.
This modifies the feature list f2fs presents under sysfs accordingly.

Fixes: 5aba54302a46 ("f2fs: include charset encoding information in the superblock")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Daniel Rosenberg <drosen@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -612,7 +612,9 @@ F2FS_FEATURE_RO_ATTR(lost_found, FEAT_LO
 F2FS_FEATURE_RO_ATTR(verity, FEAT_VERITY);
 #endif
 F2FS_FEATURE_RO_ATTR(sb_checksum, FEAT_SB_CHECKSUM);
+#ifdef CONFIG_UNICODE
 F2FS_FEATURE_RO_ATTR(casefold, FEAT_CASEFOLD);
+#endif
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 F2FS_FEATURE_RO_ATTR(compression, FEAT_COMPRESSION);
 #endif
@@ -700,7 +702,9 @@ static struct attribute *f2fs_feat_attrs
 	ATTR_LIST(verity),
 #endif
 	ATTR_LIST(sb_checksum),
+#ifdef CONFIG_UNICODE
 	ATTR_LIST(casefold),
+#endif
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	ATTR_LIST(compression),
 #endif



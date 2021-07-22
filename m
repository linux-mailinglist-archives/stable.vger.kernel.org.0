Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA013D27F1
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhGVPx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230310AbhGVPxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C960361363;
        Thu, 22 Jul 2021 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971654;
        bh=3FYz4SJJq6mYJ/XSExS4oyCjehrzy/jBEMzzP47kME4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/kzXYhbO9hQh+Xj0C4w/k6vZltdNGXO3K3dsnP790oLgaPsoAY/fFQM4UlFVwOCI
         6cVJiG2INu773HU070fHGuJcS+fHzl/F8gjylkG+N4sd58lQptb566txLzudXdO5S4
         B0kLKVnrs4qCkKHMng6MP+8T1EjYjOMEydE0QfDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 48/71] f2fs: Show casefolding support only when supported
Date:   Thu, 22 Jul 2021 18:31:23 +0200
Message-Id: <20210722155619.471159512@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -499,7 +499,9 @@ F2FS_FEATURE_RO_ATTR(lost_found, FEAT_LO
 F2FS_FEATURE_RO_ATTR(verity, FEAT_VERITY);
 #endif
 F2FS_FEATURE_RO_ATTR(sb_checksum, FEAT_SB_CHECKSUM);
+#ifdef CONFIG_UNICODE
 F2FS_FEATURE_RO_ATTR(casefold, FEAT_CASEFOLD);
+#endif
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
@@ -568,7 +570,9 @@ static struct attribute *f2fs_feat_attrs
 	ATTR_LIST(verity),
 #endif
 	ATTR_LIST(sb_checksum),
+#ifdef CONFIG_UNICODE
 	ATTR_LIST(casefold),
+#endif
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs_feat);



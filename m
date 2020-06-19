Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB92200EE6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392167AbgFSPMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392164AbgFSPMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:12:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054A7206FA;
        Fri, 19 Jun 2020 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579560;
        bh=RTFHDTDn9cZ+Wm9DgGSO8r9TEyLNqlMrJWr1Kv2pi7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtiTc1/k/J/Tvy9/9D/NvBd9tjAPGgDUVp4IAzhF/12Pn0A38H6TrDu9RMEnpJlly
         iPjA3GikeomDSABwg4qo8QoxNXyNyobzzOWrRCmiuBdZRiJccabZvphdpmyAKJYcAx
         rbWz99ZTC2XnbU0CikxPm7Usgx3PP0g7+CfNc7IM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.4 181/261] ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max
Date:   Fri, 19 Jun 2020 16:33:12 +0200
Message-Id: <20200619141658.596612034@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

commit c36a71b4e35ab35340facdd6964a00956b9fef0a upstream.

If eh->eh_max is 0, EXT_MAX_EXTENT/INDEX would evaluate to unsigned
(-1) resulting in illegal memory accesses. Although there is no
consistent repro, we see that generic/019 sometimes crashes because of
this bug.

Ran gce-xfstests smoke and verified that there were no regressions.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20200421023959.20879-2-harshadshirwadkar@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4_extents.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -170,10 +170,13 @@ struct partial_cluster {
 	(EXT_FIRST_EXTENT((__hdr__)) + le16_to_cpu((__hdr__)->eh_entries) - 1)
 #define EXT_LAST_INDEX(__hdr__) \
 	(EXT_FIRST_INDEX((__hdr__)) + le16_to_cpu((__hdr__)->eh_entries) - 1)
-#define EXT_MAX_EXTENT(__hdr__) \
-	(EXT_FIRST_EXTENT((__hdr__)) + le16_to_cpu((__hdr__)->eh_max) - 1)
+#define EXT_MAX_EXTENT(__hdr__)	\
+	((le16_to_cpu((__hdr__)->eh_max)) ? \
+	((EXT_FIRST_EXTENT((__hdr__)) + le16_to_cpu((__hdr__)->eh_max) - 1)) \
+					: 0)
 #define EXT_MAX_INDEX(__hdr__) \
-	(EXT_FIRST_INDEX((__hdr__)) + le16_to_cpu((__hdr__)->eh_max) - 1)
+	((le16_to_cpu((__hdr__)->eh_max)) ? \
+	((EXT_FIRST_INDEX((__hdr__)) + le16_to_cpu((__hdr__)->eh_max) - 1)) : 0)
 
 static inline struct ext4_extent_header *ext_inode_hdr(struct inode *inode)
 {



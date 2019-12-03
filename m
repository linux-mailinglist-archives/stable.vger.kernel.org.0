Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F741111EF4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfLCWtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbfLCWtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609AF20684;
        Tue,  3 Dec 2019 22:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413360;
        bh=ABAw+0UN3/JtufQLU7PxhHLTB+FOGf2VHn3pTd88+wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVq6jTTHM9fNRSs9L9e4ODYFYrkyhqYb5iCoDNZRST88PuwuQGoXZ65jVDyL2H2Jq
         RvDnZcHJspmb0BTC6ly0eBWLjpDmc9PlZpeaeqfTkDtJ+KK+mkSmCx0vR6j46XcRWf
         WAiLGEh8N7Oo/ow+D5kT1SBS+27pZHDF0DJVI/W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/321] ubifs: Fix default compression selection in ubifs
Date:   Tue,  3 Dec 2019 23:32:45 +0100
Message-Id: <20191203223432.306953012@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

[ Upstream commit d62e98ed1efcaa94caa004f622944afdce5f1c3c ]

When ubifs is build without the LZO compressor and no compressor is
given the creation of the default file system will fail. before
selection the LZO compressor check if it is present and if not fall back
to the zlib or none.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/sb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index bf17f58908ff9..11dc3977fb64f 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -63,6 +63,17 @@
 /* Default time granularity in nanoseconds */
 #define DEFAULT_TIME_GRAN 1000000000
 
+static int get_default_compressor(struct ubifs_info *c)
+{
+	if (ubifs_compr_present(c, UBIFS_COMPR_LZO))
+		return UBIFS_COMPR_LZO;
+
+	if (ubifs_compr_present(c, UBIFS_COMPR_ZLIB))
+		return UBIFS_COMPR_ZLIB;
+
+	return UBIFS_COMPR_NONE;
+}
+
 /**
  * create_default_filesystem - format empty UBI volume.
  * @c: UBIFS file-system description object
@@ -186,7 +197,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	if (c->mount_opts.override_compr)
 		sup->default_compr = cpu_to_le16(c->mount_opts.compr_type);
 	else
-		sup->default_compr = cpu_to_le16(UBIFS_COMPR_LZO);
+		sup->default_compr = cpu_to_le16(get_default_compressor(c));
 
 	generate_random_uuid(sup->uuid);
 
-- 
2.20.1




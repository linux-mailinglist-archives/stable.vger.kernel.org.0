Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3791CAB2D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgEHMk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbgEHMk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E1E620731;
        Fri,  8 May 2020 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941655;
        bh=QY6zjb2V3OOit3k+wXRi5I37kh5E4q5iqa6I1WeszCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJ9WKZuCszui/0xrVUHiCdfhrA+nFGJwJ7+fZCRRafPEC3KGl7RkXfmhz0N4JefOy
         tLaXDPmDKXJCiWdSyVkwtwQzgIhSQ/4ABQJzsxB2lGDkY+oAuiQtJ7VV6trIxJvQXs
         kEQ7+XD4eAsSit9YR+EvNNowl/ddfXku/FATwQDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 120/312] Btrfs: clean up an error code in btrfs_init_space_info()
Date:   Fri,  8 May 2020 14:31:51 +0200
Message-Id: <20200508123132.897559635@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0dc924c5f2a3c4d999e12feaccee5f970cea1315 upstream.

If we return 1 here, then the caller treats it as an error and returns
-EINVAL.  It causes a static checker warning to treat positive returns
as an error.

Fixes: 1aba86d67f34 ('Btrfs: fix easily get into ENOSPC in mixed case')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10688,7 +10688,7 @@ int btrfs_init_space_info(struct btrfs_f
 
 	disk_super = fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
-		return 1;
+		return -EINVAL;
 
 	features = btrfs_super_incompat_flags(disk_super);
 	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)



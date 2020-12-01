Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B1E2C9AFE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbgLAJEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388742AbgLAJEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869E021D7A;
        Tue,  1 Dec 2020 09:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813401;
        bh=veCYHlh7l15PtiqJIlmQ6yp5nRxo44mzuSK+BrP1wuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4LPKDwu8qBU8vXfFaJF5a7RdzcFQUQ01bEdtinjvNEi691RBQtqWl3oUpkbC3bmE
         2HwoyTDdYIQm1+92e8BA3+o0qg4yN24Z/ZGdXMsiqx9T/D8YOwgaUVYYgHx/4nvJdd
         /SnGRNm1TaQZDfz0nJYqdqo2TZ+m+CiaWMmJX9gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 06/98] btrfs: tree-checker: add missing returns after data_ref alignment checks
Date:   Tue,  1 Dec 2020 09:52:43 +0100
Message-Id: <20201201084653.476053306@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 6d06b0ad94d3dd7e3503d8ad39c39c4634884611 upstream.

There are sectorsize alignment checks that are reported but then
check_extent_data_ref continues. This was not intended, wrong alignment
is not a minor problem and we should return with error.

CC: stable@vger.kernel.org # 5.4+
Fixes: 0785a9aacf9d ("btrfs: tree-checker: Add EXTENT_DATA_REF check")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-checker.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1269,6 +1269,7 @@ static int check_extent_data_ref(struct
 	"invalid item size, have %u expect aligned to %zu for key type %u",
 			    btrfs_item_size_nr(leaf, slot),
 			    sizeof(*dref), key->type);
+		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(key->objectid, leaf->fs_info->sectorsize)) {
 		generic_err(leaf, slot,
@@ -1297,6 +1298,7 @@ static int check_extent_data_ref(struct
 			extent_err(leaf, slot,
 	"invalid extent data backref offset, have %llu expect aligned to %u",
 				   offset, leaf->fs_info->sectorsize);
+			return -EUCLEAN;
 		}
 	}
 	return 0;



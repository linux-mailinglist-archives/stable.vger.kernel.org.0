Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B9A2C9B23
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388751AbgLAJEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388738AbgLAJEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D592206CA;
        Tue,  1 Dec 2020 09:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813398;
        bh=ttanmKkrCmET5nkKpnPcnHxoo6ESwqLAC67eTlRmYgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwyRjRTa9DmndIuI0rjRt7Yct4Bi4BxiwDvwN3Tra4vNDG84NCcr9J4d/MClZV8xT
         wq54op2UspnKOoEnYkgm0ZE0ox1/GrIK3akBIVZJjsoczL7s1h0pvPwq+ko9BcFygO
         jA/XCu2m7r8RSEjw7iMpiHrRyFWdOagH/cr8Pj1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Daniel Xu <dxu@dxuuu.xyz>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 05/98] btrfs: tree-checker: add missing return after error in root_item
Date:   Tue,  1 Dec 2020 09:52:42 +0100
Message-Id: <20201201084653.336936280@linuxfoundation.org>
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

From: Daniel Xu <dxu@dxuuu.xyz>

commit 1a49a97df657c63a4e8ffcd1ea9b6ed95581789b upstream.

There's a missing return statement after an error is found in the
root_item, this can cause further problems when a crafted image triggers
the error.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210181
Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-checker.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -913,6 +913,7 @@ static int check_root_item(struct extent
 			    "invalid root item size, have %u expect %zu or %u",
 			    btrfs_item_size_nr(leaf, slot), sizeof(ri),
 			    btrfs_legacy_root_item_size());
+		return -EUCLEAN;
 	}
 
 	/*



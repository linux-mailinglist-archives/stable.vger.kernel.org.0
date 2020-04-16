Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DD01AC922
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442406AbgDPPTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390133AbgDPNsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:48:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8C72222C;
        Thu, 16 Apr 2020 13:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044882;
        bh=zIhIZGj24O1o982in8b2nseAv+Soag+2J7fvks+6GeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTUMgahuGmk2EneIrzIOwq4woo6zR/GXCsFfs8lM2+E6Tmx0mRb3QCE/hasMefqUo
         xlvnM+m53V0BxssjiHp0yLHas1L5EhtODf0aKdqhL/XQbKdWUw72f955UCKE/aUSKN
         PLFiwghXFxfXoQdYwiditmBwMUJXVw0JiWVWQ0zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 141/232] btrfs: drop block from cache on error in relocation
Date:   Thu, 16 Apr 2020 15:23:55 +0200
Message-Id: <20200416131332.620071433@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 8e19c9732ad1d127b5575a10f4fbcacf740500ff upstream.

If we have an error while building the backref tree in relocation we'll
process all the pending edges and then free the node.  However if we
integrated some edges into the cache we'll lose our link to those edges
by simply freeing this node, which means we'll leak memory and
references to any roots that we've found.

Instead we need to use remove_backref_node(), which walks through all of
the edges that are still linked to this node and free's them up and
drops any root references we may be holding.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1186,7 +1186,7 @@ out:
 			free_backref_node(cache, lower);
 		}
 
-		free_backref_node(cache, node);
+		remove_backref_node(cache, node);
 		return ERR_PTR(err);
 	}
 	ASSERT(!node || !node->detached);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C741B421D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgDVK6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgDVKEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3AF2075A;
        Wed, 22 Apr 2020 10:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549873;
        bh=b7CWP8ILYjNqGavujzzxfi1GfBdxFbOnepxjuINjK0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fytz9uwV5RjQKO9rjSIcXK5WVcgT4VekuzuROAYbT3rcUTj7RVsvP0dWAdL/ORgGw
         hMPvjMh4YaQoYxmXNlFWsf25rFVcS+LhQqiwPDnpDgRjZAZaFI3ocfoRQR2I3B1FOE
         W0eH3CtY41U1MiXbHmXM5uCuOc5w0WtoDzIi/36Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 040/125] btrfs: drop block from cache on error in relocation
Date:   Wed, 22 Apr 2020 11:55:57 +0200
Message-Id: <20200422095040.007612140@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
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
@@ -1185,7 +1185,7 @@ out:
 			free_backref_node(cache, lower);
 		}
 
-		free_backref_node(cache, node);
+		remove_backref_node(cache, node);
 		return ERR_PTR(err);
 	}
 	ASSERT(!node || !node->detached);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1241B6993
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgDWXYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48270 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726173AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004aF-C5; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6gM-Ev; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Josef Bacik" <jbacik@fb.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "David Sterba" <dsterba@suse.com>, "Chris Mason" <clm@fb.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Omar Sandoval" <osandov@fb.com>
Date:   Fri, 24 Apr 2020 00:04:15 +0100
Message-ID: <lsq.1587683028.177362028@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 028/245] Btrfs: fix em leak in find_first_block_group
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 187ee58c62c1d0d238d3dc4835869d33e1869906 upstream.

We need to call free_extent_map() on the em we look up.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8587,6 +8587,7 @@ static int find_first_block_group(struct
 			} else {
 				ret = 0;
 			}
+			free_extent_map(em);
 			goto out;
 		}
 		path->slots[0]++;


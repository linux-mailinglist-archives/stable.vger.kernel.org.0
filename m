Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300BF42698E
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbhJHLjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240555AbhJHLgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 404B96101A;
        Fri,  8 Oct 2021 11:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692749;
        bh=/vMdnTGIRNxo4mGYHll6b4s9a8WgufEfVbRp/DlK4b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OneRfH21d3TL2doDeaIM9vjn+MA+On3yjXVwpQjJWFmZrbKNadr+x8eymjy5ADj3
         V3avtS6qUuyCs6CrbCIm3JmVst4LN1GZHdUWDx73QFEF0t+olQ4Wu/q2cyFAGZULYZ
         kE7WY1MR5wnpSMuLdSMA23csKHBQ9nHCOsyPtuGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 27/48] Xen/gntdev: dont ignore kernel unmapping error
Date:   Fri,  8 Oct 2021 13:28:03 +0200
Message-Id: <20211008112720.924493120@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit f28347cc66395e96712f5c2db0a302ee75bafce6 ]

While working on XSA-361 and its follow-ups, I failed to spot another
place where the kernel mapping part of an operation was not treated the
same as the user space part. Detect and propagate errors and add a 2nd
pr_debug().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/c2513395-74dc-aea3-9192-fd265aa44e35@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index a3e7be96527d..23fd09a9bbaf 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,6 +396,14 @@ static int __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
+		if (use_ptemod) {
+			if (map->kunmap_ops[offset+i].status)
+				err = -EINVAL;
+			pr_debug("kunmap handle=%u st=%d\n",
+				 map->kunmap_ops[offset+i].handle,
+				 map->kunmap_ops[offset+i].status);
+			map->kunmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
+		}
 	}
 	return err;
 }
-- 
2.33.0




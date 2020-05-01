Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236D41C15DF
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgEANfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbgEANfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:35:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA4D624957;
        Fri,  1 May 2020 13:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340114;
        bh=IN3dBcosvKC2QUoeyRI6B2svCXNsLO997YBPPyyQJAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OslHfkcKlTBR5hnNN2zkbgDA08uvKqLTnYr7NMiUTEqyKiH/42P8vRyRl9XS7ydwp
         WwZh2wiCeJnIiZvh1iWfO6+XasT7ZEp3N7QksnUBOF4rXw+VHQsVnZ7loBIAe9XfAY
         ezk5WHYxwnzmg11KvjSJdcyo3A/D0I4OiqR2Y2XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Wei Liu <wl@xen.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 104/117] xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant status
Date:   Fri,  1 May 2020 15:22:20 +0200
Message-Id: <20200501131557.809877454@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 6b51fd3f65a22e3d1471b18a1d56247e246edd46 ]

xenbus_map_ring_valloc() maps a ring page and returns the status of the
used grant (0 meaning success).

There are Xen hypervisors which might return the value 1 for the status
of a failed grant mapping due to a bug. Some callers of
xenbus_map_ring_valloc() test for errors by testing the returned status
to be less than zero, resulting in no error detected and crashing later
due to a not available ring page.

Set the return value of xenbus_map_ring_valloc() to GNTST_general_error
in case the grant status reported by Xen is greater than zero.

This is part of XSA-316.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
Link: https://lore.kernel.org/r/20200326080358.1018-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_client.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index a1c17000129ba..e94a61eaeceb0 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -450,7 +450,14 @@ EXPORT_SYMBOL_GPL(xenbus_free_evtchn);
 int xenbus_map_ring_valloc(struct xenbus_device *dev, grant_ref_t *gnt_refs,
 			   unsigned int nr_grefs, void **vaddr)
 {
-	return ring_ops->map(dev, gnt_refs, nr_grefs, vaddr);
+	int err;
+
+	err = ring_ops->map(dev, gnt_refs, nr_grefs, vaddr);
+	/* Some hypervisors are buggy and can return 1. */
+	if (err > 0)
+		err = GNTST_general_error;
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(xenbus_map_ring_valloc);
 
-- 
2.20.1




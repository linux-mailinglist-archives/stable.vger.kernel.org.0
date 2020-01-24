Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4EB214846A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgAXLIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbgAXLId (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:08:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 241A720663;
        Fri, 24 Jan 2020 11:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864112;
        bh=n5y6NUSqH9UbUVIlj2lp0wHdUYXaVAF9y4szbpyBXPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maxzMtcPxm2BjyLRCzp5Aj4tea2H/SwwAQgks5luAIIz7PqmMXNNLY07Tcd6DaVcf
         3XRBKAu9FVkF6Wn+rLX2rqYMQW4+PVAzXffv1ND0us33YyEDJ7CkQBjwEG3jyDKcoS
         JMlm/0QCzuTDveSMnoWa0Za3/UdAK4Eliv5YnWqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/639] driver core: Avoid careless re-use of existing device links
Date:   Fri, 24 Jan 2020 10:25:29 +0100
Message-Id: <20200124093107.110768349@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit f265df550a4350dce0a4d721a77c52e4b847ea40 ]

After commit ead18c23c263 ("driver core: Introduce device links
reference counting"), if there is a link between the given supplier
and the given consumer already, device_link_add() will refcount it
and return it unconditionally.  However, if the flags passed to
it on the second (or any subsequent) attempt to create a device
link between the same consumer-supplier pair are not compatible with
the existing link's flags, that is incorrect.

First off, if the existing link is stateless and the next caller of
device_link_add() for the same consumer-supplier pair wants a
stateful one, or the other way around, the existing link cannot be
returned, because it will not match the expected behavior, so make
device_link_add() dump the stack and return NULL in that case.

Moreover, if the DL_FLAG_AUTOREMOVE_CONSUMER flag is passed to
device_link_add(), its caller will expect its reference to the link
to be dropped automatically on consumer driver removal, which will
not happen if that flag is not set in the link's flags (and
analogously for DL_FLAG_AUTOREMOVE_SUPPLIER).  For this reason, make
device_link_add() update the existing link's flags accordingly
before returning it to the caller.

Fixes: ead18c23c263 ("driver core: Introduce device links reference counting")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 055132f2292aa..562385c47fa44 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -221,12 +221,29 @@ struct device_link *device_link_add(struct device *consumer,
 		goto out;
 	}
 
-	list_for_each_entry(link, &supplier->links.consumers, s_node)
-		if (link->consumer == consumer) {
-			kref_get(&link->kref);
+	list_for_each_entry(link, &supplier->links.consumers, s_node) {
+		if (link->consumer != consumer)
+			continue;
+
+		/*
+		 * Don't return a stateless link if the caller wants a stateful
+		 * one and vice versa.
+		 */
+		if (WARN_ON((flags & DL_FLAG_STATELESS) != (link->flags & DL_FLAG_STATELESS))) {
+			link = NULL;
 			goto out;
 		}
 
+		if (flags & DL_FLAG_AUTOREMOVE_CONSUMER)
+			link->flags |= DL_FLAG_AUTOREMOVE_CONSUMER;
+
+		if (flags & DL_FLAG_AUTOREMOVE_SUPPLIER)
+			link->flags |= DL_FLAG_AUTOREMOVE_SUPPLIER;
+
+		kref_get(&link->kref);
+		goto out;
+	}
+
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
 	if (!link)
 		goto out;
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD18C49A9AF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384181AbiAYD0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445371AbiAXVDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DA9C06B5B3;
        Mon, 24 Jan 2022 12:04:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 307E3B81218;
        Mon, 24 Jan 2022 20:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BB5C340E5;
        Mon, 24 Jan 2022 20:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054637;
        bh=RaPK8Eyr4HE56rbewWn9cmr8Bv4VqvqGAd5d/J3fTwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRB2HHyUF7be83aSlFQIe6AX3kKbjHY6XT6gkLHbX3ZDVw5pfeg9o8HxKvURo196t
         31OnVBqL0gVuPQOfUYCa47lfDzkqEN0LWuYiHY5REs69BEaChuOWXRQaPJIlCn68aw
         HdUjlK4ugOSdELlFdyNMTyi77tFY5sX4FCeRuc+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 454/563] device property: Fix fwnode_graph_devcon_match() fwnode leak
Date:   Mon, 24 Jan 2022 19:43:39 +0100
Message-Id: <20220124184040.143479590@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 4a7f4110f79163fd53ea65438041994ed615e3af upstream.

For each endpoint it encounters, fwnode_graph_devcon_match() checks
whether the endpoint's remote port parent device is available. If it is
not, it ignores the endpoint but does not put the reference to the remote
endpoint port parent fwnode. For available devices the fwnode handle
reference is put as expected.

Put the reference for unavailable devices now.

Fixes: 637e9e52b185 ("device connection: Find device connections also from device graphs")
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1195,8 +1195,10 @@ fwnode_graph_devcon_match(struct fwnode_
 
 	fwnode_graph_for_each_endpoint(fwnode, ep) {
 		node = fwnode_graph_get_remote_port_parent(ep);
-		if (!fwnode_device_is_available(node))
+		if (!fwnode_device_is_available(node)) {
+			fwnode_handle_put(node);
 			continue;
+		}
 
 		ret = match(node, con_id, data);
 		fwnode_handle_put(node);



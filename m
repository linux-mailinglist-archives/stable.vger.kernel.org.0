Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B715499375
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385703AbiAXUeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51508 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382495AbiAXUZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:25:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D928A61382;
        Mon, 24 Jan 2022 20:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B210AC340E5;
        Mon, 24 Jan 2022 20:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055948;
        bh=7DICeP7dnUYHT+NLnmghG3OMqLh6wkc1OgzolyJEbeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtEk6vC0nHnHTLs4S2Dgr230I0XnI6M1DdV9LoCJT+V33mY4T0S9+hfoRXE5hrhKq
         9hV5QtczVxXcqgcNanL5qWdMMdyGLZ2Q18GKn3zuSESM5K33sRaAT4nTPS+U9hiyyl
         IciIX0hiMocl7mJYaj9JF/miJGf2MZL2LVv2VlKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 292/846] software node: fix wrong node passed to find nargs_prop
Date:   Mon, 24 Jan 2022 19:36:49 +0100
Message-Id: <20220124184111.003587646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit c5fc5ba8b6b7bebc05e45036a33405b4c5036c2f ]

nargs_prop refers to a property located in the reference that is found
within the nargs property. Use the correct reference node in call to
property_entry_read_int_array() to retrieve the correct nargs value.

Fixes: b06184acf751 ("software node: Add software_node_get_reference_args()")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index c46f6a8e14d23..3ba1232ce8451 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -535,7 +535,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 		return -ENOENT;
 
 	if (nargs_prop) {
-		error = property_entry_read_int_array(swnode->node->properties,
+		error = property_entry_read_int_array(ref->node->properties,
 						      nargs_prop, sizeof(u32),
 						      &nargs_prop_val, 1);
 		if (error)
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3445499454
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389115AbiAXUk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387634AbiAXUhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:37:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD25C02B8D2;
        Mon, 24 Jan 2022 11:50:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DB1660B11;
        Mon, 24 Jan 2022 19:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A73CC340E5;
        Mon, 24 Jan 2022 19:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053845;
        bh=OJih1Jcf4b2viqGvfEjCDpa3eJtwp2vKJgAcrR28yf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeZhf17qQ2NNAD+2ULRHdKpp+3CBJMtxI5jUwiukYDt0MqU+KAnOmtq1xf7WArn0I
         YzVVtkngUHZnYQF/L/6iVF30tCW7T9iv+R4yfI61LJR3aT9t0HtUIFEEA6i8SkC6lo
         KEWG1KRqAPl37xyyZxDbtP27hjI2e89PiS+Ih6rQ=
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
Subject: [PATCH 5.10 195/563] software node: fix wrong node passed to find nargs_prop
Date:   Mon, 24 Jan 2022 19:39:20 +0100
Message-Id: <20220124184031.178454245@linuxfoundation.org>
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
index 206bd4d7d7e23..d2fb3eb5816c3 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -519,7 +519,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 		return -ENOENT;
 
 	if (nargs_prop) {
-		error = property_entry_read_int_array(swnode->node->properties,
+		error = property_entry_read_int_array(ref->node->properties,
 						      nargs_prop, sizeof(u32),
 						      &nargs_prop_val, 1);
 		if (error)
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C02537C6BE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhELPx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235628AbhELPtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29DEF61554;
        Wed, 12 May 2021 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833132;
        bh=fZpUI3rCz+6dYp5VJQxrFTMQ6aYotIr8A3eRsTA98Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wn2GWrnAJr4Pf3lZZi6UbWICDB2930lk2g2PhEGQbwnlJPe8GBr5md/baKEsyKs6z
         WTH9DcCBOy0tm3BWVfCkBE2W8v3PlkLtmaortql3ijAYtBylq9aufaCzNnvxg3ivkt
         xHG4NeORohHO9DNvnxMQ3VYbeEBGhL5bjCb3Oj7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.11 006/601] usb: roles: Call try_module_get() from usb_role_switch_find_by_fwnode()
Date:   Wed, 12 May 2021 16:41:23 +0200
Message-Id: <20210512144828.033344904@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 3a2a91a2d51761557843996a66098eb7182b48b4 upstream.

usb_role_switch_find_by_fwnode() returns a reference to the role-switch
which must be put by calling usb_role_switch_put().

usb_role_switch_put() calls module_put(sw->dev.parent->driver->owner),
add a matching try_module_get() to usb_role_switch_find_by_fwnode(),
making it behave the same as the other usb_role_switch functions
which return a reference.

This avoids a WARN_ON being hit at kernel/module.c:1158 due to the
module-refcount going below 0.

Fixes: c6919d5e0cd1 ("usb: roles: Add usb_role_switch_find_by_fwnode()")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210409124136.65591-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -189,6 +189,8 @@ usb_role_switch_find_by_fwnode(const str
 		return NULL;
 
 	dev = class_find_device_by_fwnode(role_class, fwnode);
+	if (dev)
+		WARN_ON(!try_module_get(dev->parent->driver->owner));
 
 	return dev ? to_role_switch(dev) : NULL;
 }



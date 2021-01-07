Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3E32ED2CA
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbhAGOhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:37:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46235 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbhAGOcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C11D42339F;
        Thu,  7 Jan 2021 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029865;
        bh=4x0SBRPSAB8n2LXqFve1WbygbDfp1EtedWhGfC9a91I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C49yDeNnpD46aNY3yNdQ7Ao1hXpCsXhbAj/D9LW+zZEEgXXcuuDUj/Qq78l7xSxWf
         Sg852NECS0VSVTBQeTCf0XScOOl3+rD9SgpG7hkaWl25cVyyBe3jG6CtAYKvsQnLLd
         YDwMG/QCC5XqsCn7PtarF0oqndnSN9QSLlMUG58I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/29] module: delay kobject uevent until after module init call
Date:   Thu,  7 Jan 2021 15:31:38 +0100
Message-Id: <20210107143056.245832583@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Yu <jeyu@kernel.org>

[ Upstream commit 38dc717e97153e46375ee21797aa54777e5498f3 ]

Apparently there has been a longstanding race between udev/systemd and
the module loader. Currently, the module loader sends a uevent right
after sysfs initialization, but before the module calls its init
function. However, some udev rules expect that the module has
initialized already upon receiving the uevent.

This race has been triggered recently (see link in references) in some
systemd mount unit files. For instance, the configfs module creates the
/sys/kernel/config mount point in its init function, however the module
loader issues the uevent before this happens. sys-kernel-config.mount
expects to be able to mount /sys/kernel/config upon receipt of the
module loading uevent, but if the configfs module has not called its
init function yet, then this directory will not exist and the mount unit
fails. A similar situation exists for sys-fs-fuse-connections.mount, as
the fuse sysfs mount point is created during the fuse module's init
function. If udev is faster than module initialization then the mount
unit would fail in a similar fashion.

To fix this race, delay the module KOBJ_ADD uevent until after the
module has finished calling its init routine.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-By: Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index c4f0a8fe144e1..0b2654592d3a7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1789,7 +1789,6 @@ static int mod_sysfs_init(struct module *mod)
 	if (err)
 		mod_kobject_put(mod);
 
-	/* delay uevent until full sysfs population */
 out:
 	return err;
 }
@@ -1826,7 +1825,6 @@ static int mod_sysfs_setup(struct module *mod,
 	add_sect_attrs(mod, info);
 	add_notes_attrs(mod, info);
 
-	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
 	return 0;
 
 out_unreg_modinfo_attrs:
@@ -3481,6 +3479,9 @@ static noinline int do_init_module(struct module *mod)
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
+	/* Delay uevent until module has finished its init routine */
+	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
+
 	/*
 	 * We need to finish all async code before the module init sequence
 	 * is done.  This has potential to deadlock.  For example, a newly
-- 
2.27.0




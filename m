Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE42A2E7909
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgL3NFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbgL3NFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03EA722475;
        Wed, 30 Dec 2020 13:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333500;
        bh=WR7hUBwMacnTaiAjrNtBAehlzFo9ES5p+iOWVDWTonA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Py0bG8NUFPxIkv01KFhEzj47EhqMqZNt5RZwL/zAJ3dAz/y+AmujZaIYK08lWK/1q
         JIIGH8ly3eKHzFd0xIkdHG3m21wi4eMwRqJmPacmg5mgooFmgFNJNsKe+e89EyRv/t
         bjQ5xnGFDJV3IfXLt0T805rZWQwHKDsHe2JGiyP8+CinX1tW5QbsczvL6d7DtjXGMl
         B/uCZDafsnDCq22/llQM8pBZWexdqhXkdyXzz50+YgiheTAPndz3FK4LLTnoZFFTNE
         5xWoExcTu9znQ8IPGwR7GkaJIX/PCBygSvN+mxP/+0e5iBPNqEwJND4BoutB7Tja6p
         w96pT+fHeVzew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jessica Yu <jeyu@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 5/5] module: delay kobject uevent until after module init call
Date:   Wed, 30 Dec 2020 08:04:54 -0500
Message-Id: <20201230130454.3637785-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130454.3637785-1-sashal@kernel.org>
References: <20201230130454.3637785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

References: https://github.com/systemd/systemd/issues/17586
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-By: Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index dcfc811d9ae2d..e6afc950357a5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1779,7 +1779,6 @@ static int mod_sysfs_init(struct module *mod)
 	if (err)
 		mod_kobject_put(mod);
 
-	/* delay uevent until full sysfs population */
 out:
 	return err;
 }
@@ -1813,7 +1812,6 @@ static int mod_sysfs_setup(struct module *mod,
 	add_sect_attrs(mod, info);
 	add_notes_attrs(mod, info);
 
-	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
 	return 0;
 
 out_unreg_param:
@@ -3301,6 +3299,9 @@ static noinline int do_init_module(struct module *mod)
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


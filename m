Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4972ED1C6
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbhAGOR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbhAGOR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE3023372;
        Thu,  7 Jan 2021 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028968;
        bh=CL6Zjm3irMGPOylu9c7/m01S43Y6DOM8i3vetiiOhmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/fc8UhL1EBuSN8As3k/m56i87VPZ7kOSbzUp/5oCuxmzvMp0NNr+1OCWoe51LWqH
         SDSGt+2XxeO/BQ1IcNsIOp6ctKBfMzpf4wZTTnKTYkqf7AMsi1qphge/tX2bBSYPaV
         Ltabm9/pRyvNjLjaX4VfRwbd0H7WjMN5zxFxvXH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/19] module: delay kobject uevent until after module init call
Date:   Thu,  7 Jan 2021 15:16:43 +0100
Message-Id: <20210107140828.429521522@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
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
 kernel/module.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1779,7 +1779,6 @@ static int mod_sysfs_init(struct module
 	if (err)
 		mod_kobject_put(mod);
 
-	/* delay uevent until full sysfs population */
 out:
 	return err;
 }
@@ -1813,7 +1812,6 @@ static int mod_sysfs_setup(struct module
 	add_sect_attrs(mod, info);
 	add_notes_attrs(mod, info);
 
-	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
 	return 0;
 
 out_unreg_param:
@@ -3301,6 +3299,9 @@ static noinline int do_init_module(struc
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
+	/* Delay uevent until module has finished its init routine */
+	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
+
 	/*
 	 * We need to finish all async code before the module init sequence
 	 * is done.  This has potential to deadlock.  For example, a newly



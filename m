Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5FA44F889
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhKNObw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhKNObr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 09:31:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B1460E8B;
        Sun, 14 Nov 2021 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636900133;
        bh=HdEluNQfUK1TyHyFBSEtch1AWVUfzVvQSxSL9KF8KWw=;
        h=Subject:To:Cc:From:Date:From;
        b=0WQm00RehYVo1urC9DKqxKx+p4vn7si6JD0/kkOF7zpNSMB896Tm/KMugbPx/iIwD
         N/lJ1uOEyv0N6DimfhbJXWLbH6EZoHX72dVIbV6jjjdgMtQ+eN8t3Zyz7pOXtF+Nyc
         rxOtDc32SENif9rlbnzh2mrJJnD5nNypGsgcnKHk=
Subject: FAILED: patch "[PATCH] component: do not leave master devres group open after bind" failed to apply to 5.10-stable tree
To:     kai.vehmanen@linux.intel.com, gregkh@linuxfoundation.org,
        imre.deak@intel.com, rmk+kernel@armlinux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 15:28:41 +0100
Message-ID: <163690012186226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c87761db2100677a69be551365105125d872af5b Mon Sep 17 00:00:00 2001
From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Date: Wed, 13 Oct 2021 19:13:45 +0300
Subject: [PATCH] component: do not leave master devres group open after bind

In current code, the devres group for aggregate master is left open
after call to component_master_add_*(). This leads to problems when the
master does further managed allocations on its own. When any
participating driver calls component_del(), this leads to immediate
release of resources.

This came up when investigating a page fault occurring with i915 DRM
driver unbind with 5.15-rc1 kernel. The following sequence occurs:

 i915_pci_remove()
   -> intel_display_driver_unregister()
     -> i915_audio_component_cleanup()
       -> component_del()
         -> component.c:take_down_master()
           -> hdac_component_master_unbind() [via master->ops->unbind()]
           -> devres_release_group(master->parent, NULL)

With older kernels this has not caused issues, but with audio driver
moving to use managed interfaces for more of its allocations, this no
longer works. Devres log shows following to occur:

component_master_add_with_match()
[  126.886032] snd_hda_intel 0000:00:1f.3: DEVRES ADD 00000000323ccdc5 devm_component_match_release (24 bytes)
[  126.886045] snd_hda_intel 0000:00:1f.3: DEVRES ADD 00000000865cdb29 grp< (0 bytes)
[  126.886049] snd_hda_intel 0000:00:1f.3: DEVRES ADD 000000001b480725 grp< (0 bytes)

audio driver completes its PCI probe()
[  126.892238] snd_hda_intel 0000:00:1f.3: DEVRES ADD 000000001b480725 pcim_iomap_release (48 bytes)

component_del() called() at DRM/i915 unbind()
[  137.579422] i915 0000:00:02.0: DEVRES REL 00000000ef44c293 grp< (0 bytes)
[  137.579445] snd_hda_intel 0000:00:1f.3: DEVRES REL 00000000865cdb29 grp< (0 bytes)
[  137.579458] snd_hda_intel 0000:00:1f.3: DEVRES REL 000000001b480725 pcim_iomap_release (48 bytes)

So the "devres_release_group(master->parent, NULL)" ends up freeing the
pcim_iomap allocation. Upon next runtime resume, the audio driver will
cause a page fault as the iomap alloc was released without the driver
knowing about it.

Fix this issue by using the "struct master" pointer as identifier for
the devres group, and by closing the devres group after
the master->ops->bind() call is done. This allows devres allocations
done by the driver acting as master to be isolated from the binding state
of the aggregate driver. This modifies the logic originally introduced in
commit 9e1ccb4a7700 ("drivers/base: fix devres handling for master device")

Fixes: 9e1ccb4a7700 ("drivers/base: fix devres handling for master device")
Cc: stable@vger.kernel.org
Acked-by: Imre Deak <imre.deak@intel.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
BugLink: https://gitlab.freedesktop.org/drm/intel/-/issues/4136
Link: https://lore.kernel.org/r/20211013161345.3755341-1-kai.vehmanen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 6dc309913ccd..2d25a6416587 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -245,7 +245,7 @@ static int try_to_bring_up_master(struct master *master,
 		return 0;
 	}
 
-	if (!devres_open_group(master->parent, NULL, GFP_KERNEL))
+	if (!devres_open_group(master->parent, master, GFP_KERNEL))
 		return -ENOMEM;
 
 	/* Found all components */
@@ -257,6 +257,7 @@ static int try_to_bring_up_master(struct master *master,
 		return ret;
 	}
 
+	devres_close_group(master->parent, NULL);
 	master->bound = true;
 	return 1;
 }
@@ -281,7 +282,7 @@ static void take_down_master(struct master *master)
 {
 	if (master->bound) {
 		master->ops->unbind(master->parent);
-		devres_release_group(master->parent, NULL);
+		devres_release_group(master->parent, master);
 		master->bound = false;
 	}
 }


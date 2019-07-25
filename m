Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB117484E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388179AbfGYHkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387989AbfGYHkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 03:40:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D652F2070B;
        Thu, 25 Jul 2019 07:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564040431;
        bh=KPHjLfP7/z4OgNe7fJPFovRZvN/mecLCNTpAUkexCx0=;
        h=Subject:To:From:Date:From;
        b=tYVDEKFV7Dz1fWjB0Wh39PIqROssB1VFIrvMVn0BZ9Zvaxbdv1r4G4r626WtEnRim
         aBnIw4pei7pLS/kqRk5mqRWSbXU8JeNSi/hbQDm/qNdE4ed2TlD3bhv5fWNZXQdhlz
         fU+FwOEqf0bkH1V+mq65fH6yaPAyRfJirlKwxDzg=
Subject: patch "staging: wilc1000: flush the workqueue before deinit the host" added to staging-linus
To:     adham.abozaeid@microchip.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 09:40:29 +0200
Message-ID: <1564040429208236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wilc1000: flush the workqueue before deinit the host

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fb2b055b7e6e44efda737c7c92f46c0868bb04e5 Mon Sep 17 00:00:00 2001
From: Adham Abozaeid <adham.abozaeid@microchip.com>
Date: Mon, 22 Jul 2019 21:38:44 +0000
Subject: staging: wilc1000: flush the workqueue before deinit the host

Before deinitializing the host interface, the workqueue should be flushed
to handle any pending deferred work

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190722213837.21952-1-adham.abozaeid@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d72fdd333050..736eedef23b6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1969,6 +1969,7 @@ void wilc_deinit_host_int(struct net_device *net)
 
 	priv->p2p_listen_state = false;
 
+	flush_workqueue(vif->wilc->hif_workqueue);
 	mutex_destroy(&priv->scan_req_lock);
 	ret = wilc_deinit(vif);
 
-- 
2.22.0



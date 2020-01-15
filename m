Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE29F13C104
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgAOMar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgAOMar (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 07:30:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18924214AF;
        Wed, 15 Jan 2020 12:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579091446;
        bh=+JRyNIcQbOZMtsooHbvknQXbfYEdHeW51Yx6AcHHmoQ=;
        h=Subject:To:From:Date:From;
        b=fQBdhnJfVWufGivqD8A4hqzQ7FypaTZE0ESKdCgO6ZHemFvBtpqL8ErM4GetVhwFs
         5eLz41uetLfMWFBAzZmwMir8pcavpM6Pb6V80DNBaPvF/uh6dTEARw12pqE5m5Mh3r
         kkOM1gEap6n/8aN3lpGwkxuyoW588Jcs2dGcpPnw=
Subject: patch "staging: comedi: ni_routes: fix null dereference in" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org, olsonse@umich.edu,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 13:30:44 +0100
Message-ID: <157909144417823@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: ni_routes: fix null dereference in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 01e20b664f808a4f3048ca3f930911fd257209bd Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 14 Jan 2020 18:25:31 +0000
Subject: staging: comedi: ni_routes: fix null dereference in
 ni_find_route_source()

In `ni_find_route_source()`, `tables->route_values` gets dereferenced.
However it is possible that `tables->route_values` is `NULL`, leading to
a null pointer dereference.  `tables->route_values` will be `NULL` if
the call to `ni_assign_device_routes()` during board initialization
returned an error due to missing device family routing information or
missing board-specific routing information.  For example, there is
currently no board-specific routing information provided for the
PCIe-6251 board and several other boards, so those are affected by this
bug.

The bug is triggered when `ni_find_route_source()` is called via
`ni_check_trigger_arg()` or `ni_check_trigger_arg_roffs()` when checking
the arguments for setting up asynchronous commands.  Fix it by returning
`-EINVAL` if `tables->route_values` is `NULL`.

Even with this fix, setting up asynchronous commands to use external
trigger sources for boards with missing routing information will still
fail gracefully.  Since `ni_find_route_source()` only depends on the
device family routing information, it would be better if that was made
available even if the board-specific routing information is missing.
That will be addressed by another patch.

Fixes: 4bb90c87abbe ("staging: comedi: add interface to ni routing table information")
Cc: <stable@vger.kernel.org> # 4.20+
Cc: Spencer E. Olson <olsonse@umich.edu>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200114182532.132058-2-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_routes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/ni_routes.c b/drivers/staging/comedi/drivers/ni_routes.c
index 673d732dcb8f..9627bd1d2a78 100644
--- a/drivers/staging/comedi/drivers/ni_routes.c
+++ b/drivers/staging/comedi/drivers/ni_routes.c
@@ -487,6 +487,9 @@ int ni_find_route_source(const u8 src_sel_reg_value, int dest,
 {
 	int src;
 
+	if (!tables->route_values)
+		return -EINVAL;
+
 	dest = B(dest); /* subtract NI names offset */
 	/* ensure we are not going to under/over run the route value table */
 	if (dest < 0 || dest >= NI_NUM_NAMES)
-- 
2.24.1



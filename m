Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6AB14551D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgAVNTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgAVNTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:06 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D6C20678;
        Wed, 22 Jan 2020 13:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699145;
        bh=sWI9vy28d3cPsQWZHNUBNc/BCrkQ3DbNbsXtE/jxrfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtgG57ZlhiKZ7oIzAoWnA4Lkc//W+lIMORCQBKgP9CQY0qNKI63n/SVTlvl/7k2pz
         QZngmZQLsXAsXR+IWF0rD4mC6lFAwvUqMnspWhbf18RfjjUtqXGsLiNpJiz//C4wWe
         bIUVh97/V8J8eraQn+y7gCyQhaHz9yG4fyxuugSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Spencer E. Olson" <olsonse@umich.edu>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 054/222] staging: comedi: ni_routes: allow partial routing information
Date:   Wed, 22 Jan 2020 10:27:20 +0100
Message-Id: <20200122092837.502758644@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit 9fea3a40f6b07de977a2783270c8c3bc82544d45 upstream.

This patch fixes a regression on setting up asynchronous commands to use
external trigger sources when board-specific routing information is
missing.

`ni_find_device_routes()` (called via `ni_assign_device_routes()`) finds
the table of register values for the device family and the set of valid
routes for the specific board.  If both are found,
`tables->route_values` is set to point to the table of register values
for the device family and `tables->valid_routes` is set to point to the
list of valid routes for the specific board.  If either is not found,
both `tables->route_values` and `tables->valid_routes` are left set at
their initial null values (initialized by `ni_assign_device_routes()`)
and the function returns `-ENODATA`.

Returning an error results in some routing functionality being disabled.
Unfortunately, leaving `table->route_values` set to `NULL` also breaks
the setting up of asynchronous commands that are configured to use
external trigger sources.  Calls to `ni_check_trigger_arg()` or
`ni_check_trigger_arg_roffs()` while checking the asynchronous command
set-up would result in a null pointer dereference if
`table->route_values` is `NULL`.  The null pointer dereference is fixed
in another patch, but it now results in failure to set up the
asynchronous command.  That is a regression from the behavior prior to
commit 347e244884c3 ("staging: comedi: tio: implement global tio/ctr
routing") and commit 56d0b826d39f ("staging: comedi: ni_mio_common:
implement new routing for TRIG_EXT").

Change `ni_find_device_routes()` to set `tables->route_values` and/or
`tables->valid_routes` to valid information even if the other one can
only be set to `NULL` due to missing information.  The function will
still return an error in that case.  This should result in
`tables->valid_routes` being valid for all currently supported device
families even if the board-specific routing information is missing.
That should be enough to fix the regression on setting up asynchronous
commands to use external triggers for boards with missing routing
information.

Fixes: 347e244884c3 ("staging: comedi: tio: implement global tio/ctr routing")
Fixes: 56d0b826d39f ("staging: comedi: ni_mio_common: implement new routing for TRIG_EXT").
Cc: <stable@vger.kernel.org> # 4.20+
Cc: Spencer E. Olson <olsonse@umich.edu>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200114182532.132058-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_routes.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/staging/comedi/drivers/ni_routes.c
+++ b/drivers/staging/comedi/drivers/ni_routes.c
@@ -74,9 +74,6 @@ static int ni_find_device_routes(const c
 		}
 	}
 
-	if (!rv)
-		return -ENODATA;
-
 	/* Second, find the set of routes valid for this device. */
 	for (i = 0; ni_device_routes_list[i]; ++i) {
 		if (memcmp(ni_device_routes_list[i]->device, board_name,
@@ -86,12 +83,12 @@ static int ni_find_device_routes(const c
 		}
 	}
 
-	if (!dr)
-		return -ENODATA;
-
 	tables->route_values = rv;
 	tables->valid_routes = dr;
 
+	if (!rv || !dr)
+		return -ENODATA;
+
 	return 0;
 }
 



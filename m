Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75E113B213
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgANS0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:26:00 -0500
Received: from smtp104.ord1c.emailsrvr.com ([108.166.43.104]:51913 "EHLO
        smtp104.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728909AbgANSZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1579026358;
        bh=x97t4sVCLec0AUkyNkrph7ut/gSYCSeAr+g7v3AiIVs=;
        h=From:To:Subject:Date:From;
        b=EH4oqtkSvIzVRUoYf9m/iInrr7YCBCTkZgHOPMDyXTpDEBvjCpoIjT5RlDVylKj+M
         Bdl5aCHZeA7AsP7NNbm3bZR3yBXgzvTVJBBcjzbcmT5xKoCok1r2rK/xBiXDTXSEWC
         KdPu3BBfoT2yW+FZ0IeWW3dZAZv8hjSlBEDmZLl4=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp6.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 06F8FA0108;
        Tue, 14 Jan 2020 13:25:56 -0500 (EST)
X-Sender-Id: abbotti@mev.co.uk
Received: from ian-deb.inside.mev.co.uk (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Tue, 14 Jan 2020 13:25:58 -0500
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Spencer E . Olson" <olsonse@umich.edu>
Subject: [PATCH 2/2] staging: comedi: ni_routes: allow partial routing information
Date:   Tue, 14 Jan 2020 18:25:32 +0000
Message-Id: <20200114182532.132058-3-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114182532.132058-1-abbotti@mev.co.uk>
References: <20200114182532.132058-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/staging/comedi/drivers/ni_routes.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_routes.c b/drivers/staging/comedi/drivers/ni_routes.c
index 9627bd1d2a78..8f398b30f5bf 100644
--- a/drivers/staging/comedi/drivers/ni_routes.c
+++ b/drivers/staging/comedi/drivers/ni_routes.c
@@ -72,9 +72,6 @@ static int ni_find_device_routes(const char *device_family,
 		}
 	}
 
-	if (!rv)
-		return -ENODATA;
-
 	/* Second, find the set of routes valid for this device. */
 	for (i = 0; ni_device_routes_list[i]; ++i) {
 		if (memcmp(ni_device_routes_list[i]->device, board_name,
@@ -84,12 +81,12 @@ static int ni_find_device_routes(const char *device_family,
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
 
-- 
2.24.1


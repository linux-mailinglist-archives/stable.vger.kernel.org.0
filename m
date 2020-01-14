Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D433013B215
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgANS0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:26:05 -0500
Received: from smtp109.ord1c.emailsrvr.com ([108.166.43.109]:56228 "EHLO
        smtp109.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728656AbgANSZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1579026356;
        bh=U8O4XraV/OP74ldPzZCy+o/m+44W+fvsVTt44J60PdU=;
        h=From:To:Subject:Date:From;
        b=V9FtwKzOUXzx8fUEGFs6vqdaklj4zOrcUfXcbpqqmfJsxjMnWTIxwhpmDX3tLyvCx
         V01hpsrwaNv5KSaOIWrjHReKNEmRHYZmdgFpV2ozKPyRn9Pft7gic4wOvyc7n2GlDn
         MoOye02qz74Hl7gYz8lYIJcC+yg6CJthH6+tpYK8=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp6.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id C8D53A0281;
        Tue, 14 Jan 2020 13:25:54 -0500 (EST)
X-Sender-Id: abbotti@mev.co.uk
Received: from ian-deb.inside.mev.co.uk (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Tue, 14 Jan 2020 13:25:56 -0500
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Spencer E . Olson" <olsonse@umich.edu>
Subject: [PATCH 1/2] staging: comedi: ni_routes: fix null dereference in ni_find_route_source()
Date:   Tue, 14 Jan 2020 18:25:31 +0000
Message-Id: <20200114182532.132058-2-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114182532.132058-1-abbotti@mev.co.uk>
References: <20200114182532.132058-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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


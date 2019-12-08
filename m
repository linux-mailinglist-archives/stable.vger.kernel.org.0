Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5199D1161FD
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfLHN4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60316 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbfLHNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0007eo-JG; Sun, 08 Dec 2019 13:54:39 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0002Nn-E7; Sun, 08 Dec 2019 13:54:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sebastian Ott" <sebott@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>
Date:   Sun, 08 Dec 2019 13:53:26 +0000
Message-ID: <lsq.1575813165.725255212@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 42/72] s390/cio: exclude subchannels with no parent
 from pseudo check
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit ab5758848039de9a4b249d46e4ab591197eebaf2 upstream.

ccw console is created early in start_kernel and used before css is
initialized or ccw console subchannel is registered. Until then console
subchannel does not have a parent. For that reason assume subchannels
with no parent are not pseudo subchannels. This fixes the following
kasan finding:

BUG: KASAN: global-out-of-bounds in sch_is_pseudo_sch+0x8e/0x98
Read of size 8 at addr 00000000000005e8 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-rc8-07370-g6ac43dd12538 #2
Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
Call Trace:
([<000000000012cd76>] show_stack+0x14e/0x1e0)
 [<0000000001f7fb44>] dump_stack+0x1a4/0x1f8
 [<00000000007d7afc>] print_address_description+0x64/0x3c8
 [<00000000007d75f6>] __kasan_report+0x14e/0x180
 [<00000000018a2986>] sch_is_pseudo_sch+0x8e/0x98
 [<000000000189b950>] cio_enable_subchannel+0x1d0/0x510
 [<00000000018cac7c>] ccw_device_recognition+0x12c/0x188
 [<0000000002ceb1a8>] ccw_device_enable_console+0x138/0x340
 [<0000000002cf1cbe>] con3215_init+0x25e/0x300
 [<0000000002c8770a>] console_init+0x68a/0x9b8
 [<0000000002c6a3d6>] start_kernel+0x4fe/0x728
 [<0000000000100070>] startup_continue+0x70/0xd0

Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/cio/css.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1125,6 +1125,8 @@ device_initcall(cio_settle_init);
 
 int sch_is_pseudo_sch(struct subchannel *sch)
 {
+	if (!sch->dev.parent)
+		return 0;
 	return sch == to_css(sch->dev.parent)->pseudo_subchannel;
 }
 


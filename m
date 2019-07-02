Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377C05CADF
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfGBIJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbfGBIJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7BC72064A;
        Tue,  2 Jul 2019 08:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054943;
        bh=NlSMqlmoJR4RbnvehDn94i5J/shbFBdfqwERFE6rVzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEtv4hbNDKKQmE3pcME5ueHlG3jssplSh+jA0hB2m67NJXu52GidWP4jhIOONpsB8
         FWo7Jd9PwEhlfMUgDQAJg3exKN+PLgSO1jw9g047E5RLsHTNRRv3LsfI+c19UYqMgT
         yz4jTkqJ+fcoukI9xjJx2bS/TuIzEOx6t2SolaKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/43] qmi_wwan: Fix out-of-bounds read
Date:   Tue,  2 Jul 2019 10:01:54 +0200
Message-Id: <20190702080124.527160040@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 904d88d743b0c94092c5117955eab695df8109e8 upstream.

The syzbot reported

 Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description+0x67/0x231 mm/kasan/report.c:188
  __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
  kasan_report+0xe/0x20 mm/kasan/common.c:614
  qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x660 drivers/base/dd.c:509
  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454

Caused by too many confusing indirections and casts.
id->driver_info is a pointer stored in a long.  We want the
pointer here, not the address of it.

Thanks-to: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Fixes: e4bf63482c30 ("qmi_wwan: Add quirk for Quectel dynamic config")
Signed-off-by: Bjørn Mork <bjorn@mork.no>

[Upstream commit did not apply because I shuffled two lines in the
backport. The fixes tag for 4.14 is 3a6a5107ceb3.]

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index c2d6c501dd85..063daa3435e4 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1395,14 +1395,14 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
-	info = (void *)&id->driver_info;
-
 	/* Several Quectel modems supports dynamic interface configuration, so
 	 * we need to match on class/subclass/protocol. These values are
 	 * identical for the diagnostic- and QMI-interface, but bNumEndpoints is
 	 * different. Ignore the current interface if the number of endpoints
 	 * equals the number for the diag interface (two).
 	 */
+	info = (void *)id->driver_info;
+
 	if (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
 		if (desc->bNumEndpoints == 2)
 			return -ENODEV;
-- 
2.20.1




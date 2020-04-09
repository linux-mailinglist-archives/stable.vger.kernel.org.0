Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F57B1A3070
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 09:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgDIHuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 03:50:02 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:45896 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgDIHuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 03:50:01 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 0397nwAE027124; Thu, 9 Apr 2020 16:49:58 +0900
X-Iguazu-Qid: 34ts1iCWJnrtsKSc6T
X-Iguazu-QSIG: v=2; s=0; t=1586418598; q=34ts1iCWJnrtsKSc6T; m=oW5dtEwYl6I7nsQr+P9M+Qf+cJKQOEA8fgdUP3h/FQM=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1513) id 0397nwWK039687;
        Thu, 9 Apr 2020 16:49:58 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0397nvth016017;
        Thu, 9 Apr 2020 16:49:57 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0397nvGp008891;
        Thu, 9 Apr 2020 16:49:57 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH for 4.4.y] xen-netfront: Fix mismatched rtnl_unlock
Date:   Thu,  9 Apr 2020 16:49:52 +0900
X-TSB-HOP: ON
Message-Id: <20200409074952.1396751-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit cb257783c2927b73614b20f915a91ff78aa6f3e8 upstream.

Fixes: f599c64fdf7d ("xen-netfront: Fix race between device setup and open")
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/xen-netfront.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 89eec6fead753..744b111cff6a3 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1835,7 +1835,7 @@ static int talk_to_netback(struct xenbus_device *dev,
 	err = xen_net_read_mac(dev, info->netdev->dev_addr);
 	if (err) {
 		xenbus_dev_fatal(dev, err, "parsing %s/mac", dev->nodename);
-		goto out;
+		goto out_unlocked;
 	}
 
 	rtnl_lock();
@@ -1950,6 +1950,7 @@ abort_transaction_no_dev_fatal:
 	xennet_destroy_queues(info);
  out:
 	rtnl_unlock();
+out_unlocked:
 	device_unregister(&dev->dev);
 	return err;
 }
-- 
2.26.0


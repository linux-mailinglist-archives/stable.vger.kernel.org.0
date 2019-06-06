Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA9136DDB
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 09:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfFFHyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 03:54:54 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3158 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFHyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 03:54:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1559807694; x=1591343694;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F4RsOkcrGOWpBQZgmCctN2wD3H9blPOhMwrNxs6NmGc=;
  b=m0Tgxc4u80GTqCpz4boKpOv1s0/IW8q/QFomnRATu7lQF+VjFJbCwsMR
   1BiSSLqTFnJBfEdzU1Ge+qnPmdTG4O4Qc7AXVEJihQcHHc1lCUOxhWkaB
   NEyIFQCrPsu8wyPXds+k40ogaL/MKmF3WJjfJZDx59Z4UXYkoW7k2JTje
   RuElTu8rX51cHnsXYOoFaZk8H0CS/lWxpWwmVcAdfYZQJORpJqI+ZgmA/
   jU3xzLLkR5hGKEMNVd12EKzzTlr4LddReSwg+xAcCzpVaopC1v11cEVLs
   aidHCL5MBxKqXB+lrXcOKA8m5mTG7S7WZc+h/2QzoG9r1SThUdYkDMVEJ
   A==;
X-IronPort-AV: E=Sophos;i="5.63,558,1557158400"; 
   d="scan'208";a="114878920"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jun 2019 15:54:53 +0800
IronPort-SDR: 5auJKlu7TkLwgA9p7z3j2yc9UjAzM1ghG2M0qcnNpEETTj/MHcUyOZ0DuKlO75+tBVky2DMzSt
 4ukXM1NzuDnshrsOdv/JMyqRa+FRYnNgl1G7Qfze+1hQWeupIlb+CvK48qu6KIFiziHCh35zKF
 s8naIqG9quvxQZ7C6qFCdQoFvQf0tc8vfWG9KGKV7OmzT0IdUErrUz9+QkNzdOYKskTRQSXO/k
 GA6Slq/2nt+gaGzDYGZhpAi9psZvj9XlPXid2t6zPgp+nCoatRqUtZvsQhwzTfqkwBiiSvGbv2
 cUxLQJKjU3vW254cKbHHW4g7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP; 06 Jun 2019 00:32:12 -0700
IronPort-SDR: z5dYjSjfY4jzPNAhGn5mkBmqzlX25eagVPZCyEb+MFC0R6zvlgOab16q8n+lBanwRFtEFgIczP
 j5sskO2kFqkJ+4tF1GD3X2YVgldPaMb7fBWe1yYj/MKyGjAr0B4mMU3gO0zIOLhvNG4JQfnqPD
 aAHFmlzF43XkwsJf+yRL/FunVPJtCQRtxgKNI5JhTONn/rDtip8hJoE3Jh5VOIbveu0DiR6Pm8
 8QMvCixRlJnDkD4EFwXGHgUSLH658n8Ny6yrhs5amMo+DBG2D/nWHCapILm6Zd9pr9nSXo5HYT
 yJ8=
Received: from naota.dhcp.fujisawa.hgst.com (HELO naota.fujisawa.hgst.com) ([10.149.53.115])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jun 2019 00:54:53 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: start readahead also in seed devices
Date:   Thu,  6 Jun 2019 16:54:44 +0900
Message-Id: <20190606075444.15481-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, btrfs does not consult seed devices to start readahead. As a
result, if readahead zone is added to the seed devices, btrfs_reada_wait()
indefinitely wait for the reada_ctl to finish.

You can reproduce the hung by modifying btrfs/163 to have larger initial
file size (e.g. xfs_io pwrite 4M instead of current 256K).

Fixes: 7414a03fbf9e ("btrfs: initial readahead code and prototypes")
Cc: stable@vger.kernel.org # 3.2+: ce7791ffee1e: Btrfs: fix race between readahead and device replace/removal
Cc: stable@vger.kernel.org # 3.2+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/reada.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 10d9589001a9..bb5bd49573b4 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -747,6 +747,7 @@ static void __reada_start_machine(struct btrfs_fs_info *fs_info)
 	u64 total = 0;
 	int i;
 
+again:
 	do {
 		enqueued = 0;
 		mutex_lock(&fs_devices->device_list_mutex);
@@ -758,6 +759,10 @@ static void __reada_start_machine(struct btrfs_fs_info *fs_info)
 		mutex_unlock(&fs_devices->device_list_mutex);
 		total += enqueued;
 	} while (enqueued && total < 10000);
+	if (fs_devices->seed) {
+		fs_devices = fs_devices->seed;
+		goto again;
+	}
 
 	if (enqueued == 0)
 		return;
-- 
2.21.0


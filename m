Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488CBC919C
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfJBTKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:10:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35902 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729321AbfJBTIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyx-000365-MX; Wed, 02 Oct 2019 20:08:15 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyp-0003eu-9A; Wed, 02 Oct 2019 20:08:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Naohiro Aota" <naohiro.aota@wdc.com>,
        "David Sterba" <dsterba@suse.com>,
        "Filipe Manana" <fdmanana@suse.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.469797181@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 63/87] btrfs: start readahead also in seed devices
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit c4e0540d0ad49c8ceab06cceed1de27c4fe29f6e upstream.

Currently, btrfs does not consult seed devices to start readahead. As a
result, if readahead zone is added to the seed devices, btrfs_reada_wait()
indefinitely wait for the reada_ctl to finish.

You can reproduce the hung by modifying btrfs/163 to have larger initial
file size (e.g. xfs_io pwrite 4M instead of current 256K).

Fixes: 7414a03fbf9e ("btrfs: initial readahead code and prototypes")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -764,6 +764,7 @@ static void __reada_start_machine(struct
 	u64 total = 0;
 	int i;
 
+again:
 	do {
 		enqueued = 0;
 		mutex_lock(&fs_devices->device_list_mutex);
@@ -776,6 +777,10 @@ static void __reada_start_machine(struct
 		mutex_unlock(&fs_devices->device_list_mutex);
 		total += enqueued;
 	} while (enqueued && total < 10000);
+	if (fs_devices->seed) {
+		fs_devices = fs_devices->seed;
+		goto again;
+	}
 
 	if (enqueued == 0)
 		return;


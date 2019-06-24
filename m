Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A1B5085E
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbfFXKQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730801AbfFXKQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:49 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA8C2146F;
        Mon, 24 Jun 2019 10:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371408;
        bh=CnQAIDsK/qngiQI4aLOMQNGqTdbXr98z9kcIyjCyOKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvHFW7xNZEgj4+IodIexrw4Mrpg7+wuq14FsPksI263psoaW5eEOVgd3S9A6mPU17
         iIlSi94jEIpDHTrjK9RBBT6Kg8731EC0A62rfF065XCcjY4wpnkx4KUGeecF71riOy
         GhvRAgVWrV8YpXRlS1uSTMz4txJPntx4JKQDrLWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 092/121] btrfs: start readahead also in seed devices
Date:   Mon, 24 Jun 2019 17:57:04 +0800
Message-Id: <20190624092325.492365383@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit c4e0540d0ad49c8ceab06cceed1de27c4fe29f6e upstream.

Currently, btrfs does not consult seed devices to start readahead. As a
result, if readahead zone is added to the seed devices, btrfs_reada_wait()
indefinitely wait for the reada_ctl to finish.

You can reproduce the hung by modifying btrfs/163 to have larger initial
file size (e.g. xfs_io pwrite 4M instead of current 256K).

Fixes: 7414a03fbf9e ("btrfs: initial readahead code and prototypes")
Cc: stable@vger.kernel.org # 3.2+: ce7791ffee1e: Btrfs: fix race between readahead and device replace/removal
Cc: stable@vger.kernel.org # 3.2+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/reada.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -747,6 +747,7 @@ static void __reada_start_machine(struct
 	u64 total = 0;
 	int i;
 
+again:
 	do {
 		enqueued = 0;
 		mutex_lock(&fs_devices->device_list_mutex);
@@ -758,6 +759,10 @@ static void __reada_start_machine(struct
 		mutex_unlock(&fs_devices->device_list_mutex);
 		total += enqueued;
 	} while (enqueued && total < 10000);
+	if (fs_devices->seed) {
+		fs_devices = fs_devices->seed;
+		goto again;
+	}
 
 	if (enqueued == 0)
 		return;



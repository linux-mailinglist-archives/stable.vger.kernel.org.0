Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669AB38F011
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbhEXQBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235676AbhEXQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78ECF61461;
        Mon, 24 May 2021 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871148;
        bh=AcoVqIUKAS83PBtxU0e3MSBpKP24FUWomHUDJy5W7Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7AUsz+BDiuRZxS33ePZT39rW1YBB/Blh456vcvZT8JNlnUL6Xri7WC+lqZOG94yW
         BuNkbYn5AYRqFw+0rOTnrqQXL677BkOpIjQnuZE8KTczhOMEcRiaagAHoAUMKVRZ0S
         sgv0pQtecn7IyailxdKfR2N7vT6Q9IWQ/ZzTrCm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.12 094/127] dm snapshot: fix crash with transient storage and zero chunk size
Date:   Mon, 24 May 2021 17:26:51 +0200
Message-Id: <20210524152338.035594414@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit c699a0db2d62e3bbb7f0bf35c87edbc8d23e3062 upstream.

The following commands will crash the kernel:

modprobe brd rd_size=1048576
dmsetup create o --table "0 `blockdev --getsize /dev/ram0` snapshot-origin /dev/ram0"
dmsetup create s --table "0 `blockdev --getsize /dev/ram0` snapshot /dev/ram0 /dev/ram1 N 0"

The reason is that when we test for zero chunk size, we jump to the label
bad_read_metadata without setting the "r" variable. The function
snapshot_ctr destroys all the structures and then exits with "r == 0". The
kernel then crashes because it falsely believes that snapshot_ctr
succeeded.

In order to fix the bug, we set the variable "r" to -EINVAL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1407,6 +1407,7 @@ static int snapshot_ctr(struct dm_target
 
 	if (!s->store->chunk_size) {
 		ti->error = "Chunk size not set";
+		r = -EINVAL;
 		goto bad_read_metadata;
 	}
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD0438EE7B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhEXPvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233963AbhEXPsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:48:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F2AF613CC;
        Mon, 24 May 2021 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870651;
        bh=AcoVqIUKAS83PBtxU0e3MSBpKP24FUWomHUDJy5W7Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IO0v+iWSDkUTtb34eHGNM1M88E6BAY47Hm19zZeqsmzmmKjIYpvFrOwxGQy/uUDbU
         6ZheApIAbN3YoEC+4B6Iz8vXRB6+q6B8/TdviYum1WNIAElkMJfww8rTPjV+GWeLRC
         SgHSzJihkoGMWVfRhryJGw1zlsofQGhs+Z3Q+RPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 43/71] dm snapshot: fix crash with transient storage and zero chunk size
Date:   Mon, 24 May 2021 17:25:49 +0200
Message-Id: <20210524152327.865846130@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
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
 



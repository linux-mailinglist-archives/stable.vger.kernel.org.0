Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA97F2893C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403889AbfEWTcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403886AbfEWTb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:31:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79D0D2054F;
        Thu, 23 May 2019 19:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639919;
        bh=q0NoChondQNBMPI/IILqxPHisepa81MuFB32CinsJs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8zDyE/bLYpEiBg2FLAsl80sR1Kx/SsQTK8AsRNhWYmQV/8MQFLFLUxnVN+mZn1nr
         u9FW8LiPY/4hsCP+T5Nfe6DfDsZd2OFWFvMwawCNrAgB6xYrAv1KQr38coTlgfoZII
         TCTgHs/LGP+NpYgjpqIecO0J1IArCwkckqdUg86M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mulu He <muluhe@codeaurora.org>
Subject: [PATCH 4.19 022/114] stm class: Fix channel bitmap on 32-bit systems
Date:   Thu, 23 May 2019 21:05:21 +0200
Message-Id: <20190523181733.894465792@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 51e0f227812ed81a368de54157ebe14396b4be03 upstream.

Commit 7bd1d4093c2f ("stm class: Introduce an abstraction for System Trace
Module devices") naively calculates the channel bitmap size in 64-bit
chunks regardless of the size of underlying unsigned long, making the
bitmap half as big on a 32-bit system. This leads to an out of bounds
access with the upper half of the bitmap.

Fix this by using BITS_TO_LONGS. While at it, convert to using
struct_size() for the total size calculation of the master struct.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 7bd1d4093c2f ("stm class: Introduce an abstraction for System Trace Module devices")
Reported-by: Mulu He <muluhe@codeaurora.org>
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/stm/core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -166,11 +166,10 @@ stm_master(struct stm_device *stm, unsig
 static int stp_master_alloc(struct stm_device *stm, unsigned int idx)
 {
 	struct stp_master *master;
-	size_t size;
 
-	size = ALIGN(stm->data->sw_nchannels, 8) / 8;
-	size += sizeof(struct stp_master);
-	master = kzalloc(size, GFP_ATOMIC);
+	master = kzalloc(struct_size(master, chan_map,
+				     BITS_TO_LONGS(stm->data->sw_nchannels)),
+			 GFP_ATOMIC);
 	if (!master)
 		return -ENOMEM;
 



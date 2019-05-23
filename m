Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564DB279E8
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 11:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfEWJ6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 05:58:18 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59269 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730484AbfEWJ6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 05:58:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8B7BD355E0;
        Thu, 23 May 2019 05:58:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 23 May 2019 05:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xtdFKt
        A16CLWavUcFne6heeYegXkUNCwrhp1wuXM3Js=; b=JPwTr/FTgrrDEJn2pNmI1Z
        O21FDdL1fFwa3kvhyPe/l7U3coDbGhYIL0rwdP3ZCc+tmIsQeuPre2ufz8WzFaPJ
        a2JMTzZrvZothjii4TbO2MlZNduX1NbmklAoEEIR+j3hn+Tjh7eGJWCSC9fpq/h1
        sH5HnDJtrLhfDBnkF0b0dqewL/uca9gYpBHP2vOwDtFYWA43jMPz6eR5azhTzf81
        QaZP7OobZO+g2arzI/nXeGJUlKFj2M6TBwX/VXqUT+ViIDq2U9voK4Lhdd1uOIM3
        532s+jME3ag6NKD9b7JoJkiNwkJCn+cZPc5eLb70kqKFj+53PA6tH7cALgSk90Bw
        ==
X-ME-Sender: <xms:uW7mXIgTCYqdjJmYljWBEma8OhRtRxTCiaytaMz4DgCRm_2oC5-MMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:uW7mXESodAvMEWYILLA01fjl30dv8iG_2gW4_x6K5gmbhBuetqHJZQ>
    <xmx:uW7mXEIpGNBrajcB1oa3CkJJSGfXbs3OkDGPnURm4cXcOmiCTGNBug>
    <xmx:uW7mXDQYvlzXxqfp8eHHvKrSi6B2oS6W-M-MZg16Pd-YEKlqJuTKrQ>
    <xmx:uW7mXE3GlIqM9KPjTEXiQ6NRDWT6X1wt_egrkNE5pF3YJeBB3yiSOQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FBE2380073;
        Thu, 23 May 2019 05:58:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] stm class: Fix channel bitmap on 32-bit systems" failed to apply to 4.9-stable tree
To:     alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        muluhe@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 11:58:06 +0200
Message-ID: <155860548656193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 51e0f227812ed81a368de54157ebe14396b4be03 Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Wed, 17 Apr 2019 10:35:35 +0300
Subject: [PATCH] stm class: Fix channel bitmap on 32-bit systems

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

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index 5b5807cbcf7c..e55b902560de 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -166,11 +166,10 @@ stm_master(struct stm_device *stm, unsigned int idx)
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
 


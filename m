Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A55AEDC3E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 11:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfKDKNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 05:13:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58303 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbfKDKNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 05:13:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8911921BBA;
        Mon,  4 Nov 2019 05:13:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 05:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YJ+ggp
        yTUHeafutUjE1geg/vkc1RODRA0by/G6McDtI=; b=ys8Oj4YnZUE8uL6ESgpmk5
        D5tllRDWSfsAyB7SNTrM4hKEdVHBLV63CSl5Hz1oa29zXLXmOwWVPyg9v7dAK3Pr
        QPNCRlhId2d1WqR8nJRevVfCcdbv89JaqOXgTq1A7rhpZb/d35dLKoQ7O+LNawQT
        8GHv44/qOwD1gdd9fC1zW4sdMjeBs1I+7EtFYfrHAacp2PqUAocxaaa9VoIvo6ry
        2/ycgubbR90bmYPd6koJ84JL/+QR79e7J7BwXPXRxEtZKRCpnoo+gRWN/y22jaun
        xexoiHyN5lmWb5zkATOT1a7ui662/edAhi6RFtRbriAfbPi32lQrLzJJ/PzXIZvQ
        ==
X-ME-Sender: <xms:y_m_XX6AkuHl98ZMrKIgBVLHaHCwL4Cf-XQMobRNHI5jxhOmYy22vQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:y_m_XUZB8RoHGpLizHDjbjKsZq28J4mTQ3oXTGwxTihjB0CFWnvVCg>
    <xmx:y_m_XUjFiaOm-Sec6u5RGdOs69L5Av3QZ-LTKQzuJna_roDQaYKH4g>
    <xmx:y_m_XWO5-AbVsfg4VTisdqqoPK1_nb59O17Jov0P35syKG5gRM4kSw>
    <xmx:y_m_XbHDhuJodJlFGory-AjsGchyGANqNPvDJouv03UypU3ZpwoWIQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 29D65306005B;
        Mon,  4 Nov 2019 05:13:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/etnaviv: fix dumping of iommuv2" failed to apply to 4.19-stable tree
To:     christian.gmeiner@gmail.com, l.stach@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 11:13:19 +0100
Message-ID: <157286239915438@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a2f10d4a3069fee666dab20fab5458757ba1f22d Mon Sep 17 00:00:00 2001
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Fri, 25 Oct 2019 12:39:10 +0200
Subject: [PATCH] drm/etnaviv: fix dumping of iommuv2

etnaviv_iommuv2_dump_size(..) returns the number of PTE * SZ_4K but
etnaviv_iommuv2_dump(..) increments buf pointer even if there is no PTE.
This results in a bad buf pointer which gets used for memcpy(..), when
copying the MMU state in the coredump buffer.

Fixes: afb7b3b1deb4 ("drm/etnaviv: implement IOMMUv2 translation")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c b/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
index 043111a1d60c..f8bf488e9d71 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
@@ -155,9 +155,11 @@ static void etnaviv_iommuv2_dump(struct etnaviv_iommu_context *context, void *bu
 
 	memcpy(buf, v2_context->mtlb_cpu, SZ_4K);
 	buf += SZ_4K;
-	for (i = 0; i < MMUv2_MAX_STLB_ENTRIES; i++, buf += SZ_4K)
-		if (v2_context->mtlb_cpu[i] & MMUv2_PTE_PRESENT)
+	for (i = 0; i < MMUv2_MAX_STLB_ENTRIES; i++)
+		if (v2_context->mtlb_cpu[i] & MMUv2_PTE_PRESENT) {
 			memcpy(buf, v2_context->stlb_cpu[i], SZ_4K);
+			buf += SZ_4K;
+		}
 }
 
 static void etnaviv_iommuv2_restore_nonsec(struct etnaviv_gpu *gpu,


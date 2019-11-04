Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8159EDC37
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 11:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfKDKNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 05:13:23 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47677 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727320AbfKDKNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 05:13:23 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E04B213CA;
        Mon,  4 Nov 2019 05:13:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 05:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=80vh3g
        OvTmHFxL5SZF3X5epTaeMUMx9ttAbIxzvuUkk=; b=uciGH5A1Ye3Z5prpscKkfu
        FiUvqPQsOAES4487xOxocyFCM9YCMZzPQWLrsBlqjUHZwpbXL6PyW7+NDfV9N+Ee
        UWAp25GVL5T+f20UDyfXJs6gq5x4HxJNnQq/MeUk6oGHewtuFNAm93DkrNezgNA1
        WhSayg25/ZqO2+zcJyGTbu5T7AFUqTCoJqLcXGI0Pk0G3fIyGn53Nab9UnDkIsmE
        Zz4e7bOT+ERaNFWA2ZGZ4wXRsMWPdcAJzPz7xI1703Y8veL0fhKE5IKlgHl4mZ8F
        oLxR8JjZ0gwNXjmoB7xtF7w3FyNarZpfidSdnPYxDTn1EJLk/OPOQzymFEhfl/pg
        ==
X-ME-Sender: <xms:wvm_XQsXZPnm7q-xEiBHfAc0iEnreiSM9HBIpPHpgZhZ_Hx4HWhWXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:wvm_XT603fP66F_c-jj_2awekalqLtVRZSHaH7Q_eLyALW9zUaikCw>
    <xmx:wvm_XUmprMBvQnONCZZMm5UjFxyvdjFATiWH2z09pzDvXGL0fg2bCQ>
    <xmx:wvm_XSeel_fXX9K1WStjfNimsXqooBvkSXV97-qVg3y0uWWGE1I6-g>
    <xmx:wvm_XXLQRlxlXc2r09LZgmtJ0MiekMe4gRVj2jlrSf4B7ofxDllQOw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6FE0306005C;
        Mon,  4 Nov 2019 05:13:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/etnaviv: fix dumping of iommuv2" failed to apply to 4.9-stable tree
To:     christian.gmeiner@gmail.com, l.stach@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 11:13:18 +0100
Message-ID: <1572862398183106@kroah.com>
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


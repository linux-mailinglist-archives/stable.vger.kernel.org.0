Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0577C9A09
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfJCIj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:39:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49835 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728842AbfJCIj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:39:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5437E21DFB;
        Thu,  3 Oct 2019 04:39:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=txtlYR
        NJS69p6sZZA1vwcSDnKK3GzjILfJHn9GTrRFA=; b=O+hEUn1nN2usbapHOtgU89
        TUYmm04GurSTPO0Tez3K7FM/sClhLLd8nn0FqkFqxdrcCrScHECaZttHSxphtMyr
        yrMaNKQs4Dr/J0AzOF+jcCxpgAqaoGbWSAnuJZzcDC4MrFPBgjZY/nZs0Q4NKdKG
        0d4S+xJh4gQgIrr3T/mcMIRTQFZIco3tzL34z643UNXSP+IJEs7bP4EN23eHaehy
        0pzXAJmiiPHYI6khVWcpfd3fNNhp3fclzCm1Xtjc/L/2B6cCs6+kE1JBE8kKQdl4
        eKpmfvd+p19U1mc16H7jWamoC4YnJjmzGVJHq8FB2sV42YmWPZsBwKG9VLNgyOFg
        ==
X-ME-Sender: <xms:3bOVXS9y9BICUTvbbhBYstYlQd2RHcm_8dyM4zUppEVe7YNyPvD9mQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:3bOVXWwyRALymxcWoQw7QZnr6Dx2eaWzLORqYAgmlUsPiF2DSpyaDw>
    <xmx:3bOVXdMW5o8nmA0JCBbaYqx1Z4a6pr2lDW5qC3iM4Cd1b957E9E2ww>
    <xmx:3bOVXa8vFFval0Yh4sCJrac7ttXhvKJfraexULnsmgK1R_CcVu97ww>
    <xmx:3rOVXUfUqDab3cFnT86LqhDc_Ezuw_156V9t7ap4IsW1UpavG2o1Dw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 830BA80060;
        Thu,  3 Oct 2019 04:39:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: avoid endless loop of invalid lookback" failed to apply to 4.19-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:39:54 +0200
Message-ID: <1570091994189245@kroah.com>
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

From 598bb8913d015150b7734b55443c0e53e7189fc7 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 19 Aug 2019 18:34:26 +0800
Subject: [PATCH] staging: erofs: avoid endless loop of invalid lookback
 distance 0

As reported by erofs-utils fuzzer, Lookback distance should
be a positive number, so it should be actually looked back
rather than spinning.

Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-7-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index 7408e86823a4..774dacbc5b32 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -350,6 +350,12 @@ static int vle_extent_lookback(struct z_erofs_maprecorder *m,
 
 	switch (m->type) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		if (unlikely(!m->delta[0])) {
+			errln("invalid lookback distance 0 at nid %llu",
+			      vi->nid);
+			DBG_BUGON(1);
+			return -EFSCORRUPTED;
+		}
 		return vle_extent_lookback(m, m->delta[0]);
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 		map->m_flags &= ~EROFS_MAP_ZIPPED;


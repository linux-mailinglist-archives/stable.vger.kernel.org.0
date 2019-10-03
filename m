Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E6C9BEB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 12:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfJCKOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 06:14:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36009 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728356AbfJCKOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 06:14:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7B0FF21B24;
        Thu,  3 Oct 2019 06:14:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 06:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HS74y5
        zXbvP8MNdwcfvt0Xcl7eE9eqy51Gn2kN3Taco=; b=opCacq6xCkfhLQzP+99F3I
        rqr/Gzs4ae2ps94purqjP0+8RZCYED/7W2L62oEVIVDg0tdXKHIPWQE8D0cB6rRW
        jn9BwISOuC0ZWmI8w0n9EhMIGhhXicQIYQytsvKW6cwlkbQYRcYEu92RgVJE3/7m
        Q9cK++jI9RAcZHLfpMa6Uix96qwJQmAGovxB3cVkwo1kw+k0WfPpSwXKL8+kvQtY
        t41k8FKLsH1Hnysblp9d81rDYvppvaoZ5Nm4AmhIMIpnfDN3X9guEyNnAIDHQ8Bb
        JDr+w0ojI19CjCYydAWop+tr41+UmiVkvpElBhUtr5PdmQ1WZFcOsgKWCIZbz78A
        ==
X-ME-Sender: <xms:EsqVXTrnSRo83NGQjbaAcpXQjvk0Y06ehagCwoEy6v-VxZ69m-yn3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:EsqVXbedzeUYo51oRZ2EqkaKp0O6PN0CCXzEZ3pvbOzxM9NDi6Dhtw>
    <xmx:EsqVXarGM1hRHO25YTMsEIKlUts80-okw4iG-yxnjvKAynVJ24jk9A>
    <xmx:EsqVXUGg1vERXG_1j4XaUxx2EPKroBSXa_vy6ErzSsW2QFyEOBDwpg>
    <xmx:EsqVXS2hVTL6Y6aprQaGYX0X5jIH_0ygT6ZbmoMygnrtXDdBWi6_vA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3999D6005A;
        Thu,  3 Oct 2019 06:14:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: avoid endless loop of invalid lookback" failed to apply to 5.3-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 12:14:37 +0200
Message-ID: <1570097677148205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
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


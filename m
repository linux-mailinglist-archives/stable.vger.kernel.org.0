Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB67D245A
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbfJJIoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388851AbfJJIoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:44:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4897221D56;
        Thu, 10 Oct 2019 08:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697042;
        bh=hJa2HHgBksaGk4R8Gj8nbpe3jM7W1po2HhE+oN2/xuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FL+YkWk3CDBFCOn/AFMGB/W8r3G9dtqsB9kICO+x3FwNCx09rkaJ98wEiWJypRxTA
         Lj/Q95mGk6v0Oa+OXmU0DmihVmB+ljAFt3puumVYLBGI27+pt6VhkCynao/P5UGPOx
         gzWNKE21aApi0ANSBjXWnMGp9DXGZd5DTJTyIyvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.3 146/148] staging: erofs: avoid endless loop of invalid lookback distance 0
Date:   Thu, 10 Oct 2019 10:36:47 +0200
Message-Id: <20191010083621.122456973@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 598bb8913d015150b7734b55443c0e53e7189fc7 upstream.

As reported by erofs-utils fuzzer, Lookback distance should
be a positive number, so it should be actually looked back
rather than spinning.

Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-7-gaoxiang25@huawei.com
[ Gao Xiang: Since earlier kernels don't define EFSCORRUPTED,
             let's use EIO instead. ]
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/zmap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -350,6 +350,12 @@ static int vle_extent_lookback(struct z_
 
 	switch (m->type) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		if (!m->delta[0]) {
+			errln("invalid lookback distance 0 at nid %llu",
+			      vi->nid);
+			DBG_BUGON(1);
+			return -EIO;
+		}
 		return vle_extent_lookback(m, m->delta[0]);
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 		map->m_flags &= ~EROFS_MAP_ZIPPED;



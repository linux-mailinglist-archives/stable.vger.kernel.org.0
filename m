Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AF82E3C9F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437495AbgL1OEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437490AbgL1OEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3B7E20791;
        Mon, 28 Dec 2020 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164276;
        bh=fcTGQsbOKU98j4qnnkh2AgeW1TZ0qxxbGM/aLZGpP74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc/EiS+Q9WrXslcJ5nFClTLKF4wP3J/ALeYUHheWCtTnQozZvKfe5Ypq13eXMF3ro
         +IDa7mbkIOhE56jb3+vMgz/R0IbR4ylx7UTZQuielVLNVMGfdcT0xnqk6BrCkR1vfG
         M3Zb1DumyJ7zCgvtvRiU3ck+8qR+kicx/yYXIiSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/717] media: v4l2-fwnode: v4l2_fwnode_endpoint_parse caller must init vep argument
Date:   Mon, 28 Dec 2020 13:42:02 +0100
Message-Id: <20201228125026.888806937@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit b3cc73d2bf14e7c6e0376fa9433e708349e9ddfc ]

Document that the caller of v4l2_fwnode_endpoint_parse() must init the
fields of struct v4l2_fwnode_endpoint (vep argument) fields.

It used to be that the fields were zeroed by v4l2_fwnode_endpoint_parse
when bus type was set to V4L2_MBUS_UNKNOWN but with recent changes (Fixes:
line below) that no longer makes sense.

Fixes: bb4bba9232fc ("media: v4l2-fwnode: Make bus configuration a struct")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/v4l2-fwnode.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index c090742765431..ed0840f3d5dff 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -231,6 +231,9 @@ struct v4l2_fwnode_connector {
  * guessing @vep.bus_type between CSI-2 D-PHY, parallel and BT.656 busses is
  * supported. NEVER RELY ON GUESSING @vep.bus_type IN NEW DRIVERS!
  *
+ * The caller is required to initialise all fields of @vep, either with
+ * explicitly values, or by zeroing them.
+ *
  * The function does not change the V4L2 fwnode endpoint state if it fails.
  *
  * NOTE: This function does not parse properties the size of which is variable
@@ -273,6 +276,9 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
  * guessing @vep.bus_type between CSI-2 D-PHY, parallel and BT.656 busses is
  * supported. NEVER RELY ON GUESSING @vep.bus_type IN NEW DRIVERS!
  *
+ * The caller is required to initialise all fields of @vep, either with
+ * explicitly values, or by zeroing them.
+ *
  * The function does not change the V4L2 fwnode endpoint state if it fails.
  *
  * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FD156A6A
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBINEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:04:53 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41407 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:04:53 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 05F38215B2;
        Sun,  9 Feb 2020 08:04:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:04:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zBgxT7
        f0frQZEbVHNnRKMxvjIuQMkNRdjdjZFyI876g=; b=GriooyjP1sUvrYn14GH5Tv
        D3Q2kqBu8OFsh9Sd6UMc7ML11n6J1MeqxjMRuvL+3XSlLzjfXDfJ+d6A/QmGtXsw
        MzVs7oO/zmYqF6H7qpeyPg8zLVi8au2m8NQKHKqcJtdXL7lzHA1+WkFb15G5mrWA
        wVeoIBY45Enzk3M6Dmeay8TwFKPf8XSLzWqVqY/tpSQdLRWGTLf3N/F7ylOLrhZJ
        b3yxbdkugujlqe32+s4U49XVsrOUdt+ZXnJfbBiQoD0zxGlsesJ+sSUsxKFBqtq4
        QA+Or0UbDBhM8tFmWLSWFgcmberBwrBn4ndDVP9Eog+sbT8TDAtzAh0EJYUlOw8A
        ==
X-ME-Sender: <xms:dANAXm-oYQonNyD6wHVLp3UjoDH22ZXwzvWhy9--c4OSmjCcs1oTXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudeine
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dANAXiN4FAiUc5e7U6JV08Yj2cDVFF8_8knPo2Y0fmGfAMkaGVKfWw>
    <xmx:dANAXiBQm9abjyn3dNwz9rke9Y0uON6wPHQG9UJ4og11AMsl1v4Dpg>
    <xmx:dANAXsOyJb5BujZRbbvOy0wrXeKDQ_gjSPbssmquyGtjpRBqyiBk1g>
    <xmx:dQNAXtgzC-1in3J_h-HM-KRhstHcV-ftimhBaowUVnNlZCUqx9UNvg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB7803280060;
        Sun,  9 Feb 2020 08:04:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: cec: CEC 2.0-only bcast messages were ignored" failed to apply to 4.14-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:46:50 +0100
Message-ID: <15812488102187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 01d4fb115470e9f88a58975fe157a9e8b214dfe5 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date: Wed, 4 Dec 2019 08:52:08 +0100
Subject: [PATCH] media: cec: CEC 2.0-only bcast messages were ignored

Some messages are allowed to be a broadcast message in CEC 2.0
only, and should be ignored by CEC 1.4 devices.

Unfortunately, the check was wrong, causing such messages to be
marked as invalid under CEC 2.0.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 9340435a94a0..e90c30dac68b 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1085,11 +1085,11 @@ void cec_received_msg_ts(struct cec_adapter *adap,
 			valid_la = false;
 		else if (!cec_msg_is_broadcast(msg) && !(dir_fl & DIRECTED))
 			valid_la = false;
-		else if (cec_msg_is_broadcast(msg) && !(dir_fl & BCAST1_4))
+		else if (cec_msg_is_broadcast(msg) && !(dir_fl & BCAST))
 			valid_la = false;
 		else if (cec_msg_is_broadcast(msg) &&
-			 adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0 &&
-			 !(dir_fl & BCAST2_0))
+			 adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0 &&
+			 !(dir_fl & BCAST1_4))
 			valid_la = false;
 	}
 	if (valid_la && min_len) {


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3836A156A69
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBINEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:04:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35295 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:04:45 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E3AC1215B2;
        Sun,  9 Feb 2020 08:04:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=V/8t4s
        cp7uPNnyl9YqbKVSCJTsBNy/B5Mu554S46NJY=; b=0gRyDuOpEOsX7ynvpbf2nX
        iaFVoYYuazc3q62mpTDASv75KX5PKO1/YE7q8Rlu4td6x1EHkgQpnTWzg1dPllxr
        SGQgXVDjoSuob7SQcITXZ8jcbgONMKaiV3A4aPoqLWxh6EyKtpPj7sHHWQwMj041
        ww8ZRS7xBsbOdMbCWJk08FP5wck8giiLTyZx3rfitKtbVzjImXnz5vWOn8fnog5U
        ertnRNR11x3p8UTO9sDO3roMWL8+iIV4xmcS9BDhv/UGnJ8ehslzz4UWuqzi2M7b
        6fiooc4o1X10uVP5YtC/3u+dBnttS01aFHzjeyAmbOc++LtVl/W16tX+rc4KJ87A
        ==
X-ME-Sender: <xms:bANAXrN_kcRxTTByoDgu-9heJbS5WN3mpVrPI2jf_VEpaCGAy1JOyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudehne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bANAXr20uN8k02kLp36u2rEQpEJ_77PHaIHIlJn5SYLNx4ZQwaI1dw>
    <xmx:bANAXldZy9BY1e9rAdd2BltWRzl_hcGSpVQg1-3dzEIf79rm75sJog>
    <xmx:bANAXpy4Ir-ldxr1txtazqEnDChJ6ev6AtIIpMvzDRr3oxeI4uQtLA>
    <xmx:bANAXsCGJ9DRHrRvFG2ZlECJXkxPkWlVGC2_ZxzTfKlDt2DU33pkDg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB32F3280060;
        Sun,  9 Feb 2020 08:04:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: cec: CEC 2.0-only bcast messages were ignored" failed to apply to 4.19-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:46:50 +0100
Message-ID: <158124881097108@kroah.com>
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


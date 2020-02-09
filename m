Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B24156A66
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgBINEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:04:25 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41127 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBINEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:04:24 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CF0D721B2F;
        Sun,  9 Feb 2020 08:04:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:04:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+Fza2f
        n3S2FlECMkJmCrYA8QY6IjLNQc1PUjtyFmJBE=; b=bkqCrrUGsvJXmZqvdWgKBn
        0NMW0itwoPgZt6M83iBookWmkhJQpG4qulIyI3mdvT74d5f4L9jivfY41l+d5FaY
        qoKMnCfWtZt9I8qHCRVRa7ieEys+0XE3HdojlrGkYkheo6e2tKpwnf1geqwsE3bd
        GXlLywlJjZXoCTVMdAErbxGNzXFr7vV9n1/njfLKH1zzPFg5+TEPGxL7tN8WKTpV
        hg//gImM8OLT4Do2Nr30PG2M4cHSfVyfehONcdjoQmxtbjKwoJkK/RXxz4qGD0gZ
        +RdhoveGD+JJYC9uRb3BhMeWvZyg5m2L0yYxF3B4VoKt4+nK0e2ZTSdgxtvzSV4Q
        ==
X-ME-Sender: <xms:VwNAXgMS1a-DMWUjvsZnOW2A6a_wxbQRpAUyIihU50f5ZZLBTwHceQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudefne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VwNAXr5vKXvNArST79VMNJaVtEcnodH7NRHDkc0O1WouuiOpNx0DNQ>
    <xmx:VwNAXvZaNQw6VMInY9UBYjBt-7KicyKfDqc7K-y19yu7axxfPewO6Q>
    <xmx:VwNAXpI08ppG6sD-YMcnTly-JAq4Mqw8jhlzKbWpF9oECnEWoidu7Q>
    <xmx:VwNAXpV60VQorCTPtB2xBaxQOiSucoMJinYnVEcqHE6UqTHUEPcjkg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10A8730606FB;
        Sun,  9 Feb 2020 08:04:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: cec: CEC 2.0-only bcast messages were ignored" failed to apply to 5.4-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:46:48 +0100
Message-ID: <1581248808151224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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


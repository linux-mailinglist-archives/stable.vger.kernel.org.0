Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E322B455
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 14:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfE0MGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 08:06:01 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38641 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbfE0MGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 08:06:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1866054D;
        Mon, 27 May 2019 08:06:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 May 2019 08:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ymo+PA
        QDcu0tPZoiWemFOB428JcrJykLk62aOwOMkPM=; b=qJpya/a/hnaq5aVQa4cMvk
        bEz5WF+prosuG1IM/sQGTkCDCqcuIxv9ray5k76Xxf8Xu8G6lzAIolSvw1RKZMWh
        f/Bw6PX25aqwmgNyWOIQdvSPKoNHoDlFpxMaGoexwEda1ro2k/ZNbary8dQMVDSW
        DIurJlsK/Vv2OyO9wQeRXdGLJWd8w8vAnjYSA1YHigukLdThzUUGKXLwumIfrbvK
        AwoE56AeWfLqH0bguU3JjJRfUg2pyuV6AE0vex4CROmGDk845WkD67AyqUoT3wVE
        iONRg9qr1MUid5ttT5N4OgzVijW2c0MWKF6fYNyIUiPH5cnF2J8bre55uQCcd8cg
        ==
X-ME-Sender: <xms:p9LrXHmXlYYqINt7V60jXwLy1BNZm39_bdmvAv3Ei6tTUoH2stmWlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:p9LrXPfVgroenVxo6hOT5lij3Fi0O7AZ-fXOHaeF27TGAHaghJEOiw>
    <xmx:p9LrXFybNSOHIsYwUYym31_mQLW9un8oTA725_vD1oTj6EtQVRZ1kg>
    <xmx:p9LrXJvcFHzj0i4WK68AmKWomlUWfk2DXsEKqkB_77JsuV01MGoetA>
    <xmx:p9LrXOg6PsDD0-QLGbk9PiRrvDRt-xJo-dxHF0ykx21iWM6t7yEyIA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 145D68005B;
        Mon, 27 May 2019 08:05:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Check keys for variable references in expressions" failed to apply to 5.0-stable tree
To:     tom.zanussi@linux.intel.com, rostedt@goodmis.org, vincent@bernat.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 14:05:49 +0200
Message-ID: <155895874910192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c8d94a1878342fdffedaaf15201d951dfc147065 Mon Sep 17 00:00:00 2001
From: Tom Zanussi <tom.zanussi@linux.intel.com>
Date: Thu, 18 Apr 2019 10:18:51 -0500
Subject: [PATCH] tracing: Check keys for variable references in expressions
 too

There's an existing check for variable references in keys, but it
doesn't go far enough.  It checks whether a key field is a variable
reference but doesn't check whether it's an expression containing
variable references, which can cause the same problems for callers.

Use the existing field_has_hist_vars() function rather than a direct
top-level flag check to catch all possible variable references.

Link: http://lkml.kernel.org/r/e8c3d3d53db5ca90ceea5a46e5413103a6902fc7.1555597045.git.tom.zanussi@linux.intel.com

Cc: stable@vger.kernel.org
Fixes: 067fe038e70f6 ("tracing: Add variable reference handling to hist triggers")
Reported-by: Vincent Bernat <vincent@bernat.ch>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 06e7b9f66de6..2b76f9520bd0 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -59,7 +59,7 @@
 	C(NO_CLOSING_PAREN,	"No closing paren found"),		\
 	C(SUBSYS_NOT_FOUND,	"Missing subsystem"),			\
 	C(INVALID_SUBSYS_EVENT,	"Invalid subsystem or event name"),	\
-	C(INVALID_REF_KEY,	"Using variable references as keys not supported"), \
+	C(INVALID_REF_KEY,	"Using variable references in keys not supported"), \
 	C(VAR_NOT_FOUND,	"Couldn't find variable"),		\
 	C(FIELD_NOT_FOUND,	"Couldn't find field"),
 
@@ -4506,7 +4506,7 @@ static int create_key_field(struct hist_trigger_data *hist_data,
 			goto out;
 		}
 
-		if (hist_field->flags & HIST_FIELD_FL_VAR_REF) {
+		if (field_has_hist_vars(hist_field, 0))	{
 			hist_err(tr, HIST_ERR_INVALID_REF_KEY, errpos(field_str));
 			destroy_hist_field(hist_field, 0);
 			ret = -EINVAL;


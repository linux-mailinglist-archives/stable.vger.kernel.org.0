Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0647C457362
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 17:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhKSQu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 11:50:29 -0500
Received: from www.linuxtv.org ([130.149.80.248]:43770 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231173AbhKSQu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 11:50:29 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mo72s-002cS3-Uh; Fri, 19 Nov 2021 16:47:26 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 19 Nov 2021 16:22:42 +0000
Subject: [git:media_stage/master] media: dib0700: fix undefined behavior in tuner shutdown
To:     linuxtv-commits@linuxtv.org
Cc:     Michael Kuron <michael.kuron@gmail.com>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mo72s-002cS3-Uh@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dib0700: fix undefined behavior in tuner shutdown
Author:  Michael Kuron <michael.kuron@gmail.com>
Date:    Sun Sep 26 21:51:26 2021 +0100

This fixes a problem where closing the tuner would leave it in a state
where it would not tune to any channel when reopened. This problem was
discovered as part of https://github.com/hselasky/webcamd/issues/16.

Since adap->id is 0 or 1, this bit-shift overflows, which is undefined
behavior. The driver still worked in practice as the overflow would in
most environments result in 0, which rendered the line a no-op. When
running the driver as part of webcamd however, the overflow could lead
to 0xff due to optimizations by the compiler, which would, in the end,
improperly shut down the tuner.

The bug is a regression introduced in the commit referenced below. The
present patch causes identical behavior to before that commit for
adap->id equal to 0 or 1. The driver does not contain support for
dib0700 devices with more adapters, assuming such even exist.

Tests have been performed with the Xbox One Digital TV Tuner on amd64.
Not all dib0700 devices are expected to be affected by the regression;
this code path is only taken by those with incorrect endpoint numbers.

Link: https://lore.kernel.org/linux-media/1d2fc36d94ced6f67c7cc21dcc469d5e5bdd8201.1632689033.git.mchehab+huawei@kernel.org

Cc: stable@vger.kernel.org
Fixes: 7757ddda6f4f ("[media] DiB0700: add function to change I2C-speed")
Signed-off-by: Michael Kuron <michael.kuron@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/dvb-usb/dib0700_core.c | 2 --
 1 file changed, 2 deletions(-)

---

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 70219b3e8566..7ea8f68b0f45 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -618,8 +618,6 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		deb_info("the endpoint number (%i) is not correct, use the adapter id instead", adap->fe_adap[0].stream.props.endpoint);
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
-		else
-			st->channel_state |=	1 << ~(adap->id);
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);

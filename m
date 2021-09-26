Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC03418B14
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 22:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhIZUxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 16:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhIZUxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 16:53:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34EAB61019;
        Sun, 26 Sep 2021 20:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632689491;
        bh=LaAstt3a2tNteoear8qqS4yJqMm/S16jSVvcgtTsn4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wf5hhgfxCAvAGrbI1/YZK6T3MdnCMPPME9yrZGwnJCogAaJmyHru3yk9dfIoagZXn
         H3DMpuDS3NQBJVNSuJ8FJ3sOwSWMVcsK+/4fD+crIHrUumB+LJ/+aBQYrBC/7Hrq8Z
         AhSUqDZs79N6xpuMc0f9T7uFAP8omuPyEQ48r04kPP0liGShVJyk+JD4EhpTKn+zT7
         t30cEu/OxeW5GM5VuoyVaRUeu8V4nnH44pjDdmdD5jQu3fMn214j/AKniqRipMa4rB
         1LrgJ94ejI5QLKBSPYlahVAVdjxkEbhujnPg29DDa9cWu1JchG4MFsVw/9lrPUwz0K
         tx2DVbsOacwsQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mUb7R-001Yb3-7Q; Sun, 26 Sep 2021 22:51:29 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Michael Kuron <michael.kuron@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Olivier Grenie <olivier.grenie@dibcom.fr>,
        Patrick Boettcher <patrick.boettcher@dibcom.fr>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        pb@linuxtv.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 1/3] media: dib0700: fix undefined behavior in tuner shutdown
Date:   Sun, 26 Sep 2021 22:51:26 +0200
Message-Id: <1d2fc36d94ced6f67c7cc21dcc469d5e5bdd8201.1632689033.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632689033.git.mchehab+huawei@kernel.org>
References: <cover.1632689033.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kuron <michael.kuron@gmail.com>

This fixes a problem where closing the tuner would leave it in a state
where it would not tune to any channel when reopened. This problem was
discovered as part of https://github.com/hselasky/webcamd/issues/16.

Since adap->id is 0 or 1, this bit-shift overflows, which is undefined
behavior. The driver still worked in practice as the overflow would in
most environments result in 0, which rendered the line a no-op. When
running the driver as part of webcamd however, the overflow could lead to
0xff due to optimizations by the compiler, which would, in the end,
improperly shut down the tuner.

The bug is a regression introduced in the commit referenced below. The
present patch causes identical behavior to before that commit for adap->id
equal to 0 or 1. The driver does not contain support for dib0700 devices
with more adapters, assuming such even exist.

Tests have been performed with the Xbox One Digital TV Tuner on amd64. Not
all dib0700 devices are expected to be affected by the regression; this
code path is only taken by those with incorrect endpoint numbers.

Cc: stable@vger.kernel.org
Fixes: 7757ddda6f4f ("[media] DiB0700: add function to change I2C-speed")
Signed-off-by: Michael Kuron <michael.kuron@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 2 --
 1 file changed, 2 deletions(-)

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
-- 
2.31.1


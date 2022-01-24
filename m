Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E348B4988D0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245458AbiAXSui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49856 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241926AbiAXSuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:50:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 536F0B8122D;
        Mon, 24 Jan 2022 18:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CA5C36AE9;
        Mon, 24 Jan 2022 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050202;
        bh=t/mC74GPu6DwbDU9BF7P9FlIn07H9tWh/CCjzNBe9Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s77J02W2fY9wTUhyxpgusjlHVaE+o78AoO9gDij983ggk/Yd6SxMJhU4r8vHWFl+h
         4ceIpJTUBlaNDKSuPCFt1Oav/pqf3WfvwAVr9KGyvv6rjhxiA77WIoTEEMQU0cqP4A
         TeL69D+apKYxe+P+FbRsMHFK0LD85fvZ9s6s8rpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kuron <michael.kuron@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.4 015/114] media: dib0700: fix undefined behavior in tuner shutdown
Date:   Mon, 24 Jan 2022 19:41:50 +0100
Message-Id: <20220124183927.582488506@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kuron <michael.kuron@gmail.com>

commit f7b77ebe6d2f49c7747b2d619586d1aa33f9ea91 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dib0700_core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -583,8 +583,6 @@ int dib0700_streaming_ctrl(struct dvb_us
 		deb_info("the endpoint number (%i) is not correct, use the adapter id instead", adap->fe_adap[0].stream.props.endpoint);
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
-		else
-			st->channel_state |=	1 << ~(adap->id);
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);



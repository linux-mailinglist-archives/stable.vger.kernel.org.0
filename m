Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F10549921A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381011AbiAXUR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40726 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358135AbiAXUNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92F46613FB;
        Mon, 24 Jan 2022 20:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDD0C36AE7;
        Mon, 24 Jan 2022 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055224;
        bh=R3SYvAKMvIzdD7gfCpbP1XBCEPkDA2vnynlCBsHNGkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zme50B2eUj/3zp4v/l+VHqr/WqXVcrsBcNSKZfdAHK6oo462Pl7VNWLSeAXDXGi31
         cfajdQYGm4XSxLFYbaomqTh75Vp95hmAs0TowBXvxKsoDwg4ignrcHbhcqkr+YS03u
         o8d5AWoZI06RueGhQ2CiIwdMyHJycaDOLb4fsZrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kuron <michael.kuron@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 048/846] media: dib0700: fix undefined behavior in tuner shutdown
Date:   Mon, 24 Jan 2022 19:32:45 +0100
Message-Id: <20220124184102.610803008@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -618,8 +618,6 @@ int dib0700_streaming_ctrl(struct dvb_us
 		deb_info("the endpoint number (%i) is not correct, use the adapter id instead", adap->fe_adap[0].stream.props.endpoint);
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
-		else
-			st->channel_state |=	1 << ~(adap->id);
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);



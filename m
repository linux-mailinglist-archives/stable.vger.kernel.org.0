Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8340D498B80
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346229AbiAXTOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344755AbiAXTLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50624C061A7D;
        Mon, 24 Jan 2022 11:03:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1E8A609EE;
        Mon, 24 Jan 2022 19:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE00CC340E8;
        Mon, 24 Jan 2022 19:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051013;
        bh=2oP2LDwVaJ0zFvAODpVplv81tT3l5LF8ATWXhfox+4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/7TaQ3CPZ4GAsbmTyMAPY3VMkQA9mkNDbLZxJIVazjg/xI5Urne87NZIIxji+YNC
         DfuzR5fCha1imNG2HJo3XEittcBMg7xLigEeVfdVjwro5Ma8bdUuna8EPm9B9F/9bV
         St9I9xmybnUf1/3Bbp8rslbyN0bLcZg5+2dJXdpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kuron <michael.kuron@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 026/186] media: dib0700: fix undefined behavior in tuner shutdown
Date:   Mon, 24 Jan 2022 19:41:41 +0100
Message-Id: <20220124183937.962117631@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
@@ -619,8 +619,6 @@ int dib0700_streaming_ctrl(struct dvb_us
 		deb_info("the endpoint number (%i) is not correct, use the adapter id instead", adap->fe_adap[0].stream.props.endpoint);
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
-		else
-			st->channel_state |=	1 << ~(adap->id);
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);



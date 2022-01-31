Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EDD4A4176
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358931AbiAaLEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:04:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36880 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359034AbiAaLCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7600E60ABE;
        Mon, 31 Jan 2022 11:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABB5C340E8;
        Mon, 31 Jan 2022 11:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626968;
        bh=ENdP0HiCeo/ou9suAY2/M17r/tqT17x+t6XVJsAoOcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vceD5xWbcfbF5JmURmU9Vex1oKScoQm2YG4OkbY228ruAVzbg9CGNiK2W80hTQFrU
         hkFzXNgmzDOY2EoDmp/Cefucym4qDd9o/0tZ0a9glKpYDzTPzJ+hK3Dz+0SLCT0cJV
         Lo1xkgEt0ND9f0NDC/k5+SVlLhklndM6ize09O8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: [PATCH 5.10 031/100] usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS
Date:   Mon, 31 Jan 2022 11:55:52 +0100
Message-Id: <20220131105221.498803465@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>

commit 904edf8aeb459697129be5fde847e2a502f41fd9 upstream.

Currently when gadget enumerates in super speed plus, the isoc
endpoint request buffer size is not calculated correctly. Fix
this by checking the gadget speed against USB_SPEED_SUPER_PLUS
and update the request buffer size.

Fixes: 90c4d05780d4 ("usb: fix various gadgets null ptr deref on 10gbps cabling.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Link: https://lore.kernel.org/r/1642820602-20619-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_sourcesink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -583,6 +583,7 @@ static int source_sink_start_ep(struct f
 
 	if (is_iso) {
 		switch (speed) {
+		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 			size = ss->isoc_maxpacket *
 					(ss->isoc_mult + 1) *



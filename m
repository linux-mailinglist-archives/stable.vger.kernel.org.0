Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0184A425E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbiAaLLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42812 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376903AbiAaLJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34B5061124;
        Mon, 31 Jan 2022 11:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077CDC340EF;
        Mon, 31 Jan 2022 11:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627356;
        bh=S80VFsfDMHRAWBlFU3f3ba+sIZ1ojgY8yoyvnC1ikHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKAszysUpw5QwfnK1DHaedP2yH+gJheq21nFAa9B9IemXQQZ8BSTWIyg2HGIFQN3t
         osjWGk0kJ8Jy/3kr0pxxqjVbGdxQn9NtpVWUYP6xeIxsFw54mVa0uKybikQtG1XhYN
         0YIgA8BOYqHt6js+upSiMnE/iwE2SQRrwTQu9j4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: [PATCH 5.15 056/171] usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS
Date:   Mon, 31 Jan 2022 11:55:21 +0100
Message-Id: <20220131105231.924289567@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -584,6 +584,7 @@ static int source_sink_start_ep(struct f
 
 	if (is_iso) {
 		switch (speed) {
+		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 			size = ss->isoc_maxpacket *
 					(ss->isoc_mult + 1) *



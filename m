Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD7E4A4388
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376605AbiAaLVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37112 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377854AbiAaLTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:19:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77980B82A5D;
        Mon, 31 Jan 2022 11:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F57C340E8;
        Mon, 31 Jan 2022 11:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627949;
        bh=S80VFsfDMHRAWBlFU3f3ba+sIZ1ojgY8yoyvnC1ikHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPeGwsOiAdOfyzM17U70fCjBkRS2LYTaTmJrLvE5pBtOV/iBGvhzzqUFYR6uJZ97x
         PppRnD5fU0E69CBo0qcYG8Hsd99BNsjZF1WhXa2caScTL3DqWjqM9bhjKzueftOA98
         XesFmPYQ1USmPqAxXPqf/krp6K0xW1wE1KBw3pvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: [PATCH 5.16 076/200] usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS
Date:   Mon, 31 Jan 2022 11:55:39 +0100
Message-Id: <20220131105236.141207022@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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



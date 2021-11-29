Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DE346227C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 21:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhK2Uvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 15:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbhK2Uto (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 15:49:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52380C0F4B0A;
        Mon, 29 Nov 2021 10:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E329CE13E1;
        Mon, 29 Nov 2021 18:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473EDC53FC7;
        Mon, 29 Nov 2021 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210311;
        bh=O/GzSBfQprp3dgLrjjnvHJx/hcIGyZV1EKXghSYk0IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRwLcC2kuseYuqmCGlpoddkU5l7yz9LDw8RuhiuP+mH2pNa/kON3em5yc8LCttrPc
         fXAP3q6RNdOHNbi4QQ+81D8kmS28VedI+WcWtNwblI5pYvO+4dExqcCbvkcHUePrQu
         x3FMujItEUhnN1yCkTPGtfc/dAkNcMg5i2+0W154=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 11/92] media: cec: copy sequence field for the reply
Date:   Mon, 29 Nov 2021 19:17:40 +0100
Message-Id: <20211129181707.797263700@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 13cbaa4c2b7bf9f8285e1164d005dbf08244ecd5 upstream.

When the reply for a non-blocking transmit arrives, the sequence
field for that reply was never filled in, so userspace would have no
way of associating the reply to the original transmit.

Copy the sequence field to ensure that this is now possible.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0dbacebede1e ([media] cec: move the CEC framework out of staging and to media)
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/cec-adap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1191,6 +1191,7 @@ void cec_received_msg_ts(struct cec_adap
 			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
 			msg->flags = dst->flags;
+			msg->sequence = dst->sequence;
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA827469AD4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243511AbhLFPL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58184 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346110AbhLFPIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:08:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6CCF6132C;
        Mon,  6 Dec 2021 15:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE520C341C1;
        Mon,  6 Dec 2021 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803118;
        bh=9WmHNZFyL4zsfb5jZ+SfVQRCR/sF7k7Dnr81g0Q52ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpYN6jm+0FnM29tNmXXcOtkvulrz/rJQ5YKhNkiXWQiEK7JdFP+WC9MdMiiDoZjaK
         lmJFmEJc1XHlJZsPhVr3gXoO5n7Y3bmZTkUWnDTkPOVETXMyZGk6jAXSaWo2dynWX6
         i4o6qICPmqR6dIjf/FkjeS6X2mSrZUCDn42B+DSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 007/106] media: cec: copy sequence field for the reply
Date:   Mon,  6 Dec 2021 15:55:15 +0100
Message-Id: <20211206145555.651269640@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
@@ -1135,6 +1135,7 @@ void cec_received_msg_ts(struct cec_adap
 			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
 			msg->flags = dst->flags;
+			msg->sequence = dst->sequence;
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);
 



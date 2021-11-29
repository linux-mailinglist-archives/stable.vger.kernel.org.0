Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322E2461EE1
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347797AbhK2Slf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:41:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54952 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379616AbhK2Sjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:39:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B9CDCE13D8;
        Mon, 29 Nov 2021 18:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BB3C53FC7;
        Mon, 29 Nov 2021 18:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210968;
        bh=T/3Qd29ZQKUw2wpw0iL/6zXHaZ1kNIAAEEgr6sljFqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/hTW2wybdjevzJRldxUyVcBbU3iUctgIl8LD4mb/iW/XrWAyM2rJPmu6eaMyzZu1
         CFTkOvSZyzmZkPwFvdhEqDxThxSEstLsOijy0TzBpnvr9w1hRvKgF+ggUyX789Iylf
         XY2Cen8Xcm0q51OMHCUNMW39TUigK2+XfQqg2FU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 025/179] media: cec: copy sequence field for the reply
Date:   Mon, 29 Nov 2021 19:16:59 +0100
Message-Id: <20211129181719.773228289@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
 drivers/media/cec/core/cec-adap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1199,6 +1199,7 @@ void cec_received_msg_ts(struct cec_adap
 			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
 			msg->flags = dst->flags;
+			msg->sequence = dst->sequence;
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);
 



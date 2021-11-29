Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9291E461D99
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377940AbhK2S0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:26:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58848 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345604AbhK2SYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:24:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6306B815CE;
        Mon, 29 Nov 2021 18:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4591C53FC7;
        Mon, 29 Nov 2021 18:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210093;
        bh=dv/skIBrfhpQe+V223FByW2PvouIpFhUAjG1X4D31ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgqYZ+qG5eA24WYfHOJEwoogLMWqz6DauSTyMS8AA0w+bIXbQgymbQXAQma1F+9oP
         vIIFYCxx4HJcfdYIBQmnxaJw9NZVIp/BVC3ewAXPdDhJB606DSQb88Spxar5dvvzxj
         rQ6yRh7FKQ6eFbhzbxQEIadk3Ggpp8E+x3wXY7Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 08/69] media: cec: copy sequence field for the reply
Date:   Mon, 29 Nov 2021 19:17:50 +0100
Message-Id: <20211129181703.938276206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
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
@@ -1146,6 +1146,7 @@ void cec_received_msg_ts(struct cec_adap
 			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
 			msg->flags = dst->flags;
+			msg->sequence = dst->sequence;
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33D2395FF8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhEaORq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhEaOPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97C7461481;
        Mon, 31 May 2021 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468576;
        bh=wo3zNAVYL00QHR8T64jEHnbvdwrsEjeG7yg6FtWbvlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjcK4yVEQXLHKziL5GyqPIoHvDj7yx21kex6irkuHfIrZu45IhGYWppFAC58f9i1u
         ZvlypGVjLSZkRrJZjvGHBBgAajJcAibjyn68DLxPzxHzWjFgJ7LXewnsZkYTFj+QdF
         PVt2O+8j6ypVzLuRRuWct94OoW//ij12+uhq7yaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.4 042/177] mei: request autosuspend after sending rx flow control
Date:   Mon, 31 May 2021 15:13:19 +0200
Message-Id: <20210531130649.374242652@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit bbf0a94744edfeee298e4a9ab6fd694d639a5cdf upstream.

A rx flow control waiting in the control queue may block autosuspend.
Re-request autosuspend after flow control been sent to unblock
the transition to the low power state.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210526193334.445759-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/interrupt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -222,6 +222,9 @@ static int mei_cl_irq_read(struct mei_cl
 		return ret;
 	}
 
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_request_autosuspend(dev->dev);
+
 	list_move_tail(&cb->list, &cl->rd_pending);
 
 	return 0;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC3C383437
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242183AbhEQPG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242717AbhEQPE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F99A61C17;
        Mon, 17 May 2021 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261702;
        bh=DGejjeRC7+aoqLuuEhvVuE+mag9lvvv+H+3HISvqTwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaQI/Rx/1H3J5Ja+NDPSGaRUdlOfpl8ZE2gM4gK9wwnQ28XtbraUKFemB5TLMFKD3
         GQzOhVk1vFXnq+tgLqDOjsUvuw5C/1c6ogtXVwM/VtChGMnKdOjK7GqOxiEqWlVYZo
         CrOubGrmMUBnOhVyObp61UUb7NzEVbJnGM8K+Oxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 143/329] remoteproc: pru: Fix wrong success return value for fw events
Date:   Mon, 17 May 2021 16:00:54 +0200
Message-Id: <20210517140306.949859871@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 1fe72bcfac087dba5ab52778e0646ed9e145cd32 ]

The irq_create_fwspec_mapping() returns a proper virq value on success
and 0 upon any failure. The pru_handle_intrmap() treats this as an error
and disposes all firmware event mappings correctly, but is returning
this incorrect value as is, letting the pru_rproc_start() interpret it
as a success and boot the PRU.

Fix this by returning an error value back upon any such failure. While
at this, revise the error trace to print some meaningful info about the
failed event.

Fixes: c75c9fdac66e ("remoteproc: pru: Add support for PRU specific interrupt configuration")
Signed-off-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210407155641.5501-3-s-anna@ti.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/pru_rproc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index 9226b8f3fe14..dcd5ea0d1f37 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -339,8 +339,10 @@ static int pru_handle_intrmap(struct rproc *rproc)
 
 		pru->mapped_irq[i] = irq_create_fwspec_mapping(&fwspec);
 		if (!pru->mapped_irq[i]) {
-			dev_err(dev, "failed to get virq\n");
-			ret = pru->mapped_irq[i];
+			dev_err(dev, "failed to get virq for fw mapping %d: event %d chnl %d host %d\n",
+				i, fwspec.param[0], fwspec.param[1],
+				fwspec.param[2]);
+			ret = -EINVAL;
 			goto map_fail;
 		}
 	}
-- 
2.30.2




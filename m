Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB991D80E4
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgERRnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729510AbgERRnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:43:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F50520872;
        Mon, 18 May 2020 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823781;
        bh=tW5Leq1Qq6QR+j8XMpLk7wPERRod4XTAdx7n1DmgJq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIMNAKIUbIm3DrvN+Jse21ieZGef/zuRkvnBSUqS2qlOp52HlppvQjezmt6RzfNX1
         boEcJuXHsBvYHuOBY/y3S497sWLLj5Utx5FmvOdwWSiYqMVfjQvWyb9HH2W8bqskJ2
         8k25rtQg/5rafxk3QSTl1iXsMuFTMMUrhBVXPDxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 34/90] ptp: do not explicitly set drvdata in ptp_clock_register()
Date:   Mon, 18 May 2020 19:36:12 +0200
Message-Id: <20200518173458.048509640@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 882f312dc0751c973db26478f07f082c584d16aa upstream.

We do not need explicitly call dev_set_drvdata(), as it is done for us by
device_create().

Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 2aa5b37cc6d24..08f304b83ad13 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -220,8 +220,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	if (IS_ERR(ptp->dev))
 		goto no_device;
 
-	dev_set_drvdata(ptp->dev, ptp);
-
 	err = ptp_populate_sysfs(ptp);
 	if (err)
 		goto no_sysfs;
-- 
2.20.1




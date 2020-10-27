Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199B629B8A4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799439AbgJ0Pm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800552AbgJ0Pgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C6D222275;
        Tue, 27 Oct 2020 15:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813000;
        bh=fBS5LtE5OqagiTeqYn5RUhthV+ThQHXyDy+qSbxygPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpdyfrvtCUSFS9Yp7AJHOv6BiSAcoklBP255YhJvUzilNfe1MNRFy/mZTm9BJh7QH
         as2NQTPxPGXETg3a22xQnXdMiZjLw3EJa28plY2cOB4KSLsheeJOy6G5gxlmUeeHGC
         ruy1OAaKZbEfM9h0pJgTGpGWWKX1sdd+IrzHupJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 376/757] ipmi_si: Fix wrong return value in try_smi_init()
Date:   Tue, 27 Oct 2020 14:50:26 +0100
Message-Id: <20201027135508.189167081@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 8fe7990ceda8597e407d06bffc4bdbe835a93ece ]

On an error exit path, a negative error code should be returned
instead of a positive return value.

Fixes: 90b2d4f15ff7 ("ipmi_si: Remove hacks for adding a dummy platform devices")
Cc: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-Id: <20201005145212.84435-1-tianjia.zhang@linux.alibaba.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 77b8d551ae7fe..dd559661c15b3 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1963,7 +1963,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	/* Do this early so it's available for logs. */
 	if (!new_smi->io.dev) {
 		pr_err("IPMI interface added with no device\n");
-		rv = EIO;
+		rv = -EIO;
 		goto out_err;
 	}
 
-- 
2.25.1




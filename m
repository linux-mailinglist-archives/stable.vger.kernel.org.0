Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CDD29B243
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761165AbgJ0OiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761154AbgJ0OiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA728207BB;
        Tue, 27 Oct 2020 14:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809493;
        bh=oecFvKAy6hw4veuir3jzX3L9OcRpPw2OEucGpkYBOtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAisBk5rJNx+A8Z3EjDe+GORk5xvXx+9rOMPKS2q8Z7B5TtRmfmejGBq/0iKlDQGu
         ypA/YnxnCQNcaV76BXl1CY9wWfcWXBwpVlMnwX1W2doPpswGhcgVNYMgR7T4D33Sqt
         Pt4hhYygo8l8ztySMiVi5QFVud45tajXye0iQs9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/408] ipmi_si: Fix wrong return value in try_smi_init()
Date:   Tue, 27 Oct 2020 14:52:03 +0100
Message-Id: <20201027135503.675096339@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 6b9a0593d2eb7..b6e7df9e88503 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1977,7 +1977,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	/* Do this early so it's available for logs. */
 	if (!new_smi->io.dev) {
 		pr_err("IPMI interface added with no device\n");
-		rv = EIO;
+		rv = -EIO;
 		goto out_err;
 	}
 
-- 
2.25.1




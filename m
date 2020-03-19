Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897D918B6A6
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbgCSN0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgCSN03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D936520658;
        Thu, 19 Mar 2020 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624389;
        bh=PNrmHsCIJfqE4uohYbNXy7WH6tKKMYk92T39QNr6kac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMr/0Z3AVVQaewemIHiRRROk9iE/luLIGKix2NQepKXFmT3PG2Pr2IssuIc+dBcta
         QU1FZ4ry9TFW4jBkFRZCU+Xg0gEHnnWsr48sTFpaBJwa/u99ARzKkg459rBgGGxS4e
         H3i3QPuQzj4bJ1JhVXYKqT7FsE0mhaCCu7IpdxmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 45/65] hinic: fix a bug of rss configuration
Date:   Thu, 19 Mar 2020 14:04:27 +0100
Message-Id: <20200319123940.658382490@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 386d4716fd91869e07c731657f2cde5a33086516 ]

should use real receive queue number to configure hw rss
indirect table rather than maximal queue number

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 2411ad270c98e..42d00b049c6e8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -356,7 +356,8 @@ static void hinic_enable_rss(struct hinic_dev *nic_dev)
 	if (!num_cpus)
 		num_cpus = num_online_cpus();
 
-	nic_dev->num_qps = min_t(u16, nic_dev->max_qps, num_cpus);
+	nic_dev->num_qps = hinic_hwdev_num_qps(hwdev);
+	nic_dev->num_qps = min_t(u16, nic_dev->num_qps, num_cpus);
 
 	nic_dev->rss_limit = nic_dev->num_qps;
 	nic_dev->num_rss = nic_dev->num_qps;
-- 
2.20.1




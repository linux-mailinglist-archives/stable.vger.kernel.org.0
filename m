Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6680015C422
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgBMP1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387667AbgBMP1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:05 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166B720661;
        Thu, 13 Feb 2020 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607625;
        bh=qalAB5bKEGVK827bqT35jJirfnT6wm6bOd0KLJ3sqa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrqIS/KXSeHBIGb5jPLSK1FbYkozUQLVPtsbtZNMCU1lDRddvrGkCvdjZTkwhligR
         K/Sh8+Y4rpZDKqi4H2jBFm5GStr7Vd8tS4nPY28DtxPYard9oI1p/B73irrWbAIzFD
         OnEOG1nZhL/ZQ+NupESwswj25hCdZPQfKhJJz0ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 07/96] RDMA/i40iw: fix a potential NULL pointer dereference
Date:   Thu, 13 Feb 2020 07:20:14 -0800
Message-Id: <20200213151841.973038724@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 04db1580b5e48a79e24aa51ecae0cd4b2296ec23 upstream.

A NULL pointer can be returned by in_dev_get(). Thus add a corresponding
check so that a NULL pointer dereference will be avoided at this place.

Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
Link: https://lore.kernel.org/r/1577672668-46499-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/i40iw/i40iw_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1225,6 +1225,8 @@ static void i40iw_add_ipv4_addr(struct i
 			const struct in_ifaddr *ifa;
 
 			idev = in_dev_get(dev);
+			if (!idev)
+				continue;
 			in_dev_for_each_ifa_rtnl(ifa, idev) {
 				i40iw_debug(&iwdev->sc_dev, I40IW_DEBUG_CM,
 					    "IP=%pI4, vlan_id=%d, MAC=%pM\n", &ifa->ifa_address,



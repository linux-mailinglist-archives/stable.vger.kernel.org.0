Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF7144EAD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgAVJag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVJae (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:30:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E8B724673;
        Wed, 22 Jan 2020 09:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685433;
        bh=zPjs+tVGI9LSJMOzn29WDkK/KTQw5p59s0ju7EurzYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jp92haY94684QFfkbMkFuHfxgaTYtusWDlS0Aomtz4Z6JE7w3dszh4hzWurR1UBbT
         W72B8HY13zVWRdqw7vbrvS+CSO3m+qxi7EKw04/ys8nNATFD6hYSvDuIzQGaJ5uKBL
         2+BaI3XwHe7XBZgnWyxuJ+5RH7By8ZUkgW7C+aPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 13/76] wimax: i2400: fix memory leak
Date:   Wed, 22 Jan 2020 10:28:29 +0100
Message-Id: <20200122092752.924150591@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 2507e6ab7a9a440773be476141a255934468c5ef upstream.

In i2400m_op_rfkill_sw_toggle cmd buffer should be released along with
skb response.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wimax/i2400m/op-rfkill.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -142,6 +142,7 @@ int i2400m_op_rfkill_sw_toggle(struct wi
 			"%d\n", result);
 	result = 0;
 error_cmd:
+	kfree(cmd);
 	kfree_skb(ack_skb);
 error_msg_to_dev:
 error_alloc:



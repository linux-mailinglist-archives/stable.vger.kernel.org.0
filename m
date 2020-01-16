Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1153D13FEA3
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404460AbgAPXhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391366AbgAPXbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FFF420661;
        Thu, 16 Jan 2020 23:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217480;
        bh=c0gxPAEd/zpRFcwzNNKQm8bhr5vCEg4u8wtCDuz6ZLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8MdZKw8tgyQPnOv8iisUW9AjHZbbfEzkm2WIrtyjlitK6Aei1J9p92Yytd7Ddk+T
         vkcTYSpG7D+XacJamESFBIMAK4T7pKlX15c+FAyUX+DfKMBF7cxj+IF7GJfHqf+rxU
         ImrC1DRiEZiN4eS9OoQ+r5FXyosyfztRiFLPy39E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 16/71] wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle
Date:   Fri, 17 Jan 2020 00:18:14 +0100
Message-Id: <20200116231711.811747304@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 6f3ef5c25cc762687a7341c18cbea5af54461407 upstream.

In the implementation of i2400m_op_rfkill_sw_toggle() the allocated
buffer for cmd should be released before returning. The
documentation for i2400m_msg_to_dev() says when it returns the buffer
can be reused. Meaning cmd should be released in either case. Move
kfree(cmd) before return to be reached by all execution paths.

Fixes: 2507e6ab7a9a ("wimax: i2400: fix memory leak")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wimax/i2400m/op-rfkill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -142,12 +142,12 @@ int i2400m_op_rfkill_sw_toggle(struct wi
 			"%d\n", result);
 	result = 0;
 error_cmd:
-	kfree(cmd);
 	kfree_skb(ack_skb);
 error_msg_to_dev:
 error_alloc:
 	d_fnend(4, dev, "(wimax_dev %p state %d) = %d\n",
 		wimax_dev, state, result);
+	kfree(cmd);
 	return result;
 }
 



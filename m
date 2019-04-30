Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D30F813
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfD3Llk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbfD3Llh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:41:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7670621670;
        Tue, 30 Apr 2019 11:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624496;
        bh=Q0pLV2EOyNxF7SO6dQrgct4pt7SeONLWomO0a+1iI1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpqVpdFid74IuIu+xDLBQInu7kB6n9rgInjnGv1yZDA/AHPJMDQM/E8oNkfGiCfsF
         8fqlKnR/gh+t0ci38GYS8RYM1XjZjCYQ9qOHlHirge0oBepEoRdFvSri5irGRkaZq5
         1bPPoKDC235h4X8ryCHOUaQ0vP+Nud+5BRHIQU0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 16/53] Input: synaptics-rmi4 - write config register values to the right offset
Date:   Tue, 30 Apr 2019 13:38:23 +0200
Message-Id: <20190430113553.312761433@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 3a349763cf11e63534b8f2d302f2d0c790566497 upstream.

Currently any changed config register values don't take effect, as the
function to write them back is called with the wrong register offset.

Fixes: ff8f83708b3e (Input: synaptics-rmi4 - add support for 2D
                     sensors and F11)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_f11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -1239,7 +1239,7 @@ static int rmi_f11_initialize(struct rmi
 	}
 
 	rc = f11_write_control_regs(fn, &f11->sens_query,
-			   &f11->dev_controls, fn->fd.query_base_addr);
+			   &f11->dev_controls, fn->fd.control_base_addr);
 	if (rc)
 		dev_warn(&fn->dev, "Failed to write control registers\n");
 



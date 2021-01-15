Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89422F79B0
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733273AbhAOMjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732190AbhAOMjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85791239D0;
        Fri, 15 Jan 2021 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714344;
        bh=UQLqRvyhXl1RJS1qS38hjC7R1YuS7rM9Xrg8FoCRFEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWqD9nGjgK0DGsIQlPsNBOPIT3JSyg6YoCD2r1nbPlDU7WiSwF1SxCoWJiG2arZs+
         u/pD9AjbDiIsd0utK27vT3Aq+kMYOu2Xqi3bZGaht3rjZzEfrUFT2D8DV/TXqYXd4f
         GOAIMgx6mAuPc672zeKNnmkwcmkY5t76yOe9YeUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Georgi Djakov <georgi.djakov@linaro.org>
Subject: [PATCH 5.10 066/103] interconnect: imx: Add a missing of_node_put after of_device_is_available
Date:   Fri, 15 Jan 2021 13:27:59 +0100
Message-Id: <20210115122009.235131633@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit c6174c0e058fc0a54e0b9787c44cb24b0a8d0217 upstream.

Add an 'of_node_put()' call when a tested device node is not available.

Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201206121304.29381-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/interconnect/imx/imx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/interconnect/imx/imx.c
+++ b/drivers/interconnect/imx/imx.c
@@ -99,6 +99,7 @@ static int imx_icc_node_init_qos(struct
 		if (!dn || !of_device_is_available(dn)) {
 			dev_warn(dev, "Missing property %s, skip scaling %s\n",
 				 adj->phandle_name, node->name);
+			of_node_put(dn);
 			return 0;
 		}
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564E217FA77
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgCJNEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbgCJNEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B07020409;
        Tue, 10 Mar 2020 13:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845480;
        bh=zWETaLoF3P9WxIFHo1I7CF9gPRCLgj9bgSHy5PC6HSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWqHTqsGrMpy12MppnIuHqafCqPMkNkRRULXzpf4WYg7xJ+mf5TEAH2J1lgAaZq/P
         2fhouWpQtQyfiG9rtYyCDYWJ5/tMLC1WOefZOKgliKMLBMeBM/xOwsNO+z/Uqnp4Qw
         dwNiIoxICKyyWP4DKQiJbIiKsNzHL540H5IZiU1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.5 156/189] firmware: imx: scu-pd: Align imx sc msg structs to 4
Date:   Tue, 10 Mar 2020 13:39:53 +0100
Message-Id: <20200310123655.737757975@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

commit 7c1a1c814ccc858633c761951c2546041202b24e upstream.

The imx SC api strongly assumes that messages are composed out of
4-bytes words but some of our message structs have odd sizeofs.

This produces many oopses with CONFIG_KASAN=y.

Fix by marking with __aligned(4).

Fixes: c800cd7824bd ("firmware: imx: add SCU power domain driver")
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/imx/scu-pd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/imx/scu-pd.c
+++ b/drivers/firmware/imx/scu-pd.c
@@ -61,7 +61,7 @@ struct imx_sc_msg_req_set_resource_power
 	struct imx_sc_rpc_msg hdr;
 	u16 resource;
 	u8 mode;
-} __packed;
+} __packed __aligned(4);
 
 #define IMX_SCU_PD_NAME_SIZE 20
 struct imx_sc_pm_domain {



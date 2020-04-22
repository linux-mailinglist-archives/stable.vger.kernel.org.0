Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7443C1B4197
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgDVKIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbgDVKIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:08:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB06D2075A;
        Wed, 22 Apr 2020 10:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550111;
        bh=T/a03JFRVwZf26cJQ8+4XA7GcZj1JeU8Ggit0HX5RJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSX7rqgUCcIH1Z6vZNh/yUjRRYp3BIMf3ZZ34c6CQDGbr/AtADnC3ipYHfgH61dy9
         1MzPtAGAUjvf1j68BzhVvvXT+UVQx1Jbb/RFrGBgdTJ62bl6TyXhTY0F4YZvu0wwJh
         T6zcPKu6GcHSlACcKUhcoQ/bhnfDQlXAn9fD+auY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 006/199] qlcnic: Fix bad kzalloc null test
Date:   Wed, 22 Apr 2020 11:55:32 +0200
Message-Id: <20200422095058.541192637@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>

[ Upstream commit bcaeb886ade124331a6f3a5cef34a3f1484c0a03 ]

In qlcnic_83xx_get_reset_instruction_template, the variable
of null test is bad, so correct it.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index 07f9067affc65..cda5b0a9e9489 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -1720,7 +1720,7 @@ static int qlcnic_83xx_get_reset_instruction_template(struct qlcnic_adapter *p_d
 
 	ahw->reset.seq_error = 0;
 	ahw->reset.buff = kzalloc(QLC_83XX_RESTART_TEMPLATE_SIZE, GFP_KERNEL);
-	if (p_dev->ahw->reset.buff == NULL)
+	if (ahw->reset.buff == NULL)
 		return -ENOMEM;
 
 	p_buff = p_dev->ahw->reset.buff;
-- 
2.20.1




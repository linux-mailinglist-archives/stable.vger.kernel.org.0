Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682B4147E70
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387657AbgAXKJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733082AbgAXKJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:09:04 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFAD220709;
        Fri, 24 Jan 2020 10:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860544;
        bh=A4VOQoF9dWI8S5tSrJ048hbisbbfIjDHmUMOCk3lkHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpz6Ue7OWJsVtDjEjy2bSApepN7ff1QaSHR8R/SjVYR5dgkWPW3pZqJLw2dj0Nh97
         d0DXkI1YHpm+XAfjaN96TMCSY8bs/Mg1WtSQqsWKy3BzzXdBCfS8RYZ0gK7GfLY6yE
         9KT/VPkdpzEE3B9Yu1sHdInZ/J2ASufYKpxmSPOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 011/639] mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
Date:   Fri, 24 Jan 2020 10:23:01 +0100
Message-Id: <20200124093048.500454749@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 15e14f76f85f4f0eab3b8146e1cd3c58ce272823 upstream.

Fix bbp ready check in mt7601u_wait_bbp_ready. The issue is reported by
coverity with the following error:

Logical vs. bitwise operator
The expression's value does not depend on the operands; inadvertent use
of the wrong operator is a likely logic error.

Addresses-Coverity-ID: 1309441 ("Logical vs. bitwise operator")
Fixes: c869f77d6abb ("add mt7601u driver")
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt7601u/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -221,7 +221,7 @@ int mt7601u_wait_bbp_ready(struct mt7601
 
 	do {
 		val = mt7601u_bbp_rr(dev, MT_BBP_REG_VERSION);
-		if (val && ~val)
+		if (val && val != 0xff)
 			break;
 	} while (--i);
 



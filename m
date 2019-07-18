Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DEB6C6EE
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389352AbfGRDKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390762AbfGRDKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:46 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6AA205F4;
        Thu, 18 Jul 2019 03:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419446;
        bh=DP20boK1KDY+Iu06I4W2JFwC0eRC1R0e+VRqs1yQYBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUeCT8mkVLeygqudMeycPFjztiEcZbCT2hP72DBtaxYac9V0nk6YrseccU3ZKt++L
         axnqPVB10uC2ZCxu4OeFLDKkAR/f7jmt4t6g4TPYWcGHGZUagBK6Rn48uDfs+Vse6X
         OtKldSnBMXcUMIlRnCq4nioa5euvYTrmc0QelSCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 67/80] ppp: mppe: Add softdep to arc4
Date:   Thu, 18 Jul 2019 12:01:58 +0900
Message-Id: <20190718030103.669983354@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit aad1dcc4f011ea409850e040363dff1e59aa4175 ]

The arc4 crypto is mandatory at ppp_mppe probe time, so let's put a
softdep line, so that the corresponding module gets prepared
gracefully.  Without this, a simple inclusion to initrd via dracut
failed due to the missing dependency, for example.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_mppe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index 6c7fd98cb00a..d9eda7c217e9 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -63,6 +63,7 @@ MODULE_AUTHOR("Frank Cusack <fcusack@fcusack.com>");
 MODULE_DESCRIPTION("Point-to-Point Protocol Microsoft Point-to-Point Encryption support");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_MPPE));
+MODULE_SOFTDEP("pre: arc4");
 MODULE_VERSION("1.0.2");
 
 static unsigned int
-- 
2.20.1




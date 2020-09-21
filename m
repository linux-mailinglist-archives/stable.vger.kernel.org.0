Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B59E272CD4
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgIUQfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728793AbgIUQek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9741F2396F;
        Mon, 21 Sep 2020 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706080;
        bh=+AXgOdv8EoZXwhDmI8inikJXHg/STxz2MzjWVDFiXkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1T8PbNtW772LKM1UABpCl4BngU9V8F/y1iyKI7255TlcgVr5PcJ488DBPq9vASkIq
         ZvSMdrubMImCy0BlTtfkFXD7WJ3WV4wJpZx0VGOzlaqZjIkK/un2Elf6e6BV903HU2
         dwj+u0U4kzyWVQr1+6p3Q5wOvStts9q89qzd+uNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/70] firestream: Fix memleak in fs_open
Date:   Mon, 21 Sep 2020 18:27:07 +0200
Message-Id: <20200921162035.462711161@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 15ac5cdafb9202424206dc5bd376437a358963f9 ]

When make_rate() fails, vcc should be freed just
like other error paths in fs_open().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/firestream.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 82296fe2ba3bd..7cb2b863e653e 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1013,6 +1013,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
 				error = make_rate (pcr, r, &tmc0, NULL);
 				if (error) {
 					kfree(tc);
+					kfree(vcc);
 					return error;
 				}
 			}
-- 
2.25.1




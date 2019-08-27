Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963E89E22A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfH0HwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbfH0HwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:52:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D7D22CF4;
        Tue, 27 Aug 2019 07:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892333;
        bh=V++gE4PvWJuMkpFtwQmcf/K7K1tPmJWBBFBe94xTzPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igtAVhctzmTl0EZbPSIyT6kyxpByCfKkcd19GRy/gsyXFpklSS2brbD1egCEo6G9g
         YntM3G218vix6wEIvrl09aUFj47pIHNGsQDLJQRXt91t4wUp9O2r8+q6aLaCRoRJHp
         fFRPk4xcb9XC77Ka6i0cb0dwT4gqxY624luEBhFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/62] net/ethernet/qlogic/qed: force the string buffer NULL-terminated
Date:   Tue, 27 Aug 2019 09:50:25 +0200
Message-Id: <20190827072701.496921144@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3690c8c9a8edff0db077a38783112d8fe12a7dd2 ]

strncpy() does not ensure NULL-termination when the input string
size equals to the destination buffer size 30.
The output string is passed to qed_int_deassertion_aeu_bit()
which calls DP_INFO() and relies NULL-termination.

Use strlcpy instead. The other conditional branch above strncpy()
needs no fix as snprintf() ensures NULL-termination.

This issue is identified by a Coccinelle script.

Signed-off-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 7746417130bd7..c5d9f290ec4c7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -939,7 +939,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 						snprintf(bit_name, 30,
 							 p_aeu->bit_name, num);
 					else
-						strncpy(bit_name,
+						strlcpy(bit_name,
 							p_aeu->bit_name, 30);
 
 					/* We now need to pass bitmask in its
-- 
2.20.1




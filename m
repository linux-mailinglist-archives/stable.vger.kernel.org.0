Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431719E1C7
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfH0Hz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbfH0Hz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:55:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71027206BF;
        Tue, 27 Aug 2019 07:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892556;
        bh=07DBjmrnK+4KXHGEwkJ9AMWymOayCreOothOCT/aqb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3VCp53GBdMS6zZ99nXBBT6HRKoyEfohyn8SPOkQcobdliBIXCJ9UNNayNLxBPhQg
         wOTEzHVlAV4XEzSWVTzOYqJT0azZi2sccsJBMAfLs0twugIM0t4/zU2SCapM5vbMe7
         HOck0DU5pvwraqvjFxaQBjWEsmL+5XHPaiFdmu6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/98] net/ethernet/qlogic/qed: force the string buffer NULL-terminated
Date:   Tue, 27 Aug 2019 09:50:12 +0200
Message-Id: <20190827072719.913350183@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
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
index b22f464ea3fa7..f9e475075d3ea 100644
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




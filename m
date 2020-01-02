Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48E612F0E4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgABWSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgABWSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F171A21582;
        Thu,  2 Jan 2020 22:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003495;
        bh=JWb2HTxKjwt7c+2VWSuV6dZw+rY7dUeS0VEpkgAQJ6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4vAqq6TJnYgbwpqVfSQpaEK1t5nLpaaaycQ7EbJEkOHXtyWwEpojt6Oxd37foV9J
         7My6iR8W1PzTdAE99fBAT1rf31SprZlxEY0gcc7uNQ3rPY0mALUlqXMNcHZfr5YOeE
         yB9jHw9wevkqTyXND0vR9xgVw4io/orHeLKlQnhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 185/191] bnxt: apply computed clamp value for coalece parameter
Date:   Thu,  2 Jan 2020 23:07:47 +0100
Message-Id: <20200102215849.345722090@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit 6adc4601c2a1ac87b4ab8ed0cb55db6efd0264e8 ]

After executing "ethtool -C eth0 rx-usecs-irq 0", the box becomes
unresponsive, likely due to interrupt livelock.  It appears that
a minimum clamp value for the irq timer is computed, but is never
applied.

Fix by applying the corrected clamp value.

Fixes: 74706afa712d ("bnxt_en: Update interrupt coalescing logic.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6178,7 +6178,7 @@ static void bnxt_hwrm_set_coal_params(st
 		tmr = bnxt_usec_to_coal_tmr(bp, hw_coal->coal_ticks_irq);
 		val = clamp_t(u16, tmr, 1,
 			      coal_cap->cmpl_aggr_dma_tmr_during_int_max);
-		req->cmpl_aggr_dma_tmr_during_int = cpu_to_le16(tmr);
+		req->cmpl_aggr_dma_tmr_during_int = cpu_to_le16(val);
 		req->enables |=
 			cpu_to_le16(BNXT_COAL_CMPL_AGGR_TMR_DURING_INT_ENABLE);
 	}



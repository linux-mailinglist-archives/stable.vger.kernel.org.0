Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03182011B4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394080AbgFSPnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392996AbgFSP2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A19A320734;
        Fri, 19 Jun 2020 15:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580494;
        bh=BCMxLLUVL/GAQayZQJbT4GVwOVpnytU/QSFr1+km1qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02QRRtCUjtq+fjvbdQj8CPoUfXYPrKlLMwUH/tM6sMelC+oA6WSxI7vrb9Z+f5elY
         uNu/REOn336kvbpBd3h0D9Rx+PPjPSvCh+De/y+4uMeERtJOnYZ+4ZxmFLIPA2F7h0
         xhAIEtVkIg37R13ECthzstBWGp4l+5Gtsv/MGNbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lichao Liu <liulichao@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.7 270/376] MIPS: CPU_LOONGSON2EF need software to maintain cache consistency
Date:   Fri, 19 Jun 2020 16:33:08 +0200
Message-Id: <20200619141723.109778191@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lichao Liu <liulichao@loongson.cn>

commit a202bf71f08b3ef15356db30535e30b03cf23aec upstream.

CPU_LOONGSON2EF need software to maintain cache consistency,
so modify the 'cpu_needs_post_dma_flush' function to return true
when the cpu type is CPU_LOONGSON2EF.

Cc: stable@vger.kernel.org
Signed-off-by: Lichao Liu <liulichao@loongson.cn>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/dma-noncoherent.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/mm/dma-noncoherent.c
+++ b/arch/mips/mm/dma-noncoherent.c
@@ -33,6 +33,7 @@ static inline bool cpu_needs_post_dma_fl
 	case CPU_R10000:
 	case CPU_R12000:
 	case CPU_BMIPS5000:
+	case CPU_LOONGSON2EF:
 		return true;
 	default:
 		/*



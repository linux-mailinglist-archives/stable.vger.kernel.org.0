Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3329E086
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbfH0IEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732614AbfH0IEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D30206BA;
        Tue, 27 Aug 2019 08:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893082;
        bh=zV8X+i0yft+xSL7KfefChcO/vKkxgbS1/CmVBOebe9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySNqxDXGPZR4DwXvCxz/rgcnzZLerGmyspTOZNvDo4n+T3Gt/DSa4Cpwjj82F54cT
         a9zP00CPSFWRX4RIoaI4oBZLj06CUeZ7wJB2eilejYScBzyOBPmdf93UQMiYAh1g1m
         8d8iQmdqfpDScTm3CN6H8UqsSMTmwJluPMbFPXLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.2 115/162] clk: socfpga: stratix10: fix rate caclulationg for cnt_clks
Date:   Tue, 27 Aug 2019 09:50:43 +0200
Message-Id: <20190827072742.411754638@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit c7ec75ea4d5316518adc87224e3cff47192579e7 upstream.

Checking bypass_reg is incorrect for calculating the cnt_clk rates.
Instead we should be checking that there is a proper hardware register
that holds the clock divider.

Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lkml.kernel.org/r/20190814153014.12962-1-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/socfpga/clk-periph-s10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/socfpga/clk-periph-s10.c
+++ b/drivers/clk/socfpga/clk-periph-s10.c
@@ -38,7 +38,7 @@ static unsigned long clk_peri_cnt_clk_re
 	if (socfpgaclk->fixed_div) {
 		div = socfpgaclk->fixed_div;
 	} else {
-		if (!socfpgaclk->bypass_reg)
+		if (socfpgaclk->hw.reg)
 			div = ((readl(socfpgaclk->hw.reg) & 0x7ff) + 1);
 	}
 



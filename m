Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAADEE8AF0
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 15:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbfJ2OiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 10:38:08 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:46041 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388885AbfJ2OiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 10:38:08 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 5A08D3C0582;
        Tue, 29 Oct 2019 15:38:05 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aAdtT_z4Yddc; Tue, 29 Oct 2019 15:37:59 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 653233C0585;
        Tue, 29 Oct 2019 15:37:56 +0100 (CET)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Tue, 29 Oct
 2019 15:37:56 +0100
Date:   Tue, 29 Oct 2019 15:37:53 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC:     <horms@verge.net.au>, <linux-pci@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <stable@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yohhei Fukui <yohhei.fukui@denso-ten.com>,
        Asano Yasushi <yasano@jp.adit-jv.com>,
        Steffen Pengel <spengel@jp.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH v4] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Message-ID: <20191029143753.GA28404@vmlxhi-102.adit-jv.com>
References: <1570769432-15358-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1570769432-15358-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.12.1+40 (7f8642d4ee82) (2019-06-28)
X-Originating-IP: [10.72.93.184]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Shimoda-san, dear reviewers,

On Fri, Oct 11, 2019 at 01:50:32PM +0900, Yoshihiro Shimoda wrote:
> According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
> should be written to 0 before enabling PCIETCTLR.CFINIT because
> the bit 0 is set to 1 on reset. To avoid unexpected behaviors from
> this incorrect setting, this patch fixes it.

Your development and reviewing effort to reach v4 is very appreciated.

However, in the context of some internal reviews of this patch, we are
having hard times reconciling the change with our (possibly incomplete
or inaccurate) interpretation of the R-Car3 HW User’s Manual (Rev.2.00
Jul 2019). The latter says in
Chapter "54. PCIE Controller" / "(2) Initial Setting of PCI Express":

 ----snip----
 Be sure to write the initial value (= H'80FF 0000) to MACCTLR before
 enabling PCIETCTLR.CFINIT.
 ----snip----

Is my assumption correct that the description of this patch is a
rewording of the above quote from the manual or is there another more
precise statement referring to resetting LSB only (w/o touching the
rest of the MACCTLR bits)?

If it is only the LSB which "should be written to 0 before enabling
PCIETCTLR.CFINIT", would you agree that the statement quoted from the
manual would better be rephrased appropriately? TIA.

> 
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

-- 
Best Regards,
Eugeniu

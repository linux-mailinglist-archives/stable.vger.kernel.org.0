Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA62487C16
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 19:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiAGSVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 13:21:01 -0500
Received: from mailgate.ics.forth.gr ([139.91.1.2]:41118 "EHLO
        mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbiAGSVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 13:21:00 -0500
X-Greylist: delayed 1008 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2022 13:21:00 EST
Received: from av3.ics.forth.gr (av3in.ics.forth.gr [139.91.1.77])
        by mailgate.ics.forth.gr (8.15.2/ICS-FORTH/V10-1.8-GATE) with ESMTP id 207I4AUu063116
        for <stable@vger.kernel.org>; Fri, 7 Jan 2022 20:04:10 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; d=ics.forth.gr; s=av; c=relaxed/simple;
        q=dns/txt; i=@ics.forth.gr; t=1641578645; x=1644170645;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s5cE7HP13OGL6tOvFCkENHSYqRvjKRhAnn9y2DfklEY=;
        b=Mp+IGz0UgN4HJYPOjgg+7qeQlNA4QDeHhRQoBpfVqFazG5PR9WJnNCeaRcTiWr3a
        1t1JnTZ9zO4/i4CN1oa3KP2GBUeBGnNKjLpwDKoNzR80fp+ab12YXXaGEN+x5Naj
        Jzp4ltQUFw7F4jw67r4Rc3rcJ9dhUQGk+fjYgfDy/ophM1p2+zx1fiOHyZ1wXRBL
        LTZPjtM61sN9rSGmi120RKImF+IvzXAhehY3WUhuV/84/JthaQlbmSxybXvGSUYL
        51jtxJUp8tm+oybQCq+GwKpwJWNXFT4D288s13sYZxJd9jqluXBE3kui7iCQ23tP
        TDxotv07U3eKDgnLpV0htQ==;
X-AuditID: 8b5b014d-9a2477000000460a-c1-61d880957c58
Received: from enigma.ics.forth.gr (webmail.ics.forth.gr [139.91.151.35])
        by av3.ics.forth.gr (Symantec Messaging Gateway) with SMTP id 8F.71.17930.59088D16; Fri,  7 Jan 2022 20:04:05 +0200 (EET)
X-ICS-AUTH-INFO: Authenticated user:  at ics.forth.gr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 07 Jan 2022 20:03:59 +0200
From:   Nick Kossifidis <mick@ics.forth.gr>
To:     Nick Kossifidis <mick@ics.forth.gr>
Cc:     palmer@dabbelt.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] riscv: Don't use va_pa_offset on kdump
Organization: FORTH
In-Reply-To: <20211126180411.187597-1-mick@ics.forth.gr>
References: <20211126180411.187597-1-mick@ics.forth.gr>
Message-ID: <70fe8aa8bfe3923308e6248377577f58@mailhost.ics.forth.gr>
X-Sender: mick@mailhost.ics.forth.gr
User-Agent: Roundcube Webmail/1.3.16
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsXSHT1dWXdqw41Eg2NTuC2e3fnKarH19yx2
        i8u75rBZbPvcwmbR/O4cu8XLyz3MFm2z+C0WbHzE6MDh8eblSxaPwx1f2D3unZjG6vFw0yUm
        j81L6j0uNV9n9/i8SS6APYrLJiU1J7MstUjfLoEr49ehPWwF87grrjedY29gbOHsYuTkkBAw
        kbg/Zx5bFyMXh5DAUUaJAw+3MEEkTCVm7+1kBLF5BQQlTs58wgJiMwtYSEy9sp8RwpaXaN46
        mxnEZhFQlZh9oxGsl01AU2L+pYNg9SIC6hKdz98wgixgFrjMKPFu4WqwBmEBe4nO9/vBbH4B
        YYlPdy+ydjFycHACLdjxOxIkLCRgLvF+00pWiBtcJJ7e7WGFuE1F4sPvB+wg5aJA9ua5ShMY
        BWchuXQWkktnIbl0ASPzKkaBxDJjvczkYr20/KKSDL30ok2M4Fhg9N3BeHvzW71DjEwcjIcY
        JTiYlUR4p+69lijEm5JYWZValB9fVJqTWnyIUZqDRUmcl1dvQryQQHpiSWp2ampBahFMlomD
        U6qBae99g7p1KWatCf+sQjh2H7+i/eYBl92ODdOOnG74Lr/487rZFamqpy7ubOCadPOIwqIf
        U5OTg4yfirT+YXq9+jFvpqFF/cRv1+32T2Dfm3JAmbHuyn6Bu9wmNsqHBWe2h7O1XBWJWVGx
        76QJ87KNihfyj0w0zTwZx79jl2m2vbex4M+ZFmw8sx7+rfQ6sOJz+mffb9O8PHP53XefDp9o
        tmx5kVKPRMO/KoYL0yp+Rd0/9b4zx3vPbI7v/w5mLnyXZxOySONs6Mrym7u2adqE8X+8y2r2
        LZQl8tzjS+XrtptKLBc1mCh0++e3FXO+xgctyZB/nXTKYb33HpdJLG1Rt2Yy+B9qY+Qsdnl/
        ZLoIU4gSS3FGoqEWc1FxIgDELZZR9AIAAA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Palmer,

Any updates on those 3 patches ?

Regards,
Nick

Στις 2021-11-26 20:04, Nick Kossifidis έγραψε:
> On kdump instead of using an intermediate step to relocate the kernel,
> that lives in a "control buffer" outside the current kernel's mapping,
> we jump to the crash kernel directly by calling 
> riscv_kexec_norelocate().
> The current implementation uses va_pa_offset while switching to 
> physical
> addressing, however since we moved the kernel outside the linear 
> mapping
> this won't work anymore since riscv_kexec_norelocate() is part of the
> kernel mapping and we should use kernel_map.va_kernel_pa_offset, and 
> also
> take XIP kernel into account.
> 
> We don't really need to use va_pa_offset on riscv_kexec_norelocate, we
> can just set STVEC to the physical address of the new kernel instead 
> and
> let the hart jump to the new kernel on the next instruction after 
> setting
> SATP to zero. This fixes kdump and is also simpler/cleaner.
> 
> I tested this on the latest qemu and HiFive Unmatched and works as
> expected.
> 
> v2: I removed the direct jump after setting satp as suggested.
> 
> Fixes: 2bfc6cd81bd1 ("riscv: Move kernel mapping outside of linear 
> mapping")
> 
> Signed-off-by: Nick Kossifidis <mick@ics.forth.gr>
> Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
> Cc: <stable@vger.kernel.org> # 5.13
> Cc: <stable@vger.kernel.org> # 5.14


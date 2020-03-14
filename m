Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44B5185A0A
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 05:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgCOEUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 00:20:50 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:28898 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgCOEUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 00:20:50 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 48fYyz3cWFz9txPk;
        Sat, 14 Mar 2020 08:26:35 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=wOCV1qop; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id ja4ZH3fYw32p; Sat, 14 Mar 2020 08:26:35 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 48fYyz2N73z9txPj;
        Sat, 14 Mar 2020 08:26:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1584170795; bh=GCMtTnndF9n61PXcYeOSu2bKjOaCnpQzS0ox12E/r/s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=wOCV1qopX53qf7SOj4LCfFwkp5YuYtI2n7HuwNC8/rCUYAX1dqXIxKP+7LaXftY/K
         66Aa4civy8g9ewjxdt/6y8Hzf1w5Nuk6aBIWaSehN3JmY7AwDQLsV6U/ZsHTUmyvHz
         8eMcwi/v74+2eHKlIRJb27L9pLrTCRS9KlpN13FM=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2F5698B772;
        Sat, 14 Mar 2020 08:26:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 1giGPQDHWGID; Sat, 14 Mar 2020 08:26:36 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8D4FC8B768;
        Sat, 14 Mar 2020 08:26:34 +0100 (CET)
Subject: Re: [PATCH v3] powerpc/fsl-85xx: fix compile error
To:     WANG Wenhu <wenhu.wang@vivo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Allison Randal <allison@lohutok.net>,
        Richard Fontana <rfontana@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, trivial@kernel.org,
        stable <stable@vger.kernel.org>
References: <20200314051035.64552-1-wenhu.wang@vivo.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <bd9799ae-d306-a478-25ff-ec3c7f083cfe@c-s.fr>
Date:   Sat, 14 Mar 2020 08:26:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200314051035.64552-1-wenhu.wang@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 14/03/2020 à 06:10, WANG Wenhu a écrit :
> Include "linux/of_address.h" to fix the compile error for
> mpc85xx_l2ctlr_of_probe() when compiling fsl_85xx_cache_sram.c.
> 
>    CC      arch/powerpc/sysdev/fsl_85xx_l2ctlr.o
> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c: In function ‘mpc85xx_l2ctlr_of_probe’:
> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c:90:11: error: implicit declaration of function ‘of_iomap’; did you mean ‘pci_iomap’? [-Werror=implicit-function-declaration]
>    l2ctlr = of_iomap(dev->dev.of_node, 0);
>             ^~~~~~~~
>             pci_iomap
> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c:90:9: error: assignment makes pointer from integer without a cast [-Werror=int-conversion]
>    l2ctlr = of_iomap(dev->dev.of_node, 0);
>           ^
> cc1: all warnings being treated as errors
> scripts/Makefile.build:267: recipe for target 'arch/powerpc/sysdev/fsl_85xx_l2ctlr.o' failed
> make[2]: *** [arch/powerpc/sysdev/fsl_85xx_l2ctlr.o] Error 1
> 
> Fixes: commit 6db92cc9d07d ("powerpc/85xx: add cache-sram support")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: WANG Wenhu <wenhu.wang@vivo.com>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>


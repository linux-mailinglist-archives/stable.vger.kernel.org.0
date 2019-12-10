Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B3D1182B3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 09:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLJIr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 03:47:59 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:36433 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfLJIr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 03:47:59 -0500
Received: from localhost (mailhub1-ext [192.168.12.233])
        by localhost (Postfix) with ESMTP id 47XDGj1VPZz9tyW7;
        Tue, 10 Dec 2019 09:47:57 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=C3bR0m/s; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Fd8oBSUCPelI; Tue, 10 Dec 2019 09:47:57 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 47XDGj0Pbxz9tyW5;
        Tue, 10 Dec 2019 09:47:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1575967677; bh=zENznlhMrznRJGWMWUM1fyRyx1+XPUaBYHrlB+Jwl+w=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=C3bR0m/sd7ui2ylcf/4sLqze9kSUVlsC2nH2GGy/7SAQFUiOrwszHGjmiCVMWRuNS
         0g10ccnkDpQFCCACb5AWLTX+LeG0BrGxFkEeZxDfHb3z6cIDTkzX5m2n3LOxmiqQzF
         r4AECHp94sRL+vM2fY+m2h96iFux0v/dJA7GHmMc=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1060E8B805;
        Tue, 10 Dec 2019 09:47:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id jVkK5NT9l2oC; Tue, 10 Dec 2019 09:47:58 +0100 (CET)
Received: from po16098vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 425408B754;
        Tue, 10 Dec 2019 09:47:57 +0100 (CET)
Subject: Re: [PATCH] sh: kgdb: Mark expected switch fall-throughs
To:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Paul Burton <paul.burton@mips.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <87o8wgy3ra.wl-kuninori.morimoto.gx@renesas.com>
 <87muc0y3q4.wl-kuninori.morimoto.gx@renesas.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <1009e85d-882a-d43b-8936-a0b4de596aa3@c-s.fr>
Date:   Tue, 10 Dec 2019 08:47:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <87muc0y3q4.wl-kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/10/2019 08:39 AM, Kuninori Morimoto wrote:
> 
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following error:
> 
> LINUX/arch/sh/kernel/kgdb.c: In function 'kgdb_arch_handle_exception':
> LINUX/arch/sh/kernel/kgdb.c:267:6: error: this statement may fall through [-Werror=implicit-fallthrough=]
> if (kgdb_hex2long(&ptr, &addr))
> ^
> LINUX/arch/sh/kernel/kgdb.c:269:2: note: here
> case 'D':
> ^~~~
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Acked-by: Daniel Thompson <daniel.thompson@linaro.org>

I guess you should also add:

Fixes: ab6e570ba33d ("sh: Generic kgdb stub support.")
Cc: stable@vger.kernel.org

Christophe

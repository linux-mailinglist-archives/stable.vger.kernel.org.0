Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03181F483
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfEOMfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:35:42 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:9697 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbfEOMfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 08:35:42 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 453vCw0wY9z9v07b;
        Wed, 15 May 2019 14:35:40 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=rsqC9yrY; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id RtIn3Axkd-Ld; Wed, 15 May 2019 14:35:40 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 453vCv6fg6z9v07Y;
        Wed, 15 May 2019 14:35:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1557923739; bh=/GdjFATaS1UOIQzQ8sKieXWhI3vCPWGoYpxxEpdcrnU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rsqC9yrYPBMpJ5pM8DIy1XAhTeOQnA9pRBs8Cz6bscwAoIWyo5+QCGacntC3SJPBc
         D17NDN/jTH7NuGGQEsgUqto4i6UhlU7EpFmqpB5zK9DFYCT3dJKaMlB3CjEHeg3U+Q
         yA/ke3rxoVkHXrEps/nrhMEDngrDN5aPDo1GEd50=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 415D78B905;
        Wed, 15 May 2019 14:35:40 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Mavw7iuCReRH; Wed, 15 May 2019 14:35:40 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1B9A38B904;
        Wed, 15 May 2019 14:35:40 +0200 (CEST)
Subject: Re: [PATCH stable 4.9] powerpc/lib: fix book3s/32 boot failure due to
 code patching
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, erhard_f@mailbox.org,
        Michael Neuling <mikey@neuling.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <629c2acb1fcd09c2d2e3352370c3d9853372cf39.1557902321.git.christophe.leroy@c-s.fr>
 <20190515082931.GA28349@kroah.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <9e58348f-da2d-34bc-d016-7817b3566e01@c-s.fr>
Date:   Wed, 15 May 2019 14:35:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515082931.GA28349@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 15/05/2019 à 10:29, Greg KH a écrit :
> On Wed, May 15, 2019 at 06:40:47AM +0000, Christophe Leroy wrote:
>> [Backport of upstream commit b45ba4a51cde29b2939365ef0c07ad34c8321789]
>>
>> On powerpc32, patch_instruction() is called by apply_feature_fixups()
>> which is called from early_init()
>>
>> There is the following note in front of early_init():
>>   * Note that the kernel may be running at an address which is different
>>   * from the address that it was linked at, so we must use RELOC/PTRRELOC
>>   * to access static data (including strings).  -- paulus
>>
>> Therefore init_mem_is_free must be accessed with PTRRELOC()
>>
>> Fixes: 1c38a84d4586 ("powerpc: Avoid code patching freed init sections")
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=203597
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> ---
>> Can't apply the upstream commit as such due to several other unrelated stuff
>> like for instance STRICT_KERNEL_RWX which are missing.
>> So instead, using same approach as for commit 252eb55816a6f69ef9464cad303cdb3326cdc61d
> 
> Now queued up, thanks.
> 

Should go to 4.4 as well since the commit it fixes is now queued for 4.4 
([PATCH 4.4 056/266] powerpc: Avoid code patching freed init sections)

Christophe

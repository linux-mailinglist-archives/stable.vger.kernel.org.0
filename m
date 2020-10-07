Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1B285849
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 07:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgJGF4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 01:56:41 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45635 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJGF4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 01:56:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C5k9g2W4hz9sSG;
        Wed,  7 Oct 2020 16:56:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1602050199;
        bh=4fuWDigsRGvfFAX9Wylr16jfrxZcWj+lq7FzJQnfwg4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RMxxfWIg+VF+ujDcY7ZZ4nlauNl2+IAv96MVMG0hiS/Xic9usad1fW8leS6aFJKyH
         O+cE/zOhlHD/m3M3hhZflxDJl+gUeSHuDVYvJdYG/vltCIKM7EvmvfywWHJgPFx4Oq
         atGXEQr9bNouNruMirp1GpRARtJmAqzH5R8dLqNX9oeFQohnVGdY4SCTYt3Lp8BYkI
         tLBEZ2N92wqIqoqpvaMCUzvPQrkYk1CqP2ry7gxcJAoUfdGM4H9dLGogRi4aX4kYS6
         GqL9rFuLm8Yumw8YWRpI+uOWSw4qel1254/6zdbb7AsDxO1YB+S8kD4yCo9XcV5Knb
         ZPZHejNtEhfGA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nathan Lynch <nathanl@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 3/4] powerpc/memhotplug: Make lmb size 64bit
In-Reply-To: <87pn7lxe5k.fsf@linux.ibm.com>
References: <20200806162329.276534-1-aneesh.kumar@linux.ibm.com> <20200806162329.276534-3-aneesh.kumar@linux.ibm.com> <87pn7lxe5k.fsf@linux.ibm.com>
Date:   Wed, 07 Oct 2020 16:56:36 +1100
Message-ID: <878sci37fv.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nathan Lynch <nathanl@linux.ibm.com> writes:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
>> @@ -322,12 +322,16 @@ static int pseries_remove_mem_node(struct device_node *np)
>>  	/*
>>  	 * Find the base address and size of the memblock
>>  	 */
>> -	regs = of_get_property(np, "reg", NULL);
>> -	if (!regs)
>> +	prop = of_get_property(np, "reg", NULL);
>> +	if (!prop)
>>  		return ret;
>>  
>> -	base = be64_to_cpu(*(unsigned long *)regs);
>> -	lmb_size = be32_to_cpu(regs[3]);
>> +	/*
>> +	 * "reg" property represents (addr,size) tuple.
>> +	 */
>> +	base = of_read_number(prop, mem_addr_cells);
>> +	prop += mem_addr_cells;
>> +	lmb_size = of_read_number(prop, mem_size_cells);
>
> Would of_n_size_cells() and of_n_addr_cells() work here?

Yes that should work and be cleaner.

cheers

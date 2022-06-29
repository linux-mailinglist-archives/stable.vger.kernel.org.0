Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7569155F88E
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 09:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiF2HP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 03:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiF2HP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 03:15:58 -0400
X-Greylist: delayed 2254 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 00:15:55 PDT
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCE63389B;
        Wed, 29 Jun 2022 00:15:55 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.15.2) with ESMTPSA id 25T6bQnJ3125838
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 28 Jun 2022 23:37:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 25T6bQnJ3125838
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022060401; t=1656484647;
        bh=z6mnH6TdWUDj3//ciTNKC5AKsEU+SOHI433TUMWqSYk=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=l4b+tNBCwd1QAFCmOJWsV9QxYtF/OlXjWeKNMQ2sM5Ekg+U6n062J9pGQFmc8B9JY
         qDE5YbKayKgkI35ohswHR9v3+nGfPUzBlvldIyKxVAZTrYTd8jIYMJLWZcq2Ym5SXj
         eZn1udfy4H4SbzMMtrFtXPDLJkVMAbRnACTkNoq+z9vaOdEm7wmUdxGGMTP9La+FIs
         wOmB9Cz/WFjeZLP4DBw6UyxuAlSuXXpWI7JGiryAiPNAydkEFYD/M9GJh6O22UyNPR
         i2UHcPGHtOBEvP8HheX0jkwbs7bO5tNfhE03kqPLUeCMRN8ZLtX0+t5f5ral+ss6ap
         /ItcnuOsZ4pMA==
Date:   Tue, 28 Jun 2022 23:37:24 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Ajay Kaher <akaher@vmware.com>
CC:     bhelgaas@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, rostedt@goodmis.org, namit@vmware.com,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        anishs@vmware.com, vsirnapalli@vmware.com, er.ajay.kaher@gmail.com
Subject: Re: [PATCH] MMIO should have more priority then IO
User-Agent: K-9 Mail for Android
In-Reply-To: <YrvtWVqj/w8V5nIJ@kroah.com>
References: <1656433761-9163-1-git-send-email-akaher@vmware.com> <YrvtWVqj/w8V5nIJ@kroah.com>
Message-ID: <3FF33790-A114-4A02-9887-6FB51ABF28EF@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On June 28, 2022 11:12:41 PM PDT, Greg KH <gregkh@linuxfoundation=2Eorg> wr=
ote:
>On Tue, Jun 28, 2022 at 09:59:21PM +0530, Ajay Kaher wrote:
>> Port IO instructions (PIO) are less efficient than MMIO (memory
>> mapped I/O)=2E They require twice as many PCI accesses and PIO
>> instructions are serializing=2E As a result, MMIO should be preferred
>> when possible over PIO=2E
>>=20
>> Bare metal test result
>> 1 million reads using raw_pci_read() took:
>> PIO: 0=2E433153 Sec=2E
>> MMIO: 0=2E268792 Sec=2E
>>=20
>> Virtual Machine test result
>> 1 hundred thousand reads using raw_pci_read() took:
>> PIO: 12=2E809 Sec=2E
>> MMIO: took 8=2E517 Sec=2E
>>=20
>> Signed-off-by: Ajay Kaher <akaher@vmware=2Ecom>
>> ---
>>  arch/x86/pci/common=2Ec          |  8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/pci/common=2Ec b/arch/x86/pci/common=2Ec
>> index 3507f456f=2E=2E0b3383d9c 100644
>> --- a/arch/x86/pci/common=2Ec
>> +++ b/arch/x86/pci/common=2Ec
>> @@ -40,20 +40,20 @@ const struct pci_raw_ops *__read_mostly raw_pci_ext=
_ops;
>>  int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int d=
evfn,
>>  						int reg, int len, u32 *val)
>>  {
>> +	if (raw_pci_ext_ops)
>> +		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
>>  	if (domain =3D=3D 0 && reg < 256 && raw_pci_ops)
>>  		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
>> -	if (raw_pci_ext_ops)
>> -		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
>>  	return -EINVAL;
>>  }
>> =20
>>  int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int =
devfn,
>>  						int reg, int len, u32 val)
>>  {
>> +	if (raw_pci_ext_ops)
>> +		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
>>  	if (domain =3D=3D 0 && reg < 256 && raw_pci_ops)
>>  		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
>> -	if (raw_pci_ext_ops)
>> -		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
>>  	return -EINVAL;
>>  }
>> =20
>> --=20
>> 2=2E30=2E0
>>=20
>
><formletter>
>
>This is not the correct way to submit patches for inclusion in the
>stable kernel tree=2E  Please read:
>    https://www=2Ekernel=2Eorg/doc/html/latest/process/stable-kernel-rule=
s=2Ehtml
>for how to do this properly=2E
>
></formletter>

The statement in the header is also incorrect=2E

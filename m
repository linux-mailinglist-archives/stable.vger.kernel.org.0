Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA7721CBCA
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 00:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgGLWWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 18:22:12 -0400
Received: from terminus.zytor.com ([198.137.202.136]:53929 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgGLWWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jul 2020 18:22:12 -0400
Received: from [IPv6:2601:646:8600:3281:dcc1:f8b3:2766:5f92] ([IPv6:2601:646:8600:3281:dcc1:f8b3:2766:5f92])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 06CMLw9F1257107
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Sun, 12 Jul 2020 15:22:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 06CMLw9F1257107
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020062301; t=1594592521;
        bh=WWKmCXEzzN81kjVxRxEwWLBIb6cLUKLjvr1yWSka0hk=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=bcwnj1420wmcaI8tKWrcHgo343qrpzxx3bRpqON9zxrrk6ndmy9hI49v+fMt7t1G5
         fwlXdbUlUP7ee8HpiFnlSrL/8KIir2AMF7gK3w9RkojES6ZYmkLKMqjhLwFnjE0mDR
         Hqaf4qry1Ycm5KZkh6pBqCUabSmGEsCxrH3RUNmwn7O6lYG+1XXiFyyvLqGdtbknLN
         GudePfkmj2y0j7CsxReL+PdIhSItoR8WaxAQL0BOndfFpJiubVnB0I7U1meObJ26e/
         dfUCRBn6SVs7EeNpaoEfTdGM5AIDg34IXKs1g3D2Abt0o1lnIo433pVL7bthJ+QgR5
         hJaBXbIoTmbxA==
Date:   Sun, 12 Jul 2020 15:21:49 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <9af191c2-0f2c-7637-433a-b557a07590ca@redhat.com>
References: <20200712125952.8809-1-trix@redhat.com> <639c8ef5-2755-7172-fbb8-ce45c8637feb@zytor.com> <9af191c2-0f2c-7637-433a-b557a07590ca@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] decompress_bunzip2: fix sizeof type in start_bunzip
To:     Tom Rix <trix@redhat.com>, alain@knaff.lu
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
From:   hpa@zytor.com
Message-ID: <EE11D4F0-8DA4-4030-800E-516423293987@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On July 12, 2020 8:12:43 AM PDT, Tom Rix <trix@redhat=2Ecom> wrote:
>
>On 7/12/20 6:09 AM, H=2E Peter Anvin wrote:
>> On 2020-07-12 05:59, trix@redhat=2Ecom wrote:
>>> From: Tom Rix <trix@redhat=2Ecom>
>>>
>>> clang static analysis flags this error
>>>
>>> lib/decompress_bunzip2=2Ec:671:13: warning: Result of 'malloc' is
>converted
>>>   to a pointer of type 'unsigned int', which is incompatible with
>sizeof
>>>   operand type 'int' [unix=2EMallocSizeof]
>>>         bd->dbuf =3D large_malloc(bd->dbufSize * sizeof(int));
>>>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>
>>> Reviewing the bunzip_data structure, the element dbuf is type
>>>
>>> 	/* Intermediate buffer and its size (in bytes) */
>>> 	unsigned int *dbuf, dbufSize;
>>>
>>> So change the type in sizeof to 'unsigned int'
>>>
>> You must be kidding=2E
>>
>> If you want to change it, change it to sizeof(bd->dbuf) instead, but
>this flag
>> is at least in my opinion a total joke=2E For sizeof(int) !=3D
>sizeof(unsigned
>> int) is beyond bizarre, no matter how stupid the platform=2E
>
>Using the actual type is more correct that using a type of the same
>size=2E
>
>trix
>
>> 	-hpa
>>

"More correct?" All it is is more verbose=2E

Using the sizeof of the actual object at least adds some actual safety=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

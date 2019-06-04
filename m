Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B353463A
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfFDMH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:07:29 -0400
Received: from mail.kmu-office.ch ([178.209.48.109]:46836 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfFDMH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:07:29 -0400
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 397E25C0F7C;
        Tue,  4 Jun 2019 14:07:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1559650045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xFkaEp6wH0G/XcBCBcIPdvCJ6RTaX9d+EfEmhcMs+hI=;
        b=Ak+z5ENDvCWfZTME14bJKDuRVF5JjHZT5XVoDbQ0kMxBD6vp3KZah7GY9Sf/0vW6bRPfgp
        DYcbaA03vKCKVn68OtYbEeuOFNEvrVkOXcf4XJ5cJyFvYYWP30WEChbS0nYmdSqt8y8fys
        jKVQLAKrI2ueF7wkynKzaAEsL8hCLpw=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date:   Tue, 04 Jun 2019 14:07:24 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Martin Sebor <msebor@gcc.gnu.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH BACKPORT 4.14 1/2] Compiler Attributes: add support for
 __copy (gcc >= 9)
In-Reply-To: <20190604114811.GC13480@kroah.com>
References: <20190604092200.29545-1-stefan@agner.ch>
 <20190604114811.GC13480@kroah.com>
Message-ID: <79ed4254c21a3ee7192cdfae7010bf34@agner.ch>
X-Sender: stefan@agner.ch
User-Agent: Roundcube Webmail/1.3.7
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.06.2019 13:48, Greg KH wrote:
> On Tue, Jun 04, 2019 at 11:21:59AM +0200, Stefan Agner wrote:
>> From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
>>
>> [ Upstream commit c0d9782f5b6d7157635ae2fd782a4b27d55a6013
>>
>> >From the GCC manual:
>>
>>   copy
>>   copy(function)
>>
>>     The copy attribute applies the set of attributes with which function
>>     has been declared to the declaration of the function to which
>>     the attribute is applied. The attribute is designed for libraries
>>     that define aliases or function resolvers that are expected
>>     to specify the same set of attributes as their targets. The copy
>>     attribute can be used with functions, variables, or types. However,
>>     the kind of symbol to which the attribute is applied (either
>>     function or variable) must match the kind of symbol to which
>>     the argument refers. The copy attribute copies only syntactic and
>>     semantic attributes but not attributes that affect a symbol’s
>>     linkage or visibility such as alias, visibility, or weak.
>>     The deprecated attribute is also not copied.
>>
>>   https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
>>
>> The upcoming GCC 9 release extends the -Wmissing-attributes warnings
>> (enabled by -Wall) to C and aliases: it warns when particular function
>> attributes are missing in the aliases but not in their target, e.g.:
>>
>>     void __cold f(void) {}
>>     void __alias("f") g(void);
>>
>> diagnoses:
>>
>>     warning: 'g' specifies less restrictive attribute than
>>     its target 'f': 'cold' [-Wmissing-attributes]
>>
>> Using __copy(f) we can copy the __cold attribute from f to g:
>>
>>     void __cold f(void) {}
>>     void __copy(f) __alias("f") g(void);
>>
>> This attribute is most useful to deal with situations where an alias
>> is declared but we don't know the exact attributes the target has.
>>
>> For instance, in the kernel, the widely used module_init/exit macros
>> define the init/cleanup_module aliases, but those cannot be marked
>> always as __init/__exit since some modules do not have their
>> functions marked as such.
>>
>> Cc: <stable@vger.kernel.org> # 4.14+
>> Suggested-by: Martin Sebor <msebor@gcc.gnu.org>
>> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  include/linux/compiler-gcc.h   | 4 ++++
>>  include/linux/compiler_types.h | 4 ++++
>>  2 files changed, 8 insertions(+)
> 
> Can I get a series of these for 4.19.y as well?  I don't want to apply
> anything to 4.14 that will regress moving to 4.19.

Make sense, will create a backport for 4.19 too.

--
Stefan

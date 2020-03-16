Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4589E186D1C
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 15:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731585AbgCPOcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 10:32:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27219 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731507AbgCPOcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 10:32:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584369170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f19dtzsCWbsI/VVyuiBNzSKMxNoJY55ztr0fEoSY2Yo=;
        b=NH7uxMzJJa/z1Hj8oBO9wqiQQiL8YjAd45ZWaBGuWyhKnioMYFOy6r4K6pvqG24l+6Djbr
        RH8l2wxLPqqavDCkoafjo0gmAHgiAUFhbnei96M5HbIWYv2JRXe6px78ilkOQsnJWL/8vQ
        wc0KApRlRpYCX0vtA+qG3PYv1nrZ93g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-dlGr0lj9OQq0QnZ0FPV9VA-1; Mon, 16 Mar 2020 10:32:45 -0400
X-MC-Unique: dlGr0lj9OQq0QnZ0FPV9VA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 949BF1937FFB;
        Mon, 16 Mar 2020 14:32:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A2269B909;
        Mon, 16 Mar 2020 14:32:44 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6255B86FFF;
        Mon, 16 Mar 2020 14:32:44 +0000 (UTC)
Date:   Mon, 16 Mar 2020 10:32:43 -0400 (EDT)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Message-ID: <1979457481.16406883.1584369163986.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200316132718.GA3960435@kroah.com>
References: <20200316131938.31453-1-vdronov@redhat.com> <20200316131938.31453-2-vdronov@redhat.com> <20200316132718.GA3960435@kroah.com>
Subject: Re: [PATCH 4.19, 4.14, 4.9, 4.4 1/2] efi: Fix a race and a buffer
 overflow while reading efivars via sysfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.7, 10.4.195.7]
Thread-Topic: Fix a race and a buffer overflow while reading efivars via sysfs
Thread-Index: SSqfnMpiL5gK9VQ1e/4o2NJsLzE0xw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

----- Original Message -----
> From: "Greg KH" <greg@kroah.com>
> To: "Vladis Dronov" <vdronov@redhat.com>
> Cc: stable@vger.kernel.org, "Sasha Levin" <sashal@kernel.org>
> Sent: Monday, March 16, 2020 2:27:18 PM
> Subject: Re: [PATCH 4.19, 4.14, 4.9, 4.4 1/2] efi: Fix a race and a buffer overflow while reading efivars via sysfs
> 
> On Mon, Mar 16, 2020 at 02:19:37PM +0100, Vladis Dronov wrote:
> > commit 286d3250c9d6437340203fb64938bea344729a0e upstream.
> > 
> > There is a race and a buffer overflow corrupting a kernel memory while
> > reading an EFI variable with a size more than 1024 bytes via the older
> > sysfs method. This happens because accessing struct efi_variable in
> > efivar_{attr,size,data}_read() and friends is not protected from
> > a concurrent access leading to a kernel memory corruption and, at best,
> > to a crash. The race scenario is the following:
> > 
> > CPU0:                                CPU1:
> > efivar_attr_read()
> >   var->DataSize = 1024;
> >   efivar_entry_get(... &var->DataSize)
> >     down_interruptible(&efivars_lock)
> >                                      efivar_attr_read() // same EFI var
> >                                        var->DataSize = 1024;
> >                                        efivar_entry_get(... &var->DataSize)
> >                                          down_interruptible(&efivars_lock)
> >     virt_efi_get_variable()
> >     // returns EFI_BUFFER_TOO_SMALL but
> >     // var->DataSize is set to a real
> >     // var size more than 1024 bytes
> >     up(&efivars_lock)
> >                                          virt_efi_get_variable()
> >                                          // called with var->DataSize set
> >                                          // to a real var size, returns
> >                                          // successfully and overwrites
> >                                          // a 1024-bytes kernel buffer
> >                                          up(&efivars_lock)
> > 
> > This can be reproduced by concurrent reading of an EFI variable which size
> > is more than 1024 bytes:
> > 
> >   ts# for cpu in $(seq 0 $(nproc --ignore=1)); do ( taskset -c $cpu \
> >   cat /sys/firmware/efi/vars/KEKDefault*/size & ) ; done
> > 
> > Fix this by using a local variable for a var's data buffer size so it
> > does not get overwritten.
> > 
> > Fixes: e14ab23dde12b80d ("efivars: efivar_entry API")
> > Reported-by: Bob Sanders <bob.sanders@hpe.com> and the LTP testsuite
> > Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > Link: https://lore.kernel.org/r/20200305084041.24053-2-vdronov@redhat.com
> > Link: https://lore.kernel.org/r/20200308080859.21568-24-ardb@kernel.org
> > ---
> >  drivers/firmware/efi/efivars.c | 29 ++++++++++++++++++++---------
> >  1 file changed, 20 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/firmware/efi/efivars.c
> > b/drivers/firmware/efi/efivars.c
> > index 3e626fd9bd4e..c8688490f148 100644
> > --- a/drivers/firmware/efi/efivars.c
> > +++ b/drivers/firmware/efi/efivars.c
> > @@ -139,13 +139,16 @@ static ssize_t
> >  efivar_attr_read(struct efivar_entry *entry, char *buf)
> >  {
> >  	struct efi_variable *var = &entry->var;
> > +	unsigned long size = sizeof(var->Data);
> >  	char *str = buf;
> > +	int ret;
> >  
> >  	if (!entry || !buf)
> >  		return -EINVAL;
> >  
> > -	var->DataSize = 1024;
> > -	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
> > +	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
> > +	var->DataSize = size;
> > +	if (ret)
> >  		return -EIO;
> >  
> >  	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
> > @@ -172,13 +175,16 @@ static ssize_t
> >  efivar_size_read(struct efivar_entry *entry, char *buf)
> >  {
> >  	struct efi_variable *var = &entry->var;
> > +	unsigned long size = sizeof(var->Data);
> >  	char *str = buf;
> > +	int ret;
> >  
> >  	if (!entry || !buf)
> >  		return -EINVAL;
> >  
> > -	var->DataSize = 1024;
> > -	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
> > +	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
> > +	var->DataSize = size;
> > +	if (ret)
> >  		return -EIO;
> >  
> >  	str += sprintf(str, "0x%lx\n", var->DataSize);
> > @@ -189,12 +195,15 @@ static ssize_t
> >  efivar_data_read(struct efivar_entry *entry, char *buf)
> >  {
> >  	struct efi_variable *var = &entry->var;
> > +	unsigned long size = sizeof(var->Data);
> > +	int ret;
> >  
> >  	if (!entry || !buf)
> >  		return -EINVAL;
> >  
> > -	var->DataSize = 1024;
> > -	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
> > +	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
> > +	var->DataSize = size;
> > +	if (ret)
> >  		return -EIO;
> >  
> >  	memcpy(buf, var->Data, var->DataSize);
> > @@ -314,14 +323,16 @@ efivar_show_raw(struct efivar_entry *entry, char
> > *buf)
> >  {
> >  	struct efi_variable *var = &entry->var;
> >  	struct compat_efi_variable *compat;
> > +	unsigned long datasize = sizeof(var->Data);
> >  	size_t size;
> > +	int ret;
> >  
> >  	if (!entry || !buf)
> >  		return 0;
> >  
> > -	var->DataSize = 1024;
> > -	if (efivar_entry_get(entry, &entry->var.Attributes,
> > -			     &entry->var.DataSize, entry->var.Data))
> > +	ret = efivar_entry_get(entry, &var->Attributes, &datasize, var->Data);
> > +	var->DataSize = datasize;
> > +	if (ret)
> >  		return -EIO;
> >  
> >  	if (is_compat()) {
> > --
> > 2.20.1
> > 
> 
> This is already in all of my stable trees, did it need to be somehow
> backported differently to 4.19 and older?

It looks like I've misunderstood "... failed to apply to 4.XX-stable tree" messages.
This exact patch does not need any special backporting (if it applies fine to the
tree). Apologies for the spam and traffic.

> thanks,
> 
> greg k-h

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer


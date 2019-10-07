Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EC0CE97E
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbfJGQmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:42:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33160 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbfJGQmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 12:42:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id i76so1388180pgc.0
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 09:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=R2WHQtJqGRl4HgeUQJ9vrBrcd81YMTBcHdUDFA73yYs=;
        b=JPVrvobrje0AjlZY6Rh9lv+7HW34mkeY5DSddnd8rkGk//QYiyzHhqRRh1q/g960u3
         lgvhVvbcwpvGTK5p2YkPACd1q/YsUY5S1bDlUdbf4MUT8nMKp0hWf5VFS36K3a161PgZ
         +FZJ/VGN8y4PriznPJeLDmJfcIXFHkdqC03WQJKSqjgShkkkwj7vp4k3GZD/cyXn+vYJ
         dIb+1UFMu6vwfJ3W7sphtrQVlnO7da29Dvabv7ntqBnaA7/Xl4Mc6+e/LKmqj5ObzgPG
         1Pjl/NgAdpLcxo+LEXLfDqnraNhi3ujGqPFTsftYMAHI7C5kiK2yH3a9+iXQIOFeJqUX
         PMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=R2WHQtJqGRl4HgeUQJ9vrBrcd81YMTBcHdUDFA73yYs=;
        b=t8ukQZcfW1n22OXUpm6p6ZAqXGuBKK/nama130kN6boF5n1NWKlbUv8MAdh4MHeqHr
         z8BQLMmEMMPYxh30vt2rhP4zhlaDQehxoQDmjpHUljfFN93YBtMdwWlpQnjfGiourPZa
         rUs0kT4C4EzIALEt8Ah4A9lWfLaEyEzJ2joqeNGJVAKx82E3mUt4MDPVpYRU8cM1+0zn
         fcrImFLhBWTTrEtuNrUaSZT0WS6dO/EjRXpx9Zqjpu3FkboQgcTUbKQBjCgCqJ2vLUwM
         I8xPvTH5BjPIM+fGOdiZN9xd9Hukxd72H+u+HN6d+B8uVoesk1FHGJjvqHdY6eaxUDsp
         R0TQ==
X-Gm-Message-State: APjAAAU1t02fyBTb2xKhIfG7dQoczUruXQV8idUJIrilbcbUz+k/BHer
        Rp/uvwVOmLqQ39QJ4TSneKfgug==
X-Google-Smtp-Source: APXvYqwL6V2Ybiv+pdiJRod9MlteV9QRaevrA/8qfwHHR+Kj85aNX/RTjKOscGyO9jTayGZKqCXXTQ==
X-Received: by 2002:aa7:8ad8:: with SMTP id b24mr33672165pfd.218.1570466529332;
        Mon, 07 Oct 2019 09:42:09 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.googlemail.com with ESMTPSA id h26sm16222342pgh.7.2019.10.07.09.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 09:42:08 -0700 (PDT)
Subject: Re: [PATCH] ovl: filter of trusted xattr results in audit
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
References: <20191007160918.29504-1-salyzyn@android.com>
 <20191007161616.GA988623@kroah.com> <20191007161725.GB988623@kroah.com>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <7c610f92-5e1f-32ef-0a60-ed47ea999fe3@android.com>
Date:   Mon, 7 Oct 2019 09:42:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007161725.GB988623@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/7/19 9:17 AM, Greg Kroah-Hartman wrote:
> On Mon, Oct 07, 2019 at 06:16:16PM +0200, Greg Kroah-Hartman wrote:
>> On Mon, Oct 07, 2019 at 09:09:16AM -0700, Mark Salyzyn wrote:
>>> When filtering xattr list for reading, presence of trusted xattr
>>> results in a security audit log.  However, if there is other content
>>> no errno will be set, and if there isn't, the errno will be -ENODATA
>>> and not -EPERM as is usually associated with a lack of capability.
>>> The check does not block the request to list the xattrs present.
>>>
>>> Switch to has_capability_noaudit to reflect a more appropriate check.
>>>
>>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>>> Cc: linux-security-module@vger.kernel.org
>>> Cc: kernel-team@android.com
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: stable@vger.kernel.org # v3.18
>>> Fixes: upstream a082c6f680da ("ovl: filter trusted xattr for non-admin")
>>> Fixes: 3.18 4bcc9b4b3a0a ("ovl: filter trusted xattr for non-admin")
>>> ---
>>> Replaced ns_capable_noaudit with 3.18.y tree specific
>>> has_capability_noaudit present in original submission to kernel.org
>>> commit 5c2e9f346b815841f9bed6029ebcb06415caf640
>>> ("ovl: filter of trusted xattr results in audit")
>>>
>>>   fs/overlayfs/inode.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>>> index a01ec1836a72..1175efa5e956 100644
>>> --- a/fs/overlayfs/inode.c
>>> +++ b/fs/overlayfs/inode.c
>>> @@ -265,7 +265,8 @@ static bool ovl_can_list(const char *s)
>>>   		return true;
>>>   
>>>   	/* Never list trusted.overlay, list other trusted for superuser only */
>>> -	return !ovl_is_private_xattr(s) && capable(CAP_SYS_ADMIN);
>>> +	return !ovl_is_private_xattr(s) &&
>>> +	       has_capability_noaudit(current, CAP_SYS_ADMIN);
>>>   }
>>>   
>>>   ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>>> -- 
>>> 2.23.0.581.g78d2f28ef7-goog
>>>
>> Thanks for the backport, this one worked!
> I spoke too soon:
>
> ERROR: "has_capability_noaudit" [fs/overlayfs/overlay.ko] undefined!
>
> That function isn't exported for modules :(
>
> greg k-h

<sigh>

Now what is the playbook, we have three options in order of preference:

1) #ifdef MODULE use capable() to preserve API, add a short comment 
about the side effects if overlayfs is used as a module.

2) export has_capability_nodaudit (proc and oom_kill use it, and are 
both built-in only), but affect the 3.18 API at near EOL. AFAIK no one 
wants that?

3) Do nothing more. Make this a distro concern only. Leave this posted 
as a back-port for the record, but never merged, for those that are 
_interested_ and declare 3.18 stable as noisy for sepolicy and overlayfs 
under some usage patterns with few user space mitigation unless they 
explicitly take this back-port into their tree (eg: android common 
kernel) if used built-in. This way, in 3.18.y at least the module and 
built-in version behave the _same_ in stable.

Looking for feedback.

Sincerely -- Mark Salyzyn


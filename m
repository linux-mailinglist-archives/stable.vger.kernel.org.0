Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232331C9FCB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 02:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEHAp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 20:45:26 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37271 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgEHAp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 20:45:26 -0400
Received: by mail-pj1-f68.google.com with SMTP id a7so3440025pju.2
        for <stable@vger.kernel.org>; Thu, 07 May 2020 17:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T1RdoN5yYMOPyos/tTMbsBpzg7SNlCVRUTxr+QKqco8=;
        b=Z8RixYh53ywE2RnhzWUJiCiIvXNcxYlf6SNJ+dDKDFhebxLFsohOhJfA77ioWK8ZnT
         uyBIW9ugAqUzXcmy2PTI83O995dxtvJ+MDJ4GgeibOwGLIdFL21Jzll7sd/jSAmRbqGm
         rrsTJkYxhiVfqapRgRdHPgUWCvHzhjwkxBfmHqODz9SaSS/dYvszqi5PzHx1RGhqJ4CN
         FOx6eNLn7BhzXMDwW1FY8Fg/zKZDHZrFzbpsXmxbaR5JTg7PKwFxzeyzdengSprLqYw3
         dhBdcF1ZjAY3S76f+tGFpd6HyJxPEwejJoTA1jxLYV/Wph288c9/VMzvKfaTWA+rH8is
         B9gA==
X-Gm-Message-State: AGi0PubZNnnA/n517XVvniobtaD88Qn+zovr9pa4wzSCFbC1ld4tAR4M
        tUaMIZWp5fVJQifhNMtvs2w=
X-Google-Smtp-Source: APiQypKl8X92PyJIO8Hk6djHXXlpYugrMfS5kZj/XWC5UVzlnknu3W2yQvA7EoD1xx/pBWIlMgLY/A==
X-Received: by 2002:a17:902:eacb:: with SMTP id p11mr10908219pld.14.1588898725173;
        Thu, 07 May 2020 17:45:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:6507:baa2:4de7:40e9? ([2601:647:4802:9070:6507:baa2:4de7:40e9])
        by smtp.gmail.com with ESMTPSA id p1sm903648pjk.50.2020.05.07.17.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 17:45:24 -0700 (PDT)
Subject: Re: [PATCH stable 5.4+] nvme: fix possible hang when ns scanning
 fails during error recovery
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>
References: <20200506231451.23145-1-sagi@grimberg.me>
 <20200507070317.GB841650@kroah.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <0319f65d-9928-4fcf-a7f4-9e9e80beb619@grimberg.me>
Date:   Thu, 7 May 2020 17:45:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507070317.GB841650@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> When the controller is reconnecting, the host fails I/O and admin
>> commands as the host cannot reach the controller. ns scanning may
>> revalidate namespaces during that period and it is wrong to remove
>> namespaces due to these failures as we may hang (see 205da2434301).
>>
>> One command that may fail is nvme_identify_ns_descs. Since we return
>> success due to having ns descriptor list optional, we continue to
>> validate ns identifiers in nvme_revalidate_disk, obviously fail and
>> return -ENODEV to nvme_validate_ns, which will remove the namespace.
>>
>> Exactly what we don't want to happen.
>>
>> Fixes: 22802bf742c2 ("nvme: Namepace identification descriptor list is optional")
>> Tested-by: Anton Eidelman <anton@lightbitslabs.com>
>> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
>>
>> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
>> ---
>>   drivers/nvme/host/core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> What is the git commit id of this patch in Linus's tree?
> 
> And why sign-off on a patch twice with a blank line?

I'll resend greg, sorry for the inconvenience.

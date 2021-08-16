Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7AB3EDA4A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhHPP5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 11:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236242AbhHPP5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 11:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629129399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZpQLZMB7RJdGulqivRZelq1MarObE9Ch/tXNewyPHo=;
        b=Jcs7G+tp7Va5M7RXYiP26mVq6XkQH2+t0qBPdVdSR0MS1hCWR4L/xoPTdIFAhZ2R4jFF+r
        icAebz9lZsOoHKPD8qNbcYCIhzaplNHrKkpohR3W/lMHRhr+hjuFLG8FRebnpaRjMKOrnq
        nHpezwHa4Arlgu8ULFa1UTBExLZeG6I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-xuRKFTm4PzKlyC9uVe9aIA-1; Mon, 16 Aug 2021 11:56:38 -0400
X-MC-Unique: xuRKFTm4PzKlyC9uVe9aIA-1
Received: by mail-ed1-f70.google.com with SMTP id l18-20020a0564021252b02903be7bdd65ccso9140995edw.12
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 08:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PZpQLZMB7RJdGulqivRZelq1MarObE9Ch/tXNewyPHo=;
        b=A5rkGnTeJGpV+urzTCly2lTgwb0X2/tgqLJRIkhnKdfsR5r7l8P7DH9lfb7ZheZN/x
         OVgSXEiHTVSLNINwNt0TqNOeNqwPzjM8z92M+zch0rpsx6W42+JKZHnAfx47Tlh3lrKH
         X3Jvv2+d6UwaEL4YDJaz2Uy1U/es3tn/Owvz/9PdqDa/YtwWqFSxX8mu5d7gmK9mLV8b
         ZQeL/u1AEGLSJySlkdkISkwRdLio7HupCYTP8HQDIuJYw/5VR93iQ9aqcrIjxNPqJc5D
         Q5BoOPbeZXp8Y48J5qpYWa65VyoFpwzYUHJhVg6cvDvoJS98D76Bl980l4J11rAuXNTT
         IWmw==
X-Gm-Message-State: AOAM532qCn5VmTaeAm2kPbFJalMeDazQD0/z18f1ePijwHIHKUad+i50
        Nnv6uHDGPwWOG6nJEEF6S1ieL9H9ZoDgrPF1/aO9gXGnKvkTzDwouFKPk/DeRDyfBcEsNungEKO
        XdEwk9KHhqB0fwOsFI009zAQFU7JxRVSUIzwi3bgOvO/IDi+NsD9CoDUKxNo9c+qiBBEU
X-Received: by 2002:aa7:c894:: with SMTP id p20mr21016345eds.42.1629129397266;
        Mon, 16 Aug 2021 08:56:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0zVXLSgao02pT8Fnch/EOLmPpvxZgNu0lTTzYEYe6LDXa/xwx5yX+prRxBm3ZPVFWwFWf4g==
X-Received: by 2002:aa7:c894:: with SMTP id p20mr21016321eds.42.1629129397047;
        Mon, 16 Aug 2021 08:56:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id i11sm5047064edu.97.2021.08.16.08.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:56:36 -0700 (PDT)
Subject: Re: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits from
 L2 in int_ctl (CVE-2021-3653)
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210816140240.11399-6-pbonzini@redhat.com>
 <YRp1bUv85GWsFsuO@kroah.com>
 <97448bb5-1f58-07f9-1110-96c7ffefd4b2@redhat.com>
 <YRqAM3gTAscfmr60@kroah.com>
 <74cf96a9030dc0e996b1814bbf907299e377053e.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad855723-fe97-6916-8d96-013021e19fc7@redhat.com>
Date:   Mon, 16 Aug 2021 17:56:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <74cf96a9030dc0e996b1814bbf907299e377053e.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/08/21 17:37, Maxim Levitsky wrote:
> 5.13 will more likely to work with the upstream version.
> I'll check it soon.

There are a couple context differences so I've already tested it and 
sent it out.

Paolo


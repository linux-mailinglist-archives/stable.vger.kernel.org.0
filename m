Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDD398DCD
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbfHVIfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 04:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732407AbfHVIfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 04:35:18 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5522490C99
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 08:35:18 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id m26so1766519wmc.3
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 01:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=503gwfkLwN2+9M3xVVSL4KHdkFSBybLeuL3BTe28L04=;
        b=OE7LbMjzooTA5EIZ76PCyq2WEptkNbtLgu8fwJ+ozyIdq7x5xEMGLlmWwtpZRJTAGN
         zUT+tN9eWdLh9F/vPr/uO5QxGfPh08cYxirkYK+Lb94sVcxlsaSpZz++jf9SWMZMUVa6
         d4XiSWwNWUKLfm/+w3XMi8NG4oTPUUO9467yljljjb939SjLoTgpa7q/KMnnz8uYyd1l
         aEv+QBbsoKJ3twNRd31/5TXlrm641yFF4GWWQfBKqbYgYWf19znOyabYx6HbRkACml+Z
         lLqWoPObxfZd5mONQzyYizfToX2+OSr8XMvxPvX4zMcpi39p/1LHnG9Y9iVEDeoH2fRt
         nVaA==
X-Gm-Message-State: APjAAAV8nLSZ+83N2CUu7WZv2dEKNqORfG6wq8NPfUkanD2mECSsWhYz
        Kp6jVO/a0RakUk1XdCuHdaP9HgGfaNLzHtHy8TvgBnQPUFJ4VPPNqR/ooE1MtMbPyBRgJRWamYK
        ufyRApJYruiYEuyJS
X-Received: by 2002:adf:ba4a:: with SMTP id t10mr44274897wrg.325.1566462916910;
        Thu, 22 Aug 2019 01:35:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwy4qQ9wEFJUUnOh9sHeQbZqx7L5OjVN+mhbTK5RA/hJKA8heXCGy6dfXj4prjORXC40B78Sg==
X-Received: by 2002:adf:ba4a:: with SMTP id t10mr44274867wrg.325.1566462916663;
        Thu, 22 Aug 2019 01:35:16 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j17sm20375395wru.24.2019.08.22.01.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2019 01:35:15 -0700 (PDT)
Subject: Re: [PATCH v4 1/6] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
 <9acbc733-442f-0f65-9b56-ff800a3fa0f5@redhat.com>
 <CANRm+CwH54S555nw-Zik-3NFDH9yqe+SOZrGc3mPoAU_qGxP-A@mail.gmail.com>
 <e7b84893-42bf-e80e-61c9-ef5d1b200064@redhat.com>
 <CANRm+CzJf9Or_45frTe9ivFx9QDfx6Nou7uLT6tm1NmcPKDn8A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <728bf051-02eb-8fe8-042f-9893f23b4a68@redhat.com>
Date:   Thu, 22 Aug 2019 10:35:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CzJf9Or_45frTe9ivFx9QDfx6Nou7uLT6tm1NmcPKDn8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/08/19 02:46, Wanpeng Li wrote:
> On Tue, 6 Aug 2019 at 14:20, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 06/08/19 02:35, Wanpeng Li wrote:
>>> Thank you, Paolo! Btw, how about other 5 patches?
>>
>> Queued everything else too.
> 
> How about patch 4/6~5/6, they are not in kvm/queue. :)

I queued 4.

For patch 5, I don't really see the benefit since the hypercall
arguments are already traced.

Paolo

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC6B3ED973
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 17:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhHPPFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 11:05:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhHPPFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 11:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629126302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ABrWgRhABY2HK4NysZy+JCnEPDW3vpIo9/TFVUA3ibc=;
        b=NcEPebUTVUULCKGM8rGS339+rn+a0MtdC7YRKdGbaNWOYQQ+/8IRygD8QlgYxfVX6Aym1H
        68OGeo+J1zXCxckQr179VG4U1v2bv99nulVYZrvze/KXlPz3roSzu7+rZRcWpsgbmUsi8G
        dZR53KyciLuJb4PgE9ue2OFU9IXBBpg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-qLSZb1-dNCSljLL4UVw5Mg-1; Mon, 16 Aug 2021 11:05:01 -0400
X-MC-Unique: qLSZb1-dNCSljLL4UVw5Mg-1
Received: by mail-wm1-f72.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so7918159wml.5
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 08:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABrWgRhABY2HK4NysZy+JCnEPDW3vpIo9/TFVUA3ibc=;
        b=bnJo0JWh9LKVx0J86ZDLBo3viPe7oX9QmFAAgosozkuCB7CZti/wQSJvFTuUDpO9bZ
         jTnudAi0fQGY2r2RLluEcPdR5fUFraBSRSxbCXwdegsga1FXuhlXQBZk8o9Euxmid9VP
         P5Az3IRXpvHqOzE1WIs+BFm0C6kZitRUvC1nYo+3DmxjB2dSIJzfEzfr0i64t3M5ISsq
         EkM/MsfvRwsbrwSa+NHDV6HFYvGyCHV1b+3M9Qx1VCFFtzky/20T1XrWYz7avhbMLkmk
         Ngd34oIR3lsW2IHWS5cLWozfVWR+Il4hSoalhQUhLcYxFpSFpQ+P0r03U8P0QH3+mfBQ
         seHA==
X-Gm-Message-State: AOAM531t/N3dcPH2oBEpJKkqxXLV+h58QVNd0eZDk47/1sD06e2yKi9S
        8WEOETBF20vOdWrvA8WDybRIDwTC9mnoszMClDRt9RcPoEgeZJITjEwBvrUa40GUNO0GY4HZnRd
        fgX0h84XhN2ya+wKY
X-Received: by 2002:a1c:7dd0:: with SMTP id y199mr15424186wmc.23.1629126299867;
        Mon, 16 Aug 2021 08:04:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx09VPZkGLXWDG+tXpHYc3YeJl3pSZSqRdKI6EYU61EuoygC/wIwMn44PmYT5H+5icPrjj/xw==
X-Received: by 2002:a1c:7dd0:: with SMTP id y199mr15424176wmc.23.1629126299653;
        Mon, 16 Aug 2021 08:04:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id w29sm12856049wra.88.2021.08.16.08.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:04:59 -0700 (PDT)
Subject: Re: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits from
 L2 in int_ctl (CVE-2021-3653)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210816140240.11399-6-pbonzini@redhat.com>
 <YRp1bUv85GWsFsuO@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <97448bb5-1f58-07f9-1110-96c7ffefd4b2@redhat.com>
Date:   Mon, 16 Aug 2021 17:04:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRp1bUv85GWsFsuO@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/08/21 16:25, Greg KH wrote:
>> [ upstream commit 0f923e07124df069ba68d8bb12324398f4b6b709 ]
> 
> And 5.12.y is long end-of-life, take a look at the front page of
> kernel.org for the active kernels.

Ok, sorry I didn't notice that... it wasn't end of life when the issue 
was discovered. O:)

(Damn, the one time that we prepare all the backports in advance, we end 
up doing too many of them!)

Paolo


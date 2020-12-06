Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635AA2D0288
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 11:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgLFKRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 05:17:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgLFKRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 05:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607249779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nlq3Q4NGrUjO0X6nFE1J9dRrjXRFJHjkBDkZG6Th+xA=;
        b=XZY9RGu9DLfz31sW4f2oyCEuKQ9iBL8sKZxFpdl+v2S830/y+qT63l3hswheHVxPppko+h
        a4n38uMWVBuXmFZHxwfcvOPVh2cAjCD8sLUaksJlV+dOHysGSUztGoPCugcZfK0InWoAhU
        qRXwnM2SeDgtvU8XtVgwluoBcbHCuNM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-rybyYAj6OzebaUASAlxF2g-1; Sun, 06 Dec 2020 05:16:17 -0500
X-MC-Unique: rybyYAj6OzebaUASAlxF2g-1
Received: by mail-wm1-f72.google.com with SMTP id k23so4039597wmj.1
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 02:16:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nlq3Q4NGrUjO0X6nFE1J9dRrjXRFJHjkBDkZG6Th+xA=;
        b=jqfu6hXQGO2Wiq9FMDBsHH5yGNRRl910hc1ZkmIIpyihnoiBbYBbrsGjISSpm86yZE
         JKawF4Njq0VSEnYyD7gsHQOsMIaKUWW0woxZNWTuB1gx1EnBVIRy1Xbdq0xx4YVc2ygt
         D10wozDdyoXlAUijMG3TT8nW9g5ra8jld+VY0ZM7H1P3jalQADG7SKsT4+T2QuYuPGz4
         FB7crYUJRUl5m4l4Wk1B1q7sJDj2ZWebgUnUDetH5KEroGM0+WcpJGZci84N6XeAd1yf
         +NpKMxRscoDFMzKGFMXC2bR4ktleNK+6mlo5YSs/3dOSWsDPqmlUdCE+pXUU3q7jRJz0
         Ltng==
X-Gm-Message-State: AOAM532Vrdy4ZgrBzo33UJ55Oy+RNzmm2Fib7a1Cp8ER/R8lt2EXETWy
        z8tMzT5krWz0w0rMWSrKaZ1dlko4L+E7h40wUWcxOJT8KLaQHOz0DdQ8JXdr+oRvxgVvKQQmrhK
        w2wPDscqJPixCJWba
X-Received: by 2002:a5d:690a:: with SMTP id t10mr14261093wru.203.1607249776383;
        Sun, 06 Dec 2020 02:16:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDq6pF9i55QF5IGljkHwdiLBLZZsbGpe+TI+yU+M6yEDL8SU6uwGNHpnOSnRBRhfU1AwJyFg==
X-Received: by 2002:a5d:690a:: with SMTP id t10mr14261066wru.203.1607249776176;
        Sun, 06 Dec 2020 02:16:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id v4sm10615141wru.12.2020.12.06.02.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 02:16:15 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL
 cpuid bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>
References: <20201203151516.14441-1-pbonzini@redhat.com>
 <X8pt5WxwJ+yOZUAq@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b117165b-2ae5-e197-8f91-8827d1e0ceb9@redhat.com>
Date:   Sun, 6 Dec 2020 11:16:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8pt5WxwJ+yOZUAq@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/12/20 18:12, Sean Christopherson wrote:
> Assuming that's
> the case, adding helpers in cpuid.h to detect guest support for SPEC_CTRL (and
> maybe for PRED_CMD?) would be helpful.  It'd reduce duplicate code and document
> that KVM allows cross-vendor emulation.  The condition for SPEC_CTRL support is
> especially long.

That's a great idea nevertheless.

Paolo


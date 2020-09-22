Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB02C274242
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 14:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIVMnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 08:43:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726576AbgIVMnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 08:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600778599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hdDfIPkszB+oq8MEipfhVAGs4Jc9SzPikPPG+rOa0Eg=;
        b=cM1BRcr8vXkSQVlVc4y4zxLrlzb32nWbCCvqau2rwHqlcarBBftqFwE63ocY7kZGxyizAe
        ngPsSLpZpJlj/T5Ibd6h6ZNfrnUzfnNIEPz2RskAR5LVpZaESbmNfxw+JsawWz0HCtnIVJ
        KoMPipSUrR9mKS+ANnEXU85LT/cE/jU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-eP43UqKlMDGa8e00E34LZA-1; Tue, 22 Sep 2020 08:43:17 -0400
X-MC-Unique: eP43UqKlMDGa8e00E34LZA-1
Received: by mail-wm1-f69.google.com with SMTP id m25so876561wmi.0
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 05:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hdDfIPkszB+oq8MEipfhVAGs4Jc9SzPikPPG+rOa0Eg=;
        b=RkINXRINa2acNj03tq5WnXGzAe6NNUzazTyZA/oSr2zt7ijnfn+VU0HjkFTPCXf2Eg
         VHIAhE0mOvMFFInwR5WKEiHenZWpdyhXd3uxIoxj3+9fzMYLrkwjIx3+rJplNK7HTld2
         NEoRCzSUdiiCtKPzs7WFUH38+dygDdErZEiZSPH8Jom1n+9sWms1S9PhzArDiFowCeQt
         HpGvR4rVgjneck0aDkjaD+oPkM82HvYSrekmO5Sc8+DZvjhvmhKX9g9rjH5uIokLL8dp
         iF4Q33B6tamzluaS0bt+8fOsoRZewEDjBl2DSaqCQ1IrpWvIdLV+VQUvsDEftJIJ2Eav
         hJMA==
X-Gm-Message-State: AOAM530RtObdMjftYcJ+f/Ft4WdjgeERsSr69h2biS/j3C6fAHD9qOOL
        x8pWwnLTQ8f3ITczdDcFkgYXvpsjzxz0n36MGl31JjkfyzBkCLuJ+LD8N6lBYdTZCHN+iZ+kc22
        YlBBHaQ3mD4SyBMLF
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr4927383wrn.333.1600778596280;
        Tue, 22 Sep 2020 05:43:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlYpb5HC1ZqinjgF1NmxdlGBvhDHuzFIdafVpb14tXR6I0O/+xA+GfB5yFf3c1E139RD3CTA==
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr4927371wrn.333.1600778596103;
        Tue, 22 Sep 2020 05:43:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id u2sm4411155wre.7.2020.09.22.05.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 05:43:15 -0700 (PDT)
Subject: Re: [PATCH] KVM: use struct_size() and flex_array_size() helpers in
 kvm_io_bus_unregister_dev()
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
References: <20200918120500.954436-1-rkovhaev@gmail.com>
 <20200919000925.GA23967@embeddedor>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <65ab660e-fc93-bca5-d320-83b80a8dee59@redhat.com>
Date:   Tue, 22 Sep 2020 14:43:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200919000925.GA23967@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/09/20 02:09, Gustavo A. R. Silva wrote:
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Queued, without stable.  Thanks.

Paolo


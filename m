Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D32112E92
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfLDPg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:36:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728238AbfLDPgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 10:36:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575473783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQOOeXeSC4acVeDbgVDeAqxSN0LyEEhsWxQonnVcIBc=;
        b=I5fGX9CKH+HClc+VuzgwcI66FeM6lB+Y7KQ7lxGoAVZA52Z5sr6MS0gb/TNMOlcdLaJ/xI
        KvLsU86RAkiAyCSY3j16F2UDWvRWvv9NadVsPRWKoIs2/45Oj1Q/VlZxGyUypIN+GEYcTr
        gLTo/nySyk1ghpL+DDnlFj7JFTKsswo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-44iYeRhnNlmj1a0Z97TWTA-1; Wed, 04 Dec 2019 10:36:20 -0500
Received: by mail-wr1-f70.google.com with SMTP id u12so20011wrt.15
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 07:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iQOOeXeSC4acVeDbgVDeAqxSN0LyEEhsWxQonnVcIBc=;
        b=UaDpiPyXzvwaEbb9WgwLvb07lMFdk8kP9ByBKWGg3q3lOYr+7Y4x8a6hLO7syfioHk
         qupLdyU6DPHM6xIWZLV7wyhOrmhxJF3FGXHjwVqlkJZCpu5xVA+j/c6BBczXO+9mcpQX
         0JG4FAJ8WeKafaijvfOVGnU8iZ+5pmFlkb/DWIlWj8r+zUdY5imdJbN6i2M4F3mlexS9
         b6XCdq+MVTP9HHd8hHhpgJhGMAwnQfzDartL67ZeR2Lsl9gSLs6l1V4zGnQK8kpJmjdm
         FLmAxrXiefn++5xjd2bVLkmnyYFaQkxERF7rQjBOXCT3lDfnRUpAkDgJlimF5hJqu59N
         aIuQ==
X-Gm-Message-State: APjAAAWECML1BeJYcN457ePMM9whGAGnXRHVjl95zH6lw8s86g3hskNR
        /cnzAShNfkAXbxbbJ1YUlMgVyzw1wnjqIwtzsYjPbJ0eItqSVGEb+RwaZw8VgNY8GZM5NDTYsVy
        QZsfyidII8gxij52n
X-Received: by 2002:adf:e984:: with SMTP id h4mr4581505wrm.275.1575473779565;
        Wed, 04 Dec 2019 07:36:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/M5MWOKcaMYIoGibWVUMRdDrTEapMHfZlP1x2J2svqUsmIkTvIxs8nBkMZJD5A0y+qXkVRg==
X-Received: by 2002:adf:e984:: with SMTP id h4mr4581491wrm.275.1575473779351;
        Wed, 04 Dec 2019 07:36:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id n188sm8242847wme.14.2019.12.04.07.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 07:36:18 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <1575471060-55790-1-git-send-email-pbonzini@redhat.com>
 <20191204152942.GB6323@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d46bd0a8-5743-4665-85ea-14351fd85cdd@redhat.com>
Date:   Wed, 4 Dec 2019 16:36:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204152942.GB6323@linux.intel.com>
Content-Language: en-US
X-MC-Unique: 44iYeRhnNlmj1a0Z97TWTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/12/19 16:29, Sean Christopherson wrote:
> 
> The extra bit of paranoia doesn't cost much, so play it safe?  E.g.:
> 
> 	if (unlikely(boot_cpu_data.extended_cpuid_level < 0x80000008)) {
> 		WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_TME) || SME?);
> 		return boot_cpu_data.x86_phys_bits;
> 	}
> 
> 	return cpuid_eax(0x80000008) & 0xff;

Sounds good.  I wouldn't bother with the WARN even.

Paolo


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496D91DB9B0
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgETQga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 12:36:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40716 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726747AbgETQga (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 12:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589992589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqYJ7uIrOlC74lzjdNx8dKV0aihb2Jm3KW9U6dMtg04=;
        b=QrJEYxiXfjgDy95MJrPxXiB5Hn6PK75wIsEcvv1Qz7vudLtlCyg6llrfLB4MaZZ5oqL2pB
        FksiyIiK8P/QKYF15kxDINJtz/BG0oE0Fi73eQ2+CEyrfsKEJ6T7YtALhOEby1SjvQ3vtD
        +9Pn0d/uoCX84Kl094TQdPplIb5PT9o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-_jgU4YTaMBqkXaXRXeq2xA-1; Wed, 20 May 2020 12:36:27 -0400
X-MC-Unique: _jgU4YTaMBqkXaXRXeq2xA-1
Received: by mail-ej1-f69.google.com with SMTP id g9so806754ejs.20
        for <stable@vger.kernel.org>; Wed, 20 May 2020 09:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XqYJ7uIrOlC74lzjdNx8dKV0aihb2Jm3KW9U6dMtg04=;
        b=OjdGPFsNUBtkwaZ9ZmDHeAd0Yl2TeYI4VB3ycQyd4zkgn42hXfgevImHCo6b8J2xWw
         RIG90ueebVZUom/LLjzkyjohu5Yknc+VqcVuzmUQ7yFoH+uMWoxWxMtzuCvRNZeAH/Do
         /3ykdEoLMP0ezv9NzDsKX1UEZSqwbAV/jIDSCONoSjEusKMl8zpbRTpXb9B/e8QBH2Ai
         ekr1e3yfOgip9CRHzWaToBZ52SPuWT3uokbj2qwYWIG9Uma7by+5eMY0jvxdLrS88z+k
         h/TvCDBr1fE1jiL6Tb1INheH5b11nOSHkoQPiYAyXE2nffu9b6zOobv69doxIGY33ZH5
         81VA==
X-Gm-Message-State: AOAM532YhLR89y7QRIt//qIO11IpCUk/u4PgdJP5+4w/+80FnEUIvBQr
        vG/ds2RoKk+knbaPFOPqZqvg62qZRFInxGKtDxE/uDxLyeDPC5NX97oSuNHHEJ0h7mHoPbza5xu
        LzYLkaZ+oVbLQLgx9
X-Received: by 2002:a05:6402:b2c:: with SMTP id bo12mr4351607edb.274.1589992586283;
        Wed, 20 May 2020 09:36:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzTlJNPnR4mbBk6k3pUd+KxeZ1wVjVSLPLcjUKURZtkun7XyhyGpaFHeuQWElBl88fdngySQ==
X-Received: by 2002:a05:6402:b2c:: with SMTP id bo12mr4351587edb.274.1589992586118;
        Wed, 20 May 2020 09:36:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u20sm2215506edy.80.2020.05.20.09.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 09:36:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     oupton@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags
In-Reply-To: <20200519180743.89974-1-pbonzini@redhat.com>
References: <20200519180743.89974-1-pbonzini@redhat.com>
Date:   Wed, 20 May 2020 18:36:24 +0200
Message-ID: <871rnetvg7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> The migration functionality was left incomplete in commit 5ef8acbdd687
> ("KVM: nVMX: Emulate MTF when performing instruction emulation", 2020-02-23),
> fix it.
>
> Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4f55a44951c3..0001b2addc66 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4626,7 +4626,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  
>  		if (kvm_state.flags &
>  		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
> -		      | KVM_STATE_NESTED_EVMCS))
> +		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING))
>  			break;
>  
>  		/* nested_run_pending implies guest_mode.  */

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


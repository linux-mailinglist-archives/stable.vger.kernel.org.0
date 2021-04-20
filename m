Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CC3365C40
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhDTPdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 11:33:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232764AbhDTPc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 11:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618932747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VzIaFG2wDVdYEizwLnnsRmeoa1MCm+iU4UbjuWNpwW0=;
        b=anQNL0wjSuL+tM5fUdujq03WYaqY6ZeMd0MNBcTP2U6f2d3oO5DF3aTtX/rHPNZ2pMFXfx
        kY4MnYw7F8BZHyFfJLVL1l7b0UNIZeDExyfh8mgp2y9PmuNwJEw4hRk6eEtLIpCa5zqqjU
        deAmLd2xi06YJfFlIm7uOhg+4S8HQqY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-r7eSMDcyO0ybuuiS_N9oxQ-1; Tue, 20 Apr 2021 11:32:26 -0400
X-MC-Unique: r7eSMDcyO0ybuuiS_N9oxQ-1
Received: by mail-qv1-f72.google.com with SMTP id r18-20020a0ccc120000b02901a21aadacfcso9530162qvk.5
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 08:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VzIaFG2wDVdYEizwLnnsRmeoa1MCm+iU4UbjuWNpwW0=;
        b=BrS+ZjV04Av5aVKfbkAESmjIDOvCjSmml+w4N63+Ho53DHV8GL2RGDMhCqqiij+e0R
         RcFo7YjdN9FYNNE9tfqUKOT8yNq6qVOesN9npRENtjKWGf2ln5Bu0eDgj7IJ5DLfIHEs
         8bxfbDIrnhovBmIsKnfxAnbiRlfhZWZWoLKGkrNUP5q0Z25aAkEzUO8KothV4EeA77Rh
         b64RmKE9zJzST3VY38wZA8nGMlS1CLSJnGmE5LYQKMK8NIKAhR4s8l0QTD6ueMYTcdF4
         OGzPpb/QfVM8YxasToQNNSj5bUgx4THJQD6/yPa0yLoTYrbybDFFR4HhyIp/aq3DpZuQ
         NNxA==
X-Gm-Message-State: AOAM530adsTXtRnkqfNFUk2zBNWkGJ0Da9/nSx01uYFdz2XtQHnVQYsG
        73UbW+qOgc4WJx1T6h6SB3V50lXo/c7B8knC45Q2ufPzOf1BnoS9QWCibd8zsC4MzPOOp98PGCM
        ihC/W0E1YqHgS44tO
X-Received: by 2002:a37:e108:: with SMTP id c8mr18492836qkm.499.1618932745573;
        Tue, 20 Apr 2021 08:32:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTKbZtJzki1RdMo4jaIwSDT4vU8zynoJCipKGsXfaSJHphwrc9cgg+bXzWrjtb96DzF1vjiQ==
X-Received: by 2002:a37:e108:: with SMTP id c8mr18492812qkm.499.1618932745353;
        Tue, 20 Apr 2021 08:32:25 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id f8sm4135429qkh.83.2021.04.20.08.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:32:24 -0700 (PDT)
Date:   Tue, 20 Apr 2021 11:32:23 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Always run vCPU thread with blocked
 SIG_IPI
Message-ID: <20210420153223.GB4440@xz-x1>
References: <20210420081614.684787-1-pbonzini@redhat.com>
 <20210420143739.GA4440@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210420143739.GA4440@xz-x1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 10:37:39AM -0400, Peter Xu wrote:
> On Tue, Apr 20, 2021 at 04:16:14AM -0400, Paolo Bonzini wrote:
> > The main thread could start to send SIG_IPI at any time, even before signal
> > blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
> > blocked.
> > 
> > Without this patch, on very busy cores the dirty_log_test could fail directly
> > on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).
> > 
> > Reported-by: Peter Xu <peterx@redhat.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Yes, indeed better! :)
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>

I just remembered one thing: this will avoid program quits, but still we'll get
the signal missing.  From that pov I slightly prefer the old patch.  However
not a big deal so far as only dirty ring uses SIG_IPI, so there's always ring
full which will just delay the kick. It's just we need to remember this when we
extend IPI to non-dirty-ring tests as the kick is prone to be lost then.

Thanks,

-- 
Peter Xu


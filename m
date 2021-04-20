Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E056A365B4A
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 16:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhDTOiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 10:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231682AbhDTOiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 10:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618929463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=33CVA8kWHawipps7EFzUJb1CXaHeSH20T2baV3pWy8g=;
        b=eawdI7Re9axqPZW5ClbKilu6mwYpkoVMvInu8pJzFsE/0fNWBYpGDhz/rUUlWOdKpbE0lE
        PHwsSqsnNQO0VamlFZeoQJ8egM/jX7TVEdsPP5ZMU35I3+tuADFJvLY5eN6D1rVSv5/MUI
        a37C5rtAZff2X1i478P7UGHeujXjyhI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533--ZORR2M5P96VrMJTPBfRgw-1; Tue, 20 Apr 2021 10:37:41 -0400
X-MC-Unique: -ZORR2M5P96VrMJTPBfRgw-1
Received: by mail-qt1-f199.google.com with SMTP id x13-20020ac84d4d0000b02901a95d7c4bb5so11131406qtv.14
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 07:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=33CVA8kWHawipps7EFzUJb1CXaHeSH20T2baV3pWy8g=;
        b=JXrqONqhk+yMHfk29mXG5cuEV5CM/bdH99ti2Thsfxzqd80yy/2BjsCkj+Lz2JsLrw
         UJ8B3EGXKlJpBPJjGmusUvdLvhfD+U5KmrLAOCaX5RJmI4j/VIN+KLEAfDwH8IDRtrIV
         /GJ2h82nz2EpQP7OKb5bhB0a87i9jb1jZY80mar30NFzFQ26Us2dn4EUg6PoE/gbctue
         lyTpX5y+zYuw5M2PVZW15QkZ1zmS925M1OQBtWTT8lSHK9trUyWUBvGYsYj0bfLNWvHX
         9FUDyn/Q2VeWrZGWyQ4mjxhkeIzaSyW1NwzaiMeFXee3RHd/vSToJdA4jQG37FLfKFyq
         n4VQ==
X-Gm-Message-State: AOAM533zFEM8q/+VH9D0ITQ8whM7Ae7z5pbOVS2dkFYQLpjcyH+ebWk5
        vuJ4m6RpoywLaQulAa/QaZXO6edYWqF08GAbdzcvKlInNVfKE48L5sz4zfBP7SPc1nXfiklmdgB
        Whd7d2LLIB3/cI31w
X-Received: by 2002:a0c:fb43:: with SMTP id b3mr12120015qvq.42.1618929461410;
        Tue, 20 Apr 2021 07:37:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4ONXVSlwHL519fIegDGFnXVnOOob94nUlZsSOdtHzcOFxIJiOusGtNuV+XRpmmYe1+KUq/Q==
X-Received: by 2002:a0c:fb43:: with SMTP id b3mr12119998qvq.42.1618929461181;
        Tue, 20 Apr 2021 07:37:41 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id k127sm12216745qkc.88.2021.04.20.07.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 07:37:40 -0700 (PDT)
Date:   Tue, 20 Apr 2021 10:37:39 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Always run vCPU thread with blocked
 SIG_IPI
Message-ID: <20210420143739.GA4440@xz-x1>
References: <20210420081614.684787-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210420081614.684787-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 04:16:14AM -0400, Paolo Bonzini wrote:
> The main thread could start to send SIG_IPI at any time, even before signal
> blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
> blocked.
> 
> Without this patch, on very busy cores the dirty_log_test could fail directly
> on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).
> 
> Reported-by: Peter Xu <peterx@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Yes, indeed better! :)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


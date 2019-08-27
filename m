Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903EB9F2B2
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbfH0Swl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbfH0Swl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 14:52:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DF7A10C6354;
        Tue, 27 Aug 2019 18:52:41 +0000 (UTC)
Received: from flask (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id 543355D6B0;
        Tue, 27 Aug 2019 18:52:38 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Tue, 27 Aug 2019 20:52:37 +0200
Date:   Tue, 27 Aug 2019 20:52:37 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: hyper-v: don't crash on
 KVM_GET_SUPPORTED_HV_CPUID when kvm_intel.nested is disabled
Message-ID: <20190827185237.GD65641@flask>
References: <20190827160404.14098-1-vkuznets@redhat.com>
 <20190827160404.14098-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827160404.14098-2-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 27 Aug 2019 18:52:41 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2019-08-27 18:04+0200, Vitaly Kuznetsov:
> If kvm_intel is loaded with nested=0 parameter an attempt to perform
> KVM_GET_SUPPORTED_HV_CPUID results in OOPS as nested_get_evmcs_version hook
> in kvm_x86_ops is NULL (we assign it in nested_vmx_hardware_setup() and
> this only happens in case nested is enabled).
> 
> Check that kvm_x86_ops->nested_get_evmcs_version is not NULL before
> calling it. With this, we can remove the stub from svm as it is no
> longer needed.
> 

Added

Cc: <stable@vger.kernel.org>

> Fixes: e2e871ab2f02 ("x86/kvm/hyper-v: Introduce nested_get_evmcs_version() helper")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

and applied, thanks.

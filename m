Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3306456A0E
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfFZNKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:10:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38360 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfFZNKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:10:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so2678451wrs.5
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 06:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bqOWDaCNsHrE1herZzAPunVmKg4cRAUoaCX+z3T2sAM=;
        b=IVISbzicSr/piVLQTHOK9pgw2FnJj0/r2HSKgh93ZYI777BoSL0PxxqSR1vi1hDPoM
         xzys/P514Re8FoIl4plah3RCervayPjnbQ3ZxYFimlVIXZ1UD8QHfZtg1idbqQj6Cfnu
         sM8ylAcbqVdg3QJwuwCNTWglvlBBohh3ysXTXy8vUbxiZSMq5nig5jslBNBvTdeRjprO
         xnG9U2Xbi15ewt0G4A2PiA1tMqibfX+Akv82N0i5Or3J9hnDbAEhl4pfWbw+BGYWt1bB
         0fD5ukoE37TG7EKYET95H0U2Ok6Zyp/E/Uv0Kb2e/H7bZJhzkLLN+RaYfdhJgeBkuuKC
         BQag==
X-Gm-Message-State: APjAAAVuAO47ubjM39OMXvW3dp1brdWm4aZHCCvf8lU92YACZNxomjL0
        TX2DlULUFsqR7xEIgTLaaqMfZQ==
X-Google-Smtp-Source: APXvYqy/cMPC8Av1yrbGtbve00ZFb/ieRgkL6SpMCmxq4C9XvGvgJpuLHhPLGFVuptpZ/fVy4FDH8w==
X-Received: by 2002:adf:fa4c:: with SMTP id y12mr3606968wrr.282.1561554637009;
        Wed, 26 Jun 2019 06:10:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e88d:856c:e081:f67d? ([2001:b07:6468:f312:e88d:856c:e081:f67d])
        by smtp.gmail.com with ESMTPSA id d7sm4766497wrx.37.2019.06.26.06.10.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:10:36 -0700 (PDT)
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if
 host does not
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        mingo@redhat.com, Borislav Petkov <bp@alien8.de>,
        rkrcmar@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        stable <stable@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Jon Masters <jcm@redhat.com>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
 <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
 <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de>
 <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
 <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de>
 <b6c2ac14-d647-0fa2-f19d-88944c63c37a@redhat.com>
 <alpine.DEB.2.21.1906261440570.32342@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f258b10f-dae3-7cf4-5a0c-47fe067065b4@redhat.com>
Date:   Wed, 26 Jun 2019 15:10:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906261440570.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/06/19 14:41, Thomas Gleixner wrote:
>> I think it's better to leave the guest in control of SSBD even if it's
>> globally disabled.  The harm cannot escape the guest and in particular
>> it cannot escape to the sibling hyperthread.
>
> SSB allows guest to guest attacks IIRC

SSB requires something like

   p = &foo;
   ...
   p = &bar;
   q = *p;

where "p = &foo;" is executed from one privilege domain and the others
are executed by another process or privilege domain.  Unless two guests
share memory, it is not possible to use it for guest-to-guest attacks.

Paolo

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F7056780
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 13:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfFZLXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 07:23:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46044 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfFZLXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 07:23:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so2253889wre.12
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 04:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fjQc1qNIdZfNF/NDujWvCMQ2yfBiCYxY24N/zNlf1Sc=;
        b=T6rUTC/K+RDBOgNT3TjfcZJkObZzwHEXF9J+vJXx7A6MFsKwW4H1FxCIh+q3ysF9J9
         mnJ2Y+tM08xr3CYQjoOiznaCohSD8+sBXB1F17deD6p3oxIQGEA3AycMHfMZoCivIEkN
         aAo6C8vnG4AYk4U/hShNKDeBuedMvqtG1hUs+jrUlrXxKvmFH/NN/oF+95rm5sLV314B
         16/UXt9xRj1vm8Fk9+iNZAu9rV21AscWsNjpgruVKEM4okFdlaaM8Qn2l2LFJNKDIZbB
         idDxyEwekYdxjYc743Usk0jeHK1RUY+y502n5JC+QXWv8eqBs7Lh+ewCVGCwo7AWPT6A
         mkVQ==
X-Gm-Message-State: APjAAAUlz2El9a80PjdjOZtTRdXlFlt46Rp9DICV9GxfN8fgSygRIIjs
        5uLHSSe4o3VTvhIMItH37DXADA==
X-Google-Smtp-Source: APXvYqxzPVbgC2v5Z5f684Hw679jGU5eIVWc5gw7gHAtuDitqWREZ2c9Yv7LwO07wFwWn8EJzrI8QQ==
X-Received: by 2002:adf:c654:: with SMTP id u20mr3435135wrg.271.1561548182090;
        Wed, 26 Jun 2019 04:23:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:61c1:6d8f:e2c4:2d5c? ([2001:b07:6468:f312:61c1:6d8f:e2c4:2d5c])
        by smtp.gmail.com with ESMTPSA id a7sm17956545wrs.94.2019.06.26.04.23.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 04:23:01 -0700 (PDT)
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if
 host does not
To:     Thomas Gleixner <tglx@linutronix.de>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc:     mingo@redhat.com, Borislav Petkov <bp@alien8.de>,
        rkrcmar@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        stable <stable@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Jon Masters <jcm@redhat.com>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
 <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
 <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de>
 <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
 <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b6c2ac14-d647-0fa2-f19d-88944c63c37a@redhat.com>
Date:   Wed, 26 Jun 2019 13:23:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/06/19 20:22, Thomas Gleixner wrote:
>> I think that even with that approach there is still an unsolved problem, as I
>> believe guests are allowed to write directly to SPEC_CTRL MSR without causing
>> a VMEXIT, which bypasses the host masking entirely.  e.g. a guest using IBRS
>> writes frequently to SPEC_CTRL, and could turn off SSBD on the VPCU while is
>> running after the first non-zero write to the MSR. Do you agree?
> Indeed. Of course that was a decision we made _before_ all the other fancy
> things came around. Looks like we have to reopen that discussion.

It's not just that, it's a decision that was made because otherwise
performance is absolutely horrible (like 4-5x slower syscalls if the
guest is using IBRS).

I think it's better to leave the guest in control of SSBD even if it's
globally disabled.  The harm cannot escape the guest and in particular
it cannot escape to the sibling hyperthread.

Paolo

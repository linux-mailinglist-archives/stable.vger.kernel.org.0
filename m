Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6228102B
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 04:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfHECEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 22:04:31 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36775 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfHECEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 22:04:30 -0400
Received: by mail-oi1-f196.google.com with SMTP id c15so5527645oic.3;
        Sun, 04 Aug 2019 19:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jlZVpCwb8LJh/MImQJYCN+5/OoJlhiTXGdKz7PMIeAk=;
        b=qgxebg64y7SzQkWFag7qCkN/7qLUFZ3IhNEs6U471CltZZf9NHFEc8ZKfkzKe5ZtxH
         ujyyDOA9da1Bq37hBZCDn1nbFMeqkB71xNmT1V9llcYGzW9cv42k8oCXdAY9T+kkxZBT
         3Yo/kupBHL+ztjMu+q9Vmy9tfdmio3Tne8YwRIoCG7FuNtNnFo5nx9uAbEIbvFbqzceN
         CaYtG1Fbe+r2AM3IDDo2HOHb66HKcyiYTaSxTXUtRvndJj8QdUirDqOFiYgl3RfTu3oa
         52N1yAQPnmEnb6EwNuYGdUSEaNtklBRBd9/agnSITYOUOlKjKWyKJo6JCcdHEPaBidM8
         469w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jlZVpCwb8LJh/MImQJYCN+5/OoJlhiTXGdKz7PMIeAk=;
        b=BW1Bddrg+FnB0w9kKTI8VEsQTxN2sEHbdyy9pXFkPGS4RvNXCTMbz49PSfqz/Dqv4H
         dEjRgHE5E6ZBZ0d/eNRSQ+1GfEvtzANwa68s9kpH2/v20LPeegy7c0oMcKDUxqMQQbpe
         Ltr467AQQqI1ydX30BJGq5b9rRxqNMtM8aymKcjtNQLSoKDNToKJwQvGzVWh0f8VQbx6
         jYPbSkPTjKhCG0FLHl8zMEMAGQPcFPJffY/4aG3FlvIsUXH9R7reb7q2y+HggbnmHPqZ
         qF4etWvOkOzsWvJKcTcoKkPt/0Rt63jcKuBkrHkdEqXPY6hktCVn7hYVpUYeVyFB7nrS
         a+7g==
X-Gm-Message-State: APjAAAXY/bMel32UolVU2KpUJstUolI+kcgXo4CkfLiyAuzsYRC78J8f
        kGh9BBBThgDyv5NetYZGDha+tKcKf/IYvE2V6ds=
X-Google-Smtp-Source: APXvYqz6lX9fZZLvIhSvVRRDavkLmaRClv++hVn4Zwuyqy1Mduqy7fnUmDJanY/GYnXBwlTmyh0bRzthfrVMVVWTbfY=
X-Received: by 2002:aca:544b:: with SMTP id i72mr10077821oib.174.1564970669691;
 Sun, 04 Aug 2019 19:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <1564630214-28442-1-git-send-email-wanpengli@tencent.com>
 <20190801133133.955E4216C8@mail.kernel.org> <CANRm+Cy1wWSwn7HH-dNWeR6FX1TT_M7t_9vvRMdCKFATmvFDkA@mail.gmail.com>
 <c96d6707-87bd-1794-331e-6fa1a2d562f8@redhat.com>
In-Reply-To: <c96d6707-87bd-1794-331e-6fa1a2d562f8@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 5 Aug 2019 10:04:18 +0800
Message-ID: <CANRm+CxZ_ZKeOtjMEER+EevZ7CrDwKAU9pxcR4TodEJEzmBbHA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 3 Aug 2019 at 14:41, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/19 02:46, Wanpeng Li wrote:
> > Thanks for reporting this, after more grep, it seems that just x86 and
> > s390 enable async_pf in their Makefile. So I can move 'if
> > (!list_empty_careful(&vcpu->async_pf.done))' checking to
> > kvm_arch_dy_runnable()
>
> No, wrap it with #ifdef CONFIG_KVM_ASYNC_PF instead.  Thanks!

Ok, handle all the comments in v4. :)

Regards,
Wanpeng Li

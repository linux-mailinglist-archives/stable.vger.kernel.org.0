Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C3898E31
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 10:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbfHVIpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 04:45:49 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44996 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732645AbfHVIpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 04:45:49 -0400
Received: by mail-oi1-f196.google.com with SMTP id k22so3754922oiw.11;
        Thu, 22 Aug 2019 01:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jKYbXTHbKeqXk3/QcHdHCYFEiJQonidXlyf2wekjZ1Y=;
        b=KY+TnIpJ85/PwZlFH5EpnjTSxIOrJRg3El0QaSWEe2otvIauhgT8Ul/kUoIFnnCyxJ
         U2GJirzcNM2gd2UcRxr8CDtzvlJVOb2AtrAemuhw0mtXxjPHc88pAH7+7CgmTdffLw69
         fMnEdwCoucjrcyWYlHm3b087GAS2XrkswRlNJiLL1eOYzOvjg9NvNp0qbwQdFJaHcqPM
         qb896TZykD7/rYK9pMZ+Zf8K9PU27oPGpN3FWunN9NS/t6Xezfjf+0LgxpVkpi+O4NPf
         g9r3FcrjlwzZ6yJxMS6wMpq6Q1jmWVDStdtfgqknzKbICMfVdv31hLE/zn/kTBwnVsrl
         m8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jKYbXTHbKeqXk3/QcHdHCYFEiJQonidXlyf2wekjZ1Y=;
        b=SmE+cmEXxmqqB2p6WY1SoOgPu/L7tRC9b7nPNnrkshSV2VewrGhiJKjWz6lkeqzvEz
         b4QgwsN5cCbDzCcpTgO4yzpXor3S07d69CyXMOT/BeivZLqPWD6ZFaCZd68Hq6JpvqSG
         jXCL3/vX5A6CvD9qfp6Zce71udAIoUiDYAlqzstsE2XWTgJpRgwCHJe+P+6dEu9JS5Ar
         uqBDcFibVRmxjVO1gNhfryWlZ/tX6ZoWJ24Gpira3TcfJ7SZxM4MF1sV5DeX+tYRi+7O
         crZAp+SLkT+jpYluTvLbyp1vUU6+dclSygP/dmDM7ky5TpQoDSLXhlsgP6hKRDcjOBBf
         olOQ==
X-Gm-Message-State: APjAAAWIoWb4MXCTjPQOxiMv3G7VD/BVS0U5vpagGq0HKxAWYCu6DWu0
        kASecZ8LhlkGU5+bVchC5L1fSwwb9ESeOiq5lbA=
X-Google-Smtp-Source: APXvYqx7Gjiy2pRCqFz9b3Lso7nAlWJR6iJsSUDq3doRIwBwEMp5ZqG87vC7mzO2+9jwDdu6qgM7mks8hkDzDihecpo=
X-Received: by 2002:a05:6808:4d0:: with SMTP id a16mr2822988oie.47.1566463548301;
 Thu, 22 Aug 2019 01:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
 <9acbc733-442f-0f65-9b56-ff800a3fa0f5@redhat.com> <CANRm+CwH54S555nw-Zik-3NFDH9yqe+SOZrGc3mPoAU_qGxP-A@mail.gmail.com>
 <e7b84893-42bf-e80e-61c9-ef5d1b200064@redhat.com> <CANRm+CzJf9Or_45frTe9ivFx9QDfx6Nou7uLT6tm1NmcPKDn8A@mail.gmail.com>
 <728bf051-02eb-8fe8-042f-9893f23b4a68@redhat.com>
In-Reply-To: <728bf051-02eb-8fe8-042f-9893f23b4a68@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Aug 2019 16:45:13 +0800
Message-ID: <CANRm+CwaMDhiCvHX7eL4fL6bcPYd76yYPVL2uuiuKTVW6ZZP4w@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Aug 2019 at 16:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/08/19 02:46, Wanpeng Li wrote:
> > On Tue, 6 Aug 2019 at 14:20, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 06/08/19 02:35, Wanpeng Li wrote:
> >>> Thank you, Paolo! Btw, how about other 5 patches?
> >>
> >> Queued everything else too.
> >
> > How about patch 4/6~5/6, they are not in kvm/queue. :)
>
> I queued 4.
>
> For patch 5, I don't really see the benefit since the hypercall
> arguments are already traced.

Agreed, thank you.

Regards,
Wanpeng Li

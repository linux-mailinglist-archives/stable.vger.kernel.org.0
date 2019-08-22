Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACBD988AF
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 02:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfHVArb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 20:47:31 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37532 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfHVArb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 20:47:31 -0400
Received: by mail-ot1-f68.google.com with SMTP id f17so3893354otq.4;
        Wed, 21 Aug 2019 17:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5+8V3eJWfGGDoM+IoGi8PvkamL+iQCdi1rQoKthzls=;
        b=VC4S9hTFe2NMNT+NR6RJSwaryBnEIZOo9KBE05W4eqXmpufXycj0tFoZZAVxBXtkuS
         xgwkYC85pjHmSrOmYTvGrYS4O1pYB7wM67YmTJEeSsTDB14S8f/SRIUv5fN1QbGKzmU7
         6UEY1dNlIGm5fN/Mo1ZSrXaIQjOlsMOOn25chYGV4nhBeEQqKmZ6kPr4psq0s39Vz47B
         p/F8KlIYS7RfH0/4gucRql7iV7PofXa0mNE+Y7Xrg4+fqgCAH78nxSO1bu9x3TC67X+z
         2mZORlLmQAek2qImmOIPUNBrjesPTc+YJDOBgctxox95cm1bORcVYCvBrVO21AypqUY3
         UYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5+8V3eJWfGGDoM+IoGi8PvkamL+iQCdi1rQoKthzls=;
        b=ZQsF/fbW4DzLsDDgOn9klcSPCeO0NGxGEivCTA1HOk6EGoem4vlniST0oeHuYlvfjl
         nU/dDrkyoErTlCbSXkKHOKMr8nAQ0rYZ1nwhTRg3fz+9U62yItx5aUlBjwd5xU9GTPDr
         IkbY1QvGCBCbeeb9uzlp7hx5uJOjTBPrY1TimWvHlPVYYEw5UklW2NEgob3cTr3Wrf6k
         G5SISQK81lEpT7ZKQDqqMuF+06ZYVWF0AkFXifTXM7+AH4jhwNxwk9ryvbYfLZshezHR
         6J8SjwXDAbcCCie5dGmdSa939xkHL5wfQp86G/f8U7MhVQixrY+06S4Y/s8eaMcvZ/Tz
         hfnA==
X-Gm-Message-State: APjAAAXMSu2T3abFYKekQkasebl/wL6zJU22DiyMNrdpuJSIrSpthTKP
        Adh57l4kwZ4ApQ/OgPQtjNjMbT7y4SbNhMhioBs=
X-Google-Smtp-Source: APXvYqx1ubxmdTzLEQJe8vEwiBwjrYjEbwhI0GFJNumYWCLD2E6HSMOS2uc/P0Wmp89hRIcF4zjFhZmu9oqKzebqNKU=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr77827ote.254.1566434850855;
 Wed, 21 Aug 2019 17:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
 <9acbc733-442f-0f65-9b56-ff800a3fa0f5@redhat.com> <CANRm+CwH54S555nw-Zik-3NFDH9yqe+SOZrGc3mPoAU_qGxP-A@mail.gmail.com>
 <e7b84893-42bf-e80e-61c9-ef5d1b200064@redhat.com>
In-Reply-To: <e7b84893-42bf-e80e-61c9-ef5d1b200064@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Aug 2019 08:46:57 +0800
Message-ID: <CANRm+CzJf9Or_45frTe9ivFx9QDfx6Nou7uLT6tm1NmcPKDn8A@mail.gmail.com>
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

On Tue, 6 Aug 2019 at 14:20, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/08/19 02:35, Wanpeng Li wrote:
> > Thank you, Paolo! Btw, how about other 5 patches?
>
> Queued everything else too.

How about patch 4/6~5/6, they are not in kvm/queue. :)

Regards,
Wanpeng Li

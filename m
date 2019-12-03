Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE810FD99
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfLCM1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:27:50 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45482 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLCM1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 07:27:50 -0500
Received: by mail-lf1-f65.google.com with SMTP id 203so2741785lfa.12;
        Tue, 03 Dec 2019 04:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lPde8Be7r9/wxtONVuki371HY8PY1x8aHotJ6fyWpvE=;
        b=cyRBSgt8Vp0TMyavVQuKIzKsahinYHMrmjn4ZPsKZLSEf6RsQxIpOxdj6tR3opxY9h
         UbFZBYZhS5HxvsHmST7Xp0fTATmTm/C4ORawgBhWmiI9WqtdNj6HaM8ixphoEWd0Ac2h
         F/2TQz7iT3E1bUm9zHS3O8b1fZvxfBVKTh6gEOVff9OK4oLKDelUM+byurOqrfUBb2vP
         n4nKAEIHBTHcuEmD8UOTJeQBhMtoyRktZDhu9hs6TH1q1eyj56w4S50FcXUMojr8sYFy
         96RvTCIC9yN+wN37w1lwXsUxwl6G+ufj+VvNCGVkeOYuR0AbcKX5xrgMYYFMqiH6IW7K
         Z/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lPde8Be7r9/wxtONVuki371HY8PY1x8aHotJ6fyWpvE=;
        b=Vl2sEyM9oJrEasHayCcGt2ZEHyqM7LB6r2546NGx9B+cDEwbHVB66s/Q3BqIGO5p0k
         YDOeI/qRRG4uenTIeTRokvLtfOQXLXTSQFJ5mnQHe4Vw28UdC39u0b3+RGbF5GBdGdgh
         Wu/l+6yI2al+K3iW6VGcwNfWtkg3lZPyEPSjTDtsnAQoVKzouBbK+o1Db0B7uJGWOwXj
         tvRB6z7gyl7Aza/U+i0R8/9jMVQE/U1mkBq4sTnm3dfI797DGpdve9rGHUO6nTFiILpH
         HM3KTqOBSzm8Z9SRNc/MT9ZsUAkv0KZvh20aDEV5DYCU96kopmJ+94rKBT1mTbAwwqqp
         iJQA==
X-Gm-Message-State: APjAAAXKoleWtLpA/hJPHH+NWjl6WJhp/hMeNStL34j9RddjmVd2UCrH
        VsqBf0sLZ/6vFSFAe9GprPAYxo0MlP8aokT6VcU=
X-Google-Smtp-Source: APXvYqy8e5IHf9NtkAIhwQXFm1S5l12/xlMUAoD1iNKmoiDHVWTZ5buLIbTFKBagaXSyPnPEMslS5vOVw6hlCYghobk=
X-Received: by 2002:ac2:4194:: with SMTP id z20mr2592432lfh.20.1575376067703;
 Tue, 03 Dec 2019 04:27:47 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191202145105.GA571975@kroah.com> <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
 <CA+res+SffBsmmeEBYfoDwyLHvL8nqW+O=ZKedWCxccmQ9X6itA@mail.gmail.com> <828cf8b7-11ac-e707-57b6-cb598cc37f1b@redhat.com>
In-Reply-To: <828cf8b7-11ac-e707-57b6-cb598cc37f1b@redhat.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Tue, 3 Dec 2019 13:27:36 +0100
Message-ID: <CA+res+Qo1mX_UFEqDD+sm80PZeW4bRN8VZeNudMDaQ=5-Ss=0g@mail.gmail.com>
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

snip
> >
> > Should we simply revert the patch, maybe also
> > 9fe573d539a8 ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
> >
> > Both of them are from one big patchset:
> > https://patchwork.kernel.org/cover/10616179/
> >
> > Revert both patches recover the regression I see on kvm-unit-tests.
>
> Greg already included the patches that the bot missed, so it's okay.
>
> Paolo
>
Sorry, I think I gave wrong information initially, it's 9fe573d539a8
("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
which caused regression.

Should we revert or there's following up fix we should backport?

Thanks,
Jack

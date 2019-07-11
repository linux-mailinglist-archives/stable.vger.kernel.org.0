Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BAF6589D
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 16:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfGKOPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 10:15:01 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:45140 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbfGKOPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 10:15:00 -0400
Received: by mail-yb1-f196.google.com with SMTP id j133so2589520ybj.12;
        Thu, 11 Jul 2019 07:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24mHEeUOKdC3lWSV7eKiUFRDL0z9SNtZomrLjyCZibM=;
        b=P8XRXZoUD+qcbbA5wjfT0Sbrkh2GkMW5nl1YR9c9DaCZ5R/rZE06son+q39bbtNUnq
         sIcu2tg1M2TK8u072UUNipL2EOTpV5ITyDymrzT+GdjMJY6d5lqXnrUCE5gxb0UgrY0o
         MWOrZ5IWR5BsKPh2CPoAmulPOo6uUA0ovLkCjIjruwFBirqCEHZjNWUEovuqI0xqPcnV
         y4PiF9+Pj2Suk+Ac0OHk78s5/iszggoW8KSLb/2eyUCClVRxALbhr00CSZQ0g3boT/96
         t7cfYe2ilDqIGeMovPq0/dmtDZMRWi6rGslzwiEsAI3N2faJwbkR6g5ZNZ4HTkHThCUX
         JQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24mHEeUOKdC3lWSV7eKiUFRDL0z9SNtZomrLjyCZibM=;
        b=eJQhPyJYl3LwCFoocEHuy38b7JMWKx51rYZKwP8CxeyyXgJGl9Dz/2kV/nWM8fWv+5
         ltlSHfgW4Npp/a7QHLlVu0r3kCErKPlmp/+J1enGSY/4hk8PNlbVWNdxhCR46N3Pql9B
         uj2F8DlsFnJ2525T+E7jV2aKZROSW3n4fdme3pVddEMY8YJXiHev8zcXKLBMOK3xcWuY
         INGxSaPu780BFSyr4XMliMRliTqgMKBNXC+fg/2aW9n9etDJsO/gN4LsJA2h8L2/4VA+
         /wKiReaPH3a4b2NJ/wxzd2QBvofjmeh8bNB8aVtJ9v89QLqFlh8MNe+aMLNU8QYaiIqv
         qU3A==
X-Gm-Message-State: APjAAAXXqvZRyuJH7GrQ3PQXkAq/rJcK9jNHH6g0S6Z/+9mIf7jOZm5e
        Hsawr8E0EvncALwi1G3lpHUvrGTLsTCIzGFiaTfAFa0K
X-Google-Smtp-Source: APXvYqw6F9inQmNYMnP0aVWuiYhvauwPlNixWVJOJSg0qDvXHOXcPE2ah/3LoQhtfrN7kkpcV+wU69YXlYD7K67nixo=
X-Received: by 2002:a25:7683:: with SMTP id r125mr2422175ybc.144.1562854499483;
 Thu, 11 Jul 2019 07:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <1560073529193139@kroah.com> <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com> <20190623010345.GJ2226@sasha-vm>
In-Reply-To: <20190623010345.GJ2226@sasha-vm>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 11 Jul 2019 17:14:48 +0300
Message-ID: <CAOQ4uxgv_FOLagfAMa=XLZZXnVhKoQK9oUHXiO45TZrKq5LQDw@mail.gmail.com>
Subject: overlayfs regression in master and stable trees
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
> >3) Disallow bogus layer combinations.
> >syzbot has started to produce repros that create bogus layer combinations.
> >So far it has only been able to reproduce a WARN_ON, which has already
> >been fixed in stable, by  acf3062a7e1c ("ovl: relax WARN_ON()..."), but
> >other real bugs could be lurking if those setups are allowed.
> >We decided to detect and error on these setups on mount, to stop syzbot
> >(and attackers) from trying to attack overlayfs this way.
> >To stop syzbot from mutating this class of repros on stable kernel you
> >MAY apply these 3 patches, but in any case, I would wait a while to see
> >if more bugs are reported on master.
> >Although this solves a problem dating before 4.19, I have no plans
> >of backporting these patches further back.
> >
> >146d62e5a586 ovl: detect overlapping layers
> >9179c21dc6ed ovl: don't fail with disconnected lower NFS
> >1dac6f5b0ed2 ovl: fix bogus -Wmaybe-unitialized warning
>
> I've queued these 3 for 4.19.
>

FYI, an overlayfs regression has been reported:
https://github.com/containers/libpod/issues/3540

Caused by commit "ovl: detect overlapping layers"

I am working on a fix.
In retrospect, given my lengthy disclaimer above, it seems
that this patch should not have been applied to stable (yet).
I believe that this patch belongs to a class of fixed that
should soak in master for a while before being considered for
stable. On my part, I will not propose these sort of fixed in the future,
with or without a disclaimer until they have soaked in master.

Thanks,
Amir.

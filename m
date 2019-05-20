Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CBB22A03
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 04:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfETCn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 May 2019 22:43:56 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52159 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbfETCn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 May 2019 22:43:56 -0400
Received: by mail-it1-f196.google.com with SMTP id m3so16752251itl.1;
        Sun, 19 May 2019 19:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Oz/YZayaErdzdzhKp0fyhCZgzFhmaZCIFKkjQCJwlc=;
        b=mLbts5Y3adqCCNOiBTBvLEF/D/VgYwgALLSOeLQSx8p8FyDSSJWEO5SOBOpdUY4oHF
         pzTft49wWnlzo+V9/gMcK5j2VXwSRb0rS8aUzseZ8l/T8DJHgeMM2V/vRZUQLEClutO5
         0OhAXfagAk0ZlFMd0dw+zbEz3VRRwMyRGe1P3MyprNgqbHdKpzzulM0mM4jaELXnGuVn
         v6f2fZ8DkIpVTNRIMZh/QYtxQB1fTHcgjCO3yDpDikXbR4Q4exHekEFITwHqpaATKgBR
         W75JUllIhs+tKXuZbtG82RRlMuGN1zOwwrlZKqIVx6z3uAIY/crrVSnd2mRtKe1+RW/t
         LNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Oz/YZayaErdzdzhKp0fyhCZgzFhmaZCIFKkjQCJwlc=;
        b=T7J5mqs+jvH6LSeGdeMEEaihrrByeR9dUT8gwvJo/c8ESwqOfNWKnEuZ0/sOEwpi9h
         k6r8gg8Z+h4RVRnk3IrCkhubFAY+MZsgnJQDC734nzZ4ugTLHHHTQFeAGdqtvBwCQeNT
         Jpo/a2lADv90rH6mDmBJ6p0gGdS1C2Wq9MluoHDzPEDMvq0/NmDqAtZwNdB7MYDqPK4q
         Lmxo2G8e4seo/0p7Zr1bQ7+tbQYVYoh/OWdJekhdrd+X/PZenJvMh6g2dRHzJP1H5h8u
         R2darQhnkvZniqmZ0AcRLn5nZ6py+g4jRXGZNL9GeWO/biK0RzZBEOuw+FCjRYQB8SoS
         dSpQ==
X-Gm-Message-State: APjAAAU6Nw2quuFlYn6d8HbUVVR9xTLzzgDwjNR5kmEXakKfsmWrCKia
        +jaQH8MCPcEbEEs9tw9Yleq97cE2uF1nNwAh3MQ=
X-Google-Smtp-Source: APXvYqwX83EyMWnhZTroZgn/yFXpCshf1utCd63Zo5lr+tdPYblxILai87WFk5neVpwdrOXIgQWX0a0ubNLlqRZAiYQ=
X-Received: by 2002:a24:f983:: with SMTP id l125mr28527609ith.62.1558320235895;
 Sun, 19 May 2019 19:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <CAKM4Aez=eC96uyqJa+=Aom2M2eQnknQW_uY4v9NMVpROSiuKSg@mail.gmail.com> <CALJn8nME9NQGsSqLXHQPEizFfKUzxozfYy-2510MHyMPHRzhfw@mail.gmail.com>
In-Reply-To: <CALJn8nME9NQGsSqLXHQPEizFfKUzxozfYy-2510MHyMPHRzhfw@mail.gmail.com>
From:   Eric Ren <renzhengeek@gmail.com>
Date:   Mon, 20 May 2019 10:43:44 +0800
Message-ID: <CAKM4AeyJs8KUB3vi=GPDnb-yjED2oFYvn7O=CPNi3Er3orAbfg@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, 18 May 2019 at 00:17, Guilherme G. Piccoli <kernel@gpiccoli.net> wrote:
>
> On Fri, May 17, 2019 at 12:33 AM Eric Ren <renzhengeek@gmail.com> wrote:
> >
> > Hello,
> > [...]
> > Thanks for the bugfix. I also had a panic having very similar
> > calltrace below as this one,
> > when using devicemapper in container scenario and deleting many thin
> > snapshots by dmsetup
> > remove_all -f, meanwhile executing lvm command like vgs.
> >
> > After applied this one, my testing doesn't crash kernel any more for
> > one week.  Could the block
> > developers please give more feedback/priority on this one?
> >
>
> Thanks Eric, for the testing! I think you could send your Tested-by[0]
> tag, which could be added
> in the patch before merge. It's good to know the patch helped somebody
> and your testing improves
> confidence in the change.

Please consider Ming's comments and send patch v2, then feel free to add:
Tested-by: Eric Ren <renzhengeek@gmail.com>

Thanks!
Eric

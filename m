Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7303B12E9D5
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgABSTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 13:19:24 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45262 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgABSTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 13:19:24 -0500
Received: by mail-qk1-f194.google.com with SMTP id x1so31957507qkl.12;
        Thu, 02 Jan 2020 10:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiA6prV/pcdaBQz/2o3tVfYvXvP/VCg1SINlvr/2RiI=;
        b=jW27o8mnGTz/Pr9XXOqvQAB9GuhTm4g8T64mUbkKWMl5wSF3QeSOh+VXNb1UVgvKl5
         6szxYyH4XjMsQVEpbGQWn/blCNMysw71joDhnYEBmP84P9YnQv4ZSGf9+KfYRUMUVttu
         N29iDGDKYxyAgR63cleld0oCdhL+D5UrCGCXa6ARo5ZAnZIiDx/fX5hd72l+47IhVrZr
         HafW+SrYYDeKKkxFZ85sd58ih/Lw+781dhpY6eoLQ33SCI7xAqkiyX3aLTpj/Kc2cEqk
         8rAK9rUv5gkwSnlYclIX2F5g47UNWNHDVPmzg87ia6BoyeLRg1PVFas5wCAFSxpT3ECh
         X3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiA6prV/pcdaBQz/2o3tVfYvXvP/VCg1SINlvr/2RiI=;
        b=l72DCvWBSr1KcWJvAR4haSGF+NnrZ1ZoOErlmYJpfBh303zfLdNymeanejd/BQaA3l
         SrF4nk/R826RMUbsQTHll94t88s/nZX7QZUaG+F1VX8pHa8OHR3+uNOBOlZfTAYYmgh4
         16RZIB3kywEj6Vq17hZPQwwiQ+XbJ9NeeQm3UFATJN5n2eDOqYY/MJzYyCDJXE67FMeC
         TTnLm8dFjsK+sKnD16yOz61R6rxULv7H00a6IoFAAFhrE1XGgL1aROOkWKtGYRPWaReC
         UTGNCOUOqMQi7acJVlnFu+0PMukdm8CaeMIQlfETgYS8X2Axgco8qXZp5jU69eezGcwS
         MfjQ==
X-Gm-Message-State: APjAAAXTDntMhCkqs6umHjxTmeMcsjAQLtSw1XhB1noL8s4578DxBZbg
        9sKPWWuYS4BoxfV3miV9NZ1DnmHKkacwXm+sSQSmWrvr4HrW4w==
X-Google-Smtp-Source: APXvYqyHv5DHn2O9oCsSosshalcSdQe5XkTF8/SfWYELNJIJC++qANMRwEgl/JHuUB2ENGrBm361pJzPpii+SSAHZ2Q=
X-Received: by 2002:a05:620a:138d:: with SMTP id k13mr11200212qki.239.1577989163650;
 Thu, 02 Jan 2020 10:19:23 -0800 (PST)
MIME-Version: 1.0
References: <20200102172413.654385-1-amanieu@gmail.com> <20200102172413.654385-8-amanieu@gmail.com>
 <20200102180901.tgtl7wxtq434h5ny@wittgenstein>
In-Reply-To: <20200102180901.tgtl7wxtq434h5ny@wittgenstein>
From:   "Amanieu d'Antras" <amanieu@gmail.com>
Date:   Thu, 2 Jan 2020 19:19:11 +0100
Message-ID: <CA+y5pbT8yhDEjHnZvGcKM3=H2a+hjY0QOQZOu=YjnvPOJC00Gg@mail.gmail.com>
Subject: Re: [PATCH 7/7] clone3: ensure copy_thread_tls is implemented
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 2, 2020 at 7:09 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> I'm in favor of this change. But we need to make sure that any arch
> which now has ARCH_WANTS_SYS_CLONE3 set but doesn't implement
> copy_thread_tls() is fixed.
>
> Once all architectures have clone3() support - and there are
> just a few by now (IA64 comes to mind) this means we should also be able
> to get rid of of copy_thread() completely. That seems desirable to me as
> it makes the codepaths easier to follow.

I've already implemented copy_thread_tls for all arches that currently
have ARCH_WANTS_SYS_CLONE3 in the previous 5 patches. The #error is
there so that any future arches that wire up clone3 don't forget to
implement copy_thread_tls as well.

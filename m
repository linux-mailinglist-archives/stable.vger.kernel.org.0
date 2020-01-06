Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1311131BD4
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 23:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAFWvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 17:51:19 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43320 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgAFWvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 17:51:17 -0500
Received: by mail-qv1-f65.google.com with SMTP id p2so19739385qvo.10
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 14:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pd6XIV7OgADHPUC0a4p/Mb4IhnpWoH1UAexZuXJ1p3s=;
        b=gR+oYRZ4onpW0u9eAxj2ULlDOyWb/ugEKFPgUuK2O9X4B/ADTb1dAA1I8WaavTN82y
         TKTIz5wUd/O9vHnYgWUUQewQh5/ZQhyv/kzfmjfxmbqrKoLZ8iwhZ4k1SccdXyF2UtbP
         lyWZ0Yw6bvfq+QSjMpFD5XKceAOGyIPdBuN0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pd6XIV7OgADHPUC0a4p/Mb4IhnpWoH1UAexZuXJ1p3s=;
        b=Nt/Nta+oq8Ow5xAwOpf2Xn/aMaRIMRgVj9jaj7vwJvE31J437i6w+FJ1vyPF/Gjeen
         wikLnrN7gthJDoIuVvW986qnY2hYNhNEOJjFt28IcyCkqHkk7YUGy7ZrX7AlU56+jlzT
         0SfAHv5lJV8IE272XOHPJQhuirH4+x1i6aIQ/oIbDGBGvFaBrvlMGZX4TquTdufRw4xk
         eyA6mr0QSE2wM6IRB8/kKltK/ZGvjfMqhZ3WT5T/F8LWFXywiK7A/1VJRL9yUNBNvKv6
         Fn1zkGdS6BjErEG2qJokky8MDiKIHCi5cK7PO47UGrh7tHCL9DOhr87KaWhu61x0Zz2r
         b0iw==
X-Gm-Message-State: APjAAAWfJPmcs7YcncTc2arrF2Y9YN23BBxvFUzaCJG9vOeiBKFzyS1s
        sxPU0r9nL/Ao7W/tPbMpNsEKvQsXOcw=
X-Google-Smtp-Source: APXvYqylR9wEf6FrTxyx5BCG+6gv32vj+l1qKMh00oXgRnNEoHpL0sBughYLDAYwnE+YYAfU+OE7kg==
X-Received: by 2002:ad4:5525:: with SMTP id ba5mr78716283qvb.117.1578351075300;
        Mon, 06 Jan 2020 14:51:15 -0800 (PST)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com. [209.85.222.182])
        by smtp.gmail.com with ESMTPSA id g9sm21305924qkm.9.2020.01.06.14.51.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:51:14 -0800 (PST)
Received: by mail-qk1-f182.google.com with SMTP id c17so41017221qkg.7
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 14:51:14 -0800 (PST)
X-Received: by 2002:a05:620a:2043:: with SMTP id d3mr85418653qka.279.1578351073659;
 Mon, 06 Jan 2020 14:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20200106224212.189763-1-briannorris@chromium.org>
In-Reply-To: <20200106224212.189763-1-briannorris@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 6 Jan 2020 14:51:02 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNN5=97nhN99rPneLGSQAmQ4ULS6Kim1oxCzKWNtPkWFw@mail.gmail.com>
Message-ID: <CA+ASDXNN5=97nhN99rPneLGSQAmQ4ULS6Kim1oxCzKWNtPkWFw@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
To:     linux-wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        stable <stable@vger.kernel.org>, huangwen <huangwenabc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 6, 2020 at 2:43 PM Brian Norris <briannorris@chromium.org> wrote:
>
> We called rcu_read_lock(), so we need to call rcu_read_unlock() before
> we return.
>
> Fixes: 3d94a4a8373b ("mwifiex: fix possible heap overflow in mwifiex_process_country_ie()")
> Cc: stable@vger.kernel.org
> Cc: huangwen <huangwenabc@gmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

I probably should have mentioned somewhere here: the bug is currently
in 5.5-rc and is being ported to -stable already (I'll try to head
that off). So this probably should have said [PATCH 5.5]. Sorry about
that.

Brian

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADFF19F813
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 16:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgDFOh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 10:37:26 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:33192 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgDFOh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 10:37:26 -0400
Received: by mail-vs1-f66.google.com with SMTP id y138so9953415vsy.0
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 07:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yhmI7JX+u9v8h9Wpp3hcwiv8u647Y8mr+tfnc8x2xSM=;
        b=eLWAn6gSwpbmDmc5tMCbHgqnct4Ffav79d8c3CXEJqHxwG+EiJ8jzeusmGfFjcycO3
         UHEi51LKt3Pya6eE0IPcw3FPzxc1Hrd8cjBY4BxBmkzjBm7FRbHZ+9I65Qs6npLUB8iu
         vMOylkFXvpmLM4vs6YsDYaLsMOhYHTXq+dh6x3zP8c7P6SZaHmzxJDxME4h/nyHsB80B
         4tiKD3jkUqS7YSEJK/7wT562CViqrslex4gZZIcFfrosMnzJDDeVvoYLJyFgZAtLNaax
         ncBRQyuCnDaOCWMGO0a2soLQEG1SIqn+ciR8s0nq/8lwYcodXtNOpdOJz8SBWjVBZURb
         dGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yhmI7JX+u9v8h9Wpp3hcwiv8u647Y8mr+tfnc8x2xSM=;
        b=hvJhqFa8BVDstkWPCAcCwi/JnoYYq1YZ68HlXp3b2mG1d6itNoXtl06gOKDd+L9Gca
         AQxjFojfWmicDe66zRYalopbdlDol/JPuLi5JuDN9i5ay5Jg4XFxyZdCGLU5uEUQAY10
         p+OA8G2qIPj2zAecdtUzxAyWJRC8saYu2Wpi4yDJhW8OlirXihUgfXpLOvsalMFmD0h/
         GaYkiKSzkCzjZU0QzsX6YaG3uYA3qx8Goc86r1jmLvvhg9LF2VVvqZhIK4OkrQteFtQj
         giJKeWZP6CjXdNOuTa5UZM5WiIiSZ0VYvKlsBK5E911MT4sX+wj4CsqSjse295PtOPO5
         CLqA==
X-Gm-Message-State: AGi0PuZZBZEIZR1UsGDdeuYtWcIZh1mFA0FVOr3ggMM/FyO3GBFetptb
        8Mc7mrGzr3UI5LLrNJwY2SGudXfW0SVDrhjqqf+PhI0N2YE=
X-Google-Smtp-Source: APiQypL6kZKfeyJxjLFq1mmuv0o9XOXpFUIIqtW3L5V9SPpk0X2z6EB9eJ9k/W05FkvxUQSYJXtK+WGFYhlq3zasZ/4=
X-Received: by 2002:a67:e44a:: with SMTP id n10mr15060963vsm.178.1586183843235;
 Mon, 06 Apr 2020 07:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200406114821.10949-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200406114821.10949-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Mon, 6 Apr 2020 15:36:56 +0100
Message-ID: <CAM0jSHPMALu5LcGLJBw+UYoZjVB23mQv94H2gsp0otSx9=ewHg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/gem: Flush all the reloc_gpu batch
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Apr 2020 at 12:48, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> __i915_gem_object_flush_map() takes a byte range, so feed it the written
> bytes and do not mistake the u32 index as bytes!
>
> Fixes: a679f58d0510 ("drm/i915: Flush pages on acquisition")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matthew Auld <matthew.william.auld@gmail.com>
> Cc: <stable@vger.kernel.org> # v5.2+

Yikes.
Reviewed-by: Matthew Auld <matthew.william.auld@gmail.com>

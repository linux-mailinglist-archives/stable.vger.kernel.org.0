Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69A8BC3E3
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 10:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406257AbfIXIKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 04:10:14 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:33133 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405392AbfIXIKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 04:10:13 -0400
Received: by mail-vs1-f67.google.com with SMTP id p13so739490vso.0
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 01:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zk1XPSy8x8C5XqXPXdU1bsBIXPn9nQq8Z31r0wdKisI=;
        b=jRHMe2MR+0Vu3GtYqkB97UZb9wTysGfjqVvfy+agPpkvmHeLD+Qw5sH5kWLzQwSGw5
         1xLff2FbPVQw3IkY281+Z536cjkFPmPdOAO1I4hDudArOlhcwMOqdpr1cvj9bm7Z5JTP
         RdZeEq13b6WoGFjDToY35EUgAIzWf5dpsVh1kKZiCShf0yKikHxadrzibQWkgIe63tUM
         qxYUiNAIKeXXgjqimOQeVmzGxSVbAPClTm2XjP7rplMMOsHIm3Xduo1ClLGlE6vIvumg
         jxLtWqk3+lKkRAnj2DY8Eh66S3Eezf7CzApVfhOOBsP09WqefQQ7aQTB/KrFSmQHtnOz
         gIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zk1XPSy8x8C5XqXPXdU1bsBIXPn9nQq8Z31r0wdKisI=;
        b=bMpek8KtGn7w/XXfLfmKdZ1l0bg7LIuEl3rCuQ4AWI0E88Dbp62AhuX4BingkzLKjX
         IVNfgZuR6m1ZUZvkNlDIgNt8n1PC1VWylIZ1J/EpJImQ/iBKHOYnV38FkJmT5CQ1c/zO
         GtjUCGQzp6/dLzHBBHl17h+iG3b1ve28ZBGKd1XCFAN31sQBNQVtlQmysA7xIoxou5+E
         3MQniwHjBHXb4upEmJeOuahcWSB0EJK/02D3QUPmdbLz7xP0Pxz1rNiIoifU3OKLQ3r6
         qeb57OsVHHqyg3Fm2V7F3mzLKDSTSMAWaKh0v9r0pcA8FJwU+1EYKrCAeIBj04OGQeAG
         AwTQ==
X-Gm-Message-State: APjAAAUM+cChxP7KSQykc9otkb8LBA3/wTeZRTfPJHRjlMXqitwr31bA
        t+lQ+a+6o3Dn/o4d2OSRWYxsvppNj5lCPQenhX0=
X-Google-Smtp-Source: APXvYqwgUKx39Qpiv8p6U42BJ2LCbpe8Er5dGiKZmUAS2V/843lVkZw49zM3QqanX4vYn6mm18Sg3a5Kxi6VA3SbPjE=
X-Received: by 2002:a67:c018:: with SMTP id v24mr55001vsi.23.1569312612878;
 Tue, 24 Sep 2019 01:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190920121821.7223-1-chris@chris-wilson.co.uk>
In-Reply-To: <20190920121821.7223-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Tue, 24 Sep 2019 09:09:48 +0100
Message-ID: <CAM0jSHO3ah0Sv+fumOBp1qsaYXbz+dnK_4KHjwiHk-1C0egKAA@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Mark contents as dirty on a write fault
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Sep 2019 at 13:18, Chris Wilson <chris@chris-wilson.co.uk> wrote=
:
>
> Since dropping the set-to-gtt-domain in commit a679f58d0510 ("drm/i915:
> Flush pages on acquisition"), we no longer mark the contents as dirty on
> a write fault. This has the issue of us then not marking the pages as
> dirty on releasing the buffer, which means the contents are not written
> out to the swap device (should we ever pick that buffer as a victim).
> Notably, this is visible in the dumb buffer interface used for cursors.
> Having updated the cursor contents via mmap, and swapped away, if the
> shrinker should evict the old cursor, upon next reuse, the cursor would
> be invisible.
>
> E.g. echo 80 > /proc/sys/kernel/sysrq ; echo f > /proc/sysrq-trigger
>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D111541
> Fixes: a679f58d0510 ("drm/i915: Flush pages on acquisition")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matthew Auld <matthew.william.auld@gmail.com>
> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Matthew Auld <matthew.william.auld@gmail.com>

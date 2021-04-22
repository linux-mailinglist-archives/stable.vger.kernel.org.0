Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F90B3686B3
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 20:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbhDVSoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 14:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236947AbhDVSoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 14:44:04 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84552C06174A
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 11:43:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id cq11so11063883edb.0
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 11:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W4zRmevMmO+RxeEOnDi2m4bOd5XWorVeAFFg7oJTVQo=;
        b=X65bVou+S+K6W5EKmTGk+6RW98hePTJHOLRgyualMVg6FS3Tb0HgsfikGYm6KnmIKE
         LzhoMNb45tnkE9GwrZQf1rvDWkQx8fNOcf/T59ktOdzXqYe2zZTEYyuzyCJ8zb/RmRNV
         mWYlpTQ+6IW4pbEwi68XpfEFf/RiH2k7d6WE/63VEeOgr3WL57GacBW47grm9EYmxYZs
         cXjS/Q9oIo1W7XBoldvwmXABY/KzVZG+2ELGpvvdSvO3EvsZ9ZoY2M//syDEEwajm7vN
         DZGqVoyi/o8RoS7ZIhVF8EGYJ1l3btKAvBNnXvFrLVrWMXZHlBZrKAr0/z0VZqstmUQO
         E/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W4zRmevMmO+RxeEOnDi2m4bOd5XWorVeAFFg7oJTVQo=;
        b=Kl/18754CKLJMQcq4H9aNiOBosgrtfmpUvHr/i6yCLE4z1bqGBqBFSOL834xYAD5dh
         U1j8zW+A+K4KuGa9OugrNoDxWgp++Dd7a6ClBYX2y81iSaZ7maZEEoknsAaiwWbz8Tji
         IjIv4DBWTdQf+vd0Q2Qiew19NXdp07EobvAU2tpJYu1fGLOZxhKuxZ7PC9B/uoDgBJOe
         F7V8CSHfK1svf85Tcoc+/IADwxwohOAoUXYyMEcezV0xQGZhK6LM3rSPJXYnWO+F/a48
         ZQZ/bSKVTSi2Pdfz33aG197u6l3KiCn6QjIwga5RFRIYxHTRvk+JyS3W6+0hjj361hJP
         I7uA==
X-Gm-Message-State: AOAM531ftIwn+IhP4PBH+J0z+BvZBCzOA/lspkmOPdJb5rMJYilblNKN
        XKCvM19K9pLwLo97DXhPNnxPE3O4dUXerKfGptk=
X-Google-Smtp-Source: ABdhPJzqwjuAKmjtiVhuxwFcxMrLFQgrMt7SJNBZPMYeCghom7DNGIw5v5+74kNdkEYQM/pAw3/c9oge4i7U0DJUL+c=
X-Received: by 2002:aa7:da41:: with SMTP id w1mr5777773eds.254.1619117008224;
 Thu, 22 Apr 2021 11:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210422183733.918-1-linux.amoon@gmail.com>
In-Reply-To: <20210422183733.918-1-linux.amoon@gmail.com>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Fri, 23 Apr 2021 00:13:17 +0530
Message-ID: <CANAwSgR9Crg9TogjLgfQHCketaNFVxopqU2FGQutwPoBVyJnuw@mail.gmail.com>
Subject: Re: [PATCH] dm verity fec: fix misaligned RS roots IO
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     Jaegeuk Kim <jaegeuk@google.com>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

On Fri, 23 Apr 2021 at 00:07, Anand Moon <linux.amoon@gmail.com> wrote:
>
> From: Jaegeuk Kim <jaegeuk@google.com>
>
> commit df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to
> block size") introduced the possibility for misaligned roots IO
> relative to the underlying device's logical block size. E.g. Android's
> default RS roots=2 results in dm_bufio->block_size=1024, which causes
> the following EIO if the logical block size of the device is 4096,
> given v->data_dev_block_bits=12:
>

Oops. Please ignore this email, I was just testing my git send-email setting.

Thanks
-Anand

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C187A3B9A3
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 18:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfFJQhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 12:37:47 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35489 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfFJQhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 12:37:47 -0400
Received: by mail-yw1-f68.google.com with SMTP id k128so4033795ywf.2
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 09:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aOFiUdkOMHFPP1JFHyd9EZSoZ9ZJzLLs7VhME5W52fc=;
        b=lm3SKqLnVenu9yDGmq4xiYeKEOnPe7WdWjMUs56uuFR9gYY9/HfMqjLFEoegiob0UJ
         T+MMTWNA2GABXeczdfvD8or1A+votIr9dNJOJEFv+fr6n5hySJLhtnwbBFNZ7w2Sd3oO
         TINt941lq91TfXYD8A0RN8qww7/1Ob4+ZtKwM8iG6eyL/fopsAuBdqcvCdWI8BLFfYvG
         Eaok2iWfNJMpjjfyZzONIiTqSkSuouGzNIZiIgkvrxSaBbq0vhFLzvQa4uih8HnmF16J
         r0U6SbEXoKIUyzLznXcnmHXG9tT+QRqvwQYitXGljMXESDcLKsmO11lLI8QNc0Z33rfT
         RsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aOFiUdkOMHFPP1JFHyd9EZSoZ9ZJzLLs7VhME5W52fc=;
        b=VPTEON8dwX0eYlZatBO8Ev0e7DV6JVfNt6m8Jy2SZLYUbkSbOMRjguNjOU/CzYOFtk
         7w4mGLQvohNG0ae1/uMVwhi3Ht/X4FX6bI264kMGq1eLuu0AIQ4fFtKgy0PqATRObAmU
         BCgV7JvWDJprnkc81nqZa5A/NxB7cRKiKA79pryolCkQz8FXpHmnUkK6jmJEhIvkUXaY
         jF/KgMmtwbl/EhyoL3bGcLRXn8cSdY66k00BFSSgRvmEujA2jdFd9v4GmUwBEHe5IqS9
         L3ZEE516lxiI+1qs7eAS9IvcFfLNCg1SdMfbNd+tETcYMJ9oB0Jm9hfwjd2QAs9V5Qn7
         3cQg==
X-Gm-Message-State: APjAAAWGr8aZNOP0rGYcbazF/qKXOH0Rsgud3EaDjq6lbWk2rA1MWQzK
        FNCaSVKs3Abp+qrL+K00tWfWLeYmce8iOP97v2Q=
X-Google-Smtp-Source: APXvYqzzVT5Jp1vw1jd7xsoHIqE40MSGecKHV1yp4J9RhnXtnlwTRLum+tg0ePr0ZWyGRChknryM200lIK/6qWS6tnU=
X-Received: by 2002:a81:374c:: with SMTP id e73mr27877500ywa.379.1560184666281;
 Mon, 10 Jun 2019 09:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190608135717.8472-2-amir73il@gmail.com> <20190610151836.5E2A3207E0@mail.kernel.org>
In-Reply-To: <20190610151836.5E2A3207E0@mail.kernel.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 10 Jun 2019 19:37:35 +0300
Message-ID: <CAOQ4uxiFKamOUnJNo9x16F4ex0KF_Wgstph-BTH7-KK5xM9usw@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: replace i_readcount with a biased i_count
To:     Sasha Levin <sashal@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 6:18 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.19+
>
> The bot has tested the following trees: v5.1.7, v4.19.48.
>
> v5.1.7: Failed to apply! Possible dependencies:
>     fdb0da89f4ba ("new inode method: ->free_inode()")
>
> v4.19.48: Failed to apply! Possible dependencies:
>     1a16dbaf798c ("Document d_splice_alias() calling conventions for ->lookup() users.")
>     fdb0da89f4ba ("new inode method: ->free_inode()")
>
>
> How should we proceed with this patch?
>

I will take care of backporting once patch is merged.

Thanks,
Amir.

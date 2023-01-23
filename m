Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BC56776E4
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 09:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjAWI7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 03:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjAWI7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 03:59:09 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AE91CF5C
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 00:59:01 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id z194so5288375iof.10
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 00:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kF1LzxMibzarj0qOT+2x1suBEvLt2gV5iFkGqZc0IcU=;
        b=aODwONGw56OR7MEKA9tfyrteZM5lX/tEWnvjuEvBdCs68sJnW+8BxRffETOe/V4oLh
         3/ckkFlKt+uZ1DhAAOM00770klu640X3W8WOE4nAhkxfxezSFlPh3GxGbgfTsrKvVzeQ
         S14UQqdolgSI6trhpzVAGtYeKHSMIxTkp+HhXnNQ/gdyluhQYzc7hMxZAvLXtaAxf8iN
         PxEEvRXpEw6KB/5sXWLJgkFZZaVURmPbM4CZQ5dxWUACr9b3F/IlQggNroLpm5URfEfY
         do7uQLus7UzVZ9ZNFLsqKWQ2Xqerd8cvKylkQBe1TkOJVzAt2qoylXTBpVWksOfXzjoq
         uMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kF1LzxMibzarj0qOT+2x1suBEvLt2gV5iFkGqZc0IcU=;
        b=4BfFjDC9JNQ9VWCzbW9a+qYRv9DaUuLrQuRGCAMRu/f2zFa7vtBSxq80vYUmm1bUzG
         Ff4DtC6R0Cj6n2gnQIFfc0NHJbzjXG9Qjh1+kQhiIueC6pdvP5NRVyttBai3vdfHk370
         WikRFEu4Egekj4loC6JB4lJhrvzROmt1+RFStrWRjpag25JOmvdBESiXtAzpOXN9pByC
         zHyEFOuBmfg1BZ1HBlx7sXnhSARsRpznYq+teruuZ+YCnOWwQVuINMOIYyQ4zLYXMiiE
         vDzak7Eg45vjxYZwEq3d2W7E/TlpIomW+nLmkf+QGJEUl3+alTSDx8mmn5FiEiHmlRdp
         eRjA==
X-Gm-Message-State: AFqh2kq8q9UkqPpa3W6DULIU3EOLcXQCLArKSywWVGCdQQAu48XUYzzk
        rhEoBVdbfR7rqNtsqd95bzOSQaJZTUiWtbtb/wI0nw==
X-Google-Smtp-Source: AMrXdXt2STLbSQ8wjfk7JX7AhPTudhsedLDcfWFEyy72Q7LGj3Vt5fSEPI02KOgjjOx4W+LQe+pUNemBf+kQCLXdjNI=
X-Received: by 2002:a05:6638:279b:b0:3a5:93e:989a with SMTP id
 dl27-20020a056638279b00b003a5093e989amr2274341jab.319.1674464340454; Mon, 23
 Jan 2023 00:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20230123070414.138052-1-ebiggers@kernel.org>
In-Reply-To: <20230123070414.138052-1-ebiggers@kernel.org>
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 23 Jan 2023 09:58:22 +0100
Message-ID: <CAG_fn=VNjkRMozdcQUSMTHvMQ26SG45oisxamJbEVrg2m41ngg@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix information leak in f2fs_move_inline_dirents()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 8:05 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> When converting an inline directory to a regular one, f2fs is leaking
> uninitialized memory to disk because it doesn't initialize the entire
> directory block.  Fix this by zero-initializing the block.
>
> This bug was introduced by commit 4ec17d688d74 ("f2fs: avoid unneeded
> initializing when converting inline dentry"), which didn't consider the
> security implications of leaking uninitialized memory to disk.
>
> This was found by running xfstest generic/435 on a KMSAN-enabled kernel.

Out of curiosity, did you add any extra annotations to detect uninit
writes to the disk?

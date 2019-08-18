Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B131D914CE
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 06:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfHRE5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 00:57:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54161 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfHRE5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 00:57:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id 10so250650wmp.3
        for <stable@vger.kernel.org>; Sat, 17 Aug 2019 21:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMlJ7HQ8C7qGGveXtWMH/Y0KR29thbWoS7aKR/gGLOM=;
        b=bDi51yk/IyeVnnRD1C+8FDQsw0CVaAWiLBw+BO7qs/iSGcnfIuvZr40vw5nhp+xkuH
         t5zEZ7VN1NIOYwEkhSdrM72ADBAib1y2STmCkus/H+lnq++FYbKiP/V16TBALRmKAuI+
         TF9umtPZUKW4AxxVdEdWopvAt9xe1f6NhoX6iUfksfmQAas/pp72/wbRRrycpbPF+XsE
         Kt7wEarTwcfByrf7U2ypzHJ+dct1q0jFmA/7Pw5ZVOFNlzUUXT3pxtBK5DL8Yy4ohcH6
         +SDwdMzUFfLOmVK47FxQw+PtfDsUDpkgZkPbNvA6nyvnCHAJGihOS52kwpj0Xb8l649v
         RWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMlJ7HQ8C7qGGveXtWMH/Y0KR29thbWoS7aKR/gGLOM=;
        b=ezjmKAt5usDDYlTCKw0OWqoaPQcZWvJuyon6dgUN9bopzzhXZPgWM7Fg5+iSqoqi5z
         SZ+jg2xCCQhSAtvLpWAVVDyASt+AI6XZb5nvkNxE9FCqlMSJrhqgt/upmuool2vRbosC
         HlqOjOLTJV8KlWZ2LHTFdfM6rxSf6h7EujdpwXrfadUym5dt1CVJ84+o5CRiF2xw4FrH
         YQOGbw7EAv2vdZ+hVxTere4XddpfI0j6OpYTFfSDtumTh/nTzzbq0P5L9YfrVCGKvNGl
         caKNH//US2dmhWENH5976Ncs8C63U0OpCg3N2fJ1lZ3mQ/mYf8fw45zQRoTJl1kl34a6
         Ogiw==
X-Gm-Message-State: APjAAAX86naq+LOe+nQ1JcJ4bEyk7v42JuV++1ux4gItwc5ZrNjPRAq6
        5kcj+xwF7SPFO0mrgh8m9EDzI/12kO+pXaKdIe2lH4jDSP4=
X-Google-Smtp-Source: APXvYqyVHuI+5Mh3NE7Va4jBTtHYPX7MSVQZhflXHvuQU2ZoXd5YNfjSl1MV6nfwfzFtJiXJMOGAnSEpxj6+oCdkK5k=
X-Received: by 2002:a7b:c091:: with SMTP id r17mr12822060wmh.74.1566104272127;
 Sat, 17 Aug 2019 21:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <1565795351-10543-1-git-send-email-rhmcruiser@gmail.com> <20190818043108.GZ1131@ZenIV.linux.org.uk>
In-Reply-To: <20190818043108.GZ1131@ZenIV.linux.org.uk>
From:   Ron Enfield <rhmcruiser@gmail.com>
Date:   Sun, 18 Aug 2019 14:57:40 +1000
Message-ID: <CAH7KYae57vzG+YrZ3X2WP8rovK_vVBxqUexm4dnr=8Gn4MTHNQ@mail.gmail.com>
Subject: Re: [PATCH] fs: buffer: Check to avoid NULL pointer dereference of
 returned buffer_head for a private page
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 2:31 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Aug 15, 2019 at 01:09:11AM +1000, Monthero Ronald wrote:
> > The patch checks for this condition of NULL pointer for the buffer_head returned from page_buffers()
> > and also a check placed within the list traversal loop for next buffer_head structs.
> >
> > crash scenario:
> > The buffer_head returned from page_buffers() is not checked in block_invalidatepage_range function.
> > The struct buffer_head* pointer returned by page_buffers(page) was 0x0, although this page had its
> > private flag PG_private bit set and was expected to have buffer_head structs attached.The NULL pointer
> > buffer_head was dereferenced in block_invalidatepage_range function at bh->b_size, where bh returned by
> > page_buffers(page) was 0x0.
> >
> > The stack frames were  truncate_inode_page() => do_invalidatepage_range() => xfs_vm_invalidatepage() =>
> >           [exception RIP: block_invalidatepage_range+132]
> >
> > The inode for truncate in this case was valid and had  proper inode.i_state = 0x20 - FREEING and had
> > a valid mapped address space to xfs. And the struct page in context of block_invalidatepage_range()
> > had its page flag PG_private set but the page.private was 0x0. So page_buffers(page) returned 0x0
> > and hence the crash.
> > This patch performs NULL pointer check for returned buffer_head. Applies to 3.16 and later kernels.
>
> ... and adds BUG_ON() for that.  The only real difference from an oops is
> that it's a bit easier to recognize.  Which may or may not be a good
> debugging strategy, but what's the point of having it in -stable?  Or
> anywhere other than the build on the boxen you are testing on...
>
> It doesn't fix the underlying bug.  It doesn't tell where the problem
> is.  It's definitely *not* a way to fix any bugs.  And while we
> are at it, the stuff in -stable ought to be backports from mainline.
>
> Can you reproduce your crashes on mainline?

No I don't have a reproducer.  This was an abrupt crash, where the
page has its private flag set but the buffer_head returned by
page_buffers( ) was 0x0. Having the BUG_ON check for the returned
buffer_head from page_buffers( ) would help to to see the BUG line
readily than to analyze the vmcore  and check the fault condition why
kernel panicked. Two cents here, but open to thoughts.
( This crash to reproduce is not trivial, nevertheless will attempt to
check if there are any mm tests or page mapping tests that can induce
this condition )

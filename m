Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B964791491
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 06:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfHRE1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 00:27:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55740 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfHRE1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 00:27:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id f72so224938wmf.5
        for <stable@vger.kernel.org>; Sat, 17 Aug 2019 21:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ryTbpdJDft5EQ+Gxu/uIV9KK2dD149mOisKOYVJqQnw=;
        b=hBSxtmSSd/vNPOPwceZ77f7nqB3HH/jyxppabSZTMo5of9RR21LN9Fbb05Q5Jy2Xs1
         LmArVQUR8tboxiJTXR3rykWq3Mft1RX+4fTSM+xBmOCcw5WnuUpo5stpC56YZbQkr3G+
         EkfcJR9eMD9UaYGQtDZPEJgBDVFL8/2+0KsJAN2O4IePWvFfbsbvCliObNDfpr+tzcDG
         fJ/Ybamv/ulr0xuVb1DVuBLS5fhHKa8k1fZI1DzDgABFHs5zEC45APLykstm846OiZbb
         wMXLsgY9oSk6yqG/AV1HDKZ5vth28FZspJmliGIZeMpd8BxGo5mNmmhKxk6kl35Zu+j6
         32ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ryTbpdJDft5EQ+Gxu/uIV9KK2dD149mOisKOYVJqQnw=;
        b=hSwdxvP2MoQTfnzm5z2cYPr/AYVOkY4m8eQj+Ek017+GEmv4yyE5PzVsWVdFY4hYYb
         G8hjAncK14e5cKYw2JM8Uu0PEnSP5UEhlXB9PWz3t/95K5S8JbtJWY0KHT+Ol5haSkRs
         EE3HU/YMiXmqXfteu+7F5+PrXrM2errvVkB54Sxk7JyeZI9aYCvqA/RiTyGiMPIrvJAd
         V7lWURZPZCqk7qGSM8PL9WYXixWGbqK1jhc6pIilw+Rx/9CeL4EkQFfPA0lA7XkofW0p
         P2kFQiIZeGQcWa8i+NR3WpNlvYXBxAXDyHvN9t2st5f8a8r+9Gy7tKezLHiw+l0u7z9I
         ioRA==
X-Gm-Message-State: APjAAAXopvNT7qn2o9AxI1WhcAO41RCZGuiXZy6CfU/Hn0WJMjQbsEQ7
        WdGrrtsR3J/QMyt7WNIrAGqWrXtFot7u7iF+muOZuN5A6GA=
X-Google-Smtp-Source: APXvYqyb/73AULOeiv5okZb564qeAWtktzxlGk90OGJsHcAIRehCazVGhWD4+v4PjmTBWXx1n+07M3kfhZfnLOilRss=
X-Received: by 2002:a05:600c:254a:: with SMTP id e10mr14482372wma.113.1566102460474;
 Sat, 17 Aug 2019 21:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <1565795351-10543-1-git-send-email-rhmcruiser@gmail.com> <20190814160259.GA11018@kroah.com>
In-Reply-To: <20190814160259.GA11018@kroah.com>
From:   Ron Enfield <rhmcruiser@gmail.com>
Date:   Sun, 18 Aug 2019 14:27:29 +1000
Message-ID: <CAH7KYadZBciOyDzXkZU=iXPNNx-vtj=BxjSOkRyQeO59iddqng@mail.gmail.com>
Subject: Re: [PATCH] fs: buffer: Check to avoid NULL pointer dereference of
 returned buffer_head for a private page
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     viro@zeniv.linux.org.uk, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 2:03 AM Greg KH <gregkh@linuxfoundation.org> wrote:
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
> >
> > Signed-off-by: Monthero Ronald <rhmcruiser@gmail.com>
> > ---
> >  fs/buffer.c | 2 ++
> >  1 file changed, 2 insertions(+)
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

Hi Greg,
Thanks for feedback . Sorry I might have missed some steps.  I am
checking through the patch list requirements.
I know there could be a couple of issue but  if you or Viro to please clarify.

Please clarify.
- I believe I should only email the maintainer of fs and not email the
list stable@vger.kernel.org at this stage of submission.
  ( I ran  the get-maintainer.pl script it showed Viro as maintainer
for fs/buffer.c , apology if not )
- The patch is around 47 lines including the comments, I assume thats okay.
    ( I have not included the crashed bt, page, buffer_head and inode
details just to keep it short )

- The crash occurred on 3.16 kernel but the buffer.c:
block_invalidatepage_range( ) code path  in later kernels of 4.xx are
also same as this.
   So it may apply to later kernels too.  Please let me know if this
is not the right way to do it.
Thanks for your help and time
Ron

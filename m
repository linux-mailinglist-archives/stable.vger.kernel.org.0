Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0144810464F
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 23:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfKTWKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 17:10:51 -0500
Received: from imap1.codethink.co.uk ([176.9.8.82]:36829 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTWKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 17:10:51 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iXYBR-0005dI-GG; Wed, 20 Nov 2019 22:10:45 +0000
Message-ID: <a187cb75cc15ba8ee4a7b652fae8317cb9b03020.camel@codethink.co.uk>
Subject: Re: [Y2038] [PATCH 6/8] lp: fix sparc64 LPSETTIMEOUT ioctl
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Bamvor Jian Zhang <bamv2005@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 20 Nov 2019 22:10:44 +0000
In-Reply-To: <CAK8P3a3U0GWCyU9WOnrGQ2tqnHoyAbJ=HdYJGfTHuxVqcww0wg@mail.gmail.com>
References: <20191108203435.112759-1-arnd@arndb.de>
         <20191108203435.112759-7-arnd@arndb.de>
         <41baf20a190039443cb2b82aea0c2a8ec872cfed.camel@codethink.co.uk>
         <CAK8P3a3U0GWCyU9WOnrGQ2tqnHoyAbJ=HdYJGfTHuxVqcww0wg@mail.gmail.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-11-20 at 20:46 +0100, Arnd Bergmann wrote:
> On Wed, Nov 20, 2019 at 8:27 PM Ben Hutchings
> <ben.hutchings@codethink.co.uk> wrote:
> > On Fri, 2019-11-08 at 21:34 +0100, Arnd Bergmann wrote:
> > > The layout of struct timeval is different on sparc64 from
> > > anything else, and the patch I did long ago failed to take
> > > this into account.
> > > 
> > > Change it now to handle sparc64 user space correctly again.
> > > 
> > > Quite likely nobody cares about parallel ports on sparc64,
> > > but there is no reason not to fix it.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 9a450484089d ("lp: support 64-bit time_t user space")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  drivers/char/lp.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/char/lp.c b/drivers/char/lp.c
> > > index 7c9269e3477a..bd95aba1f9fe 100644
> > > --- a/drivers/char/lp.c
> > > +++ b/drivers/char/lp.c
> > > @@ -713,6 +713,10 @@ static int lp_set_timeout64(unsigned int minor, void __user *arg)
> > >       if (copy_from_user(karg, arg, sizeof(karg)))
> > >               return -EFAULT;
> > > 
> > > +     /* sparc64 suseconds_t is 32-bit only */
> > > +     if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
> > > +             karg[1] >>= 32;
> > > +
> > >       return lp_set_timeout(minor, karg[0], karg[1]);
> > >  }
> > > 
> > 
> > It seems like it would make way more sense to use __kernel_old_timeval.
> 
> Right, that would work. I tried to keep the patch small here, changing
> it to __kernel_old_timeval would require make it all more complicated
> since it would still need to check some conditional to tell the difference
> between sparc32 and sparc64.

Right.

> I think this patch (relative to the version I posted) would work the same:
> 
> diff --git a/drivers/char/lp.c b/drivers/char/lp.c
> index bd95aba1f9fe..86994421ee97 100644
> --- a/drivers/char/lp.c
> +++ b/drivers/char/lp.c
> @@ -713,13 +713,19 @@ static int lp_set_timeout64(unsigned int minor,
> void __user *arg)
>         if (copy_from_user(karg, arg, sizeof(karg)))
>                 return -EFAULT;
> 
> -       /* sparc64 suseconds_t is 32-bit only */
> -       if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
> -               karg[1] >>= 32;
> -
>         return lp_set_timeout(minor, karg[0], karg[1]);
>  }
> 
> +static int lp_set_timeout(unsigned int minor, void __user *arg)

That function name is already used!  Maybe this should be
lp_set_timeout_old()?

> +{
> +       __kernel_old_timeval tv;
> +
> +       if (copy_from_user(tv, arg, sizeof(karg)))
> +               return -EFAULT;
> +
> +       return lp_set_timeout(minor, tv->tv_sec, tv->tv_usec);
> +}
> +
>  static long lp_ioctl(struct file *file, unsigned int cmd,
>                         unsigned long arg)
>  {
> @@ -730,11 +736,8 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
>         mutex_lock(&lp_mutex);
>         switch (cmd) {
>         case LPSETTIMEOUT_OLD:
> -               if (BITS_PER_LONG == 32) {
> -                       ret = lp_set_timeout32(minor, (void __user *)arg);
> -                       break;
> -               }
> -               /* fall through - for 64-bit */
> +               ret = lp_set_timeout(minor, (void __user *)arg);
> +               break;
>         case LPSETTIMEOUT_NEW:
>                 ret = lp_set_timeout64(minor, (void __user *)arg);
>                 break;
> 
> Do you like that better?

Yes.  Aside from the duplicate function name, it looks correct and
cleaner than the current version.

> One difference here is the handling of
> LPSETTIMEOUT_NEW on sparc64, which would continue to use
> the 64/64 layout rather than the 64/32/pad layout, but that should
> be ok, since sparc64 user space using ppdev (if any exists)
> would use LPSETTIMEOUT_OLD, not LPSETTIMEOUT_NEW.

Right, that's a little weird but appears to be consistent with "new"
socket timestamps.

> > Then you don't have to explicitly handle the sparc64 oddity.
> > 
> > As it is, this still over-reads from user-space which might result in a
> > spurious -EFAULT.
> 
> I think you got this wrong: sparc64 like most architectures naturally
> aligns 64-bit members, so 'struct timeval' still uses 16 bytes including
> the four padding bytes at the end, it just has the nanoseconds in
> a different position from all other big-endian architectures.

Oh of course, yes.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


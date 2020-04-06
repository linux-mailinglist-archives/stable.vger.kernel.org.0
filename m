Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BDB19F2EE
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 11:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgDFJv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 05:51:57 -0400
Received: from gofer.mess.org ([88.97.38.141]:43997 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgDFJv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 05:51:57 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 2D48FC6450; Mon,  6 Apr 2020 10:51:55 +0100 (BST)
Date:   Mon, 6 Apr 2020 10:51:55 +0100
From:   Sean Young <sean@mess.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-media@vger.kernel.org,
        Takashi Kanamaru <neuralassembly@gmail.com>
Subject: Re: [PATCH] media: rc: IR signal for Panasonic air conditioner too
 long sequences is too small
Message-ID: <20200406095154.GA19905@gofer.mess.org>
References: <CAKL8oB_qPGVXd3MCj=f1Lzh02ifGzYTS2YAD77s2MY2LAnc+1A@mail.gmail.com>
 <20190612150132.iemhbronjjaonpt2@gofer.mess.org>
 <CAKL8oB-KxsGxHAUac7sYBf-Gs4UkAPVkXg75LwwVbut9GkQ-sQ@mail.gmail.com>
 <20190613084926.bjxv2vdkp3qqpkuu@gofer.mess.org>
 <CAKL8oB-_=07iOBUfiuD4sj_nuL2HURt_Ej4m9EFCL7yNzLYXjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKL8oB-_=07iOBUfiuD4sj_nuL2HURt_Ej4m9EFCL7yNzLYXjg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable team, Greg,

On Mon, Apr 06, 2020 at 06:06:29PM +0900, Takashi Kanamaru wrote:
> Dear Sean Young and all,
> 
> In the last year, a change of the value of LIRCBUF_SIZE
> from 256 to 1024 was committed to the master branch at the time,
> and the new value can be used in the kernel 5.3 or later.
> 
> https://github.com/torvalds/linux/commit/5c4c8b4a999019f19e770cb55cbacb89c95897bd#diff-3b71f634ae88214ee31a1b6c90f7df5c
> 
> This change of LIRCBUF_SIZE was proposed
> in order to treat long IR sequences of remote controllers
> on Raspberry Pi.
> 
> However, Raspberry Pi now uses kernel 4.19,
> so the new value cannot be used.
> 
> Can you backport the above commit
> to the older kernels, i.e.,
> 4.19, 4.20, 5.0, 5.1, and 5.2?

I'd like to propose this commit for the stable tree, from kernel 4.16 to
5.2. It has been in the tree from v5.3 onwards and no regressions have
been found.

Thank you,

Sean

> Sincerely,
> 
> Takashi Kanamaru
> 
> 2019年6月13日(木) 17:49 Sean Young <sean@mess.org>:
> >
> > The IR signal to control the Panasonic ACXA75C00600 air conditioner has
> > 439 pulse/spaces. Increase limit to make it possible to transmit signal.
> >
> > Reported-by: Takashi Kanamaru <neuralassembly@gmail.com>
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/lirc_dev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> > index 10830605c734..f078f8a3aec8 100644
> > --- a/drivers/media/rc/lirc_dev.c
> > +++ b/drivers/media/rc/lirc_dev.c
> > @@ -19,7 +19,7 @@
> >  #include "rc-core-priv.h"
> >  #include <uapi/linux/lirc.h>
> >
> > -#define LIRCBUF_SIZE   256
> > +#define LIRCBUF_SIZE   1024
> >
> >  static dev_t lirc_base_dev;
> >
> > --
> > 2.20.1
> >

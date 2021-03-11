Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9710337084
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 11:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhCKKwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 05:52:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54171 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhCKKwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 05:52:24 -0500
Received: from [179.93.213.27] (helo=mussarela)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1lKIvR-0008VO-Pm; Thu, 11 Mar 2021 10:52:18 +0000
Date:   Thu, 11 Mar 2021 07:52:10 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Jim Lin <jilin@nvidia.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4] usb: gadget: configfs: Fix KASAN use-after-free
Message-ID: <20210311105210.GS10958@mussarela>
References: <1484647168-30135-1-git-send-email-jilin@nvidia.com>
 <1615444961-13376-1-git-send-email-macpaul.lin@mediatek.com>
 <1615445632.13420.2.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615445632.13420.2.camel@mtkswgap22>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 02:53:52PM +0800, Macpaul Lin wrote:
> On Thu, 2021-03-11 at 14:42 +0800, Macpaul Lin wrote:
> > From: Jim Lin <jilin@nvidia.com>
> > 
> > When gadget is disconnected, running sequence is like this.
> > . composite_disconnect
> > . Call trace:
> >   usb_string_copy+0xd0/0x128
> >   gadget_config_name_configuration_store+0x4
> >   gadget_config_name_attr_store+0x40/0x50
> >   configfs_write_file+0x198/0x1f4
> >   vfs_write+0x100/0x220
> >   SyS_write+0x58/0xa8
> > . configfs_composite_unbind
> > . configfs_composite_bind
> > 
> > In configfs_composite_bind, it has
> > "cn->strings.s = cn->configuration;"
> > 
> > When usb_string_copy is invoked. it would
> > allocate memory, copy input string, release previous pointed memory space,
> > and use new allocated memory.
> > 
> > When gadget is connected, host sends down request to get information.
> > Call trace:
> >   usb_gadget_get_string+0xec/0x168
> >   lookup_string+0x64/0x98
> >   composite_setup+0xa34/0x1ee8
> > 
> > If gadget is disconnected and connected quickly, in the failed case,
> > cn->configuration memory has been released by usb_string_copy kfree but
> > configfs_composite_bind hasn't been run in time to assign new allocated
> > "cn->configuration" pointer to "cn->strings.s".
> > 
> > When "strlen(s->s) of usb_gadget_get_string is being executed, the dangling
> > memory is accessed, "BUG: KASAN: use-after-free" error occurs.
> > 
> > Signed-off-by: Jim Lin <jilin@nvidia.com>
> > Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Changes in v2:
> > Changes in v3:
> >  - Change commit description
> > Changes in v4:
> >  - Fix build error and adapt patch to kernel-5.12-rc1.
> >    Replace definition "MAX_USB_STRING_WITH_NULL_LEN" with
> >    "USB_MAX_STRING_WITH_NULL_LEN".
> >  - Note: The patch v2 and v3 has been verified by
> >    Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> >    http://spinics.net/lists/kernel/msg3840792.html
> 
> Dear Cascardo,
> 
> Would you please help to confirm if you've tested it on Linux PC,
> Chrome OS, or an Android OS?

I tested v3 on Ubuntu GNU/Linux. I will test v4.

Cascardo.

> 
> Thanks!
> Macpaul Lin
> 
> >    and
> >    Macpaul Lin <macpaul.lin@mediatek.com> on Android kernels.
> >    http://lkml.org/lkml/2020/6/11/8
> >  - The patch is suggested to be applied to LTS versions.
> > 
> >  drivers/usb/gadget/configfs.c |   14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
> > index 0d56f33..15a607c 100644
> > --- a/drivers/usb/gadget/configfs.c
> > +++ b/drivers/usb/gadget/configfs.c
> > @@ -97,6 +97,8 @@ struct gadget_config_name {
> >  	struct list_head list;
> >  };
> >  
> > +#define USB_MAX_STRING_WITH_NULL_LEN	(USB_MAX_STRING_LEN+1)
> > +
> >  static int usb_string_copy(const char *s, char **s_copy)
> >  {
> >  	int ret;
> > @@ -106,12 +108,16 @@ static int usb_string_copy(const char *s, char **s_copy)
> >  	if (ret > USB_MAX_STRING_LEN)
> >  		return -EOVERFLOW;
> >  
> > -	str = kstrdup(s, GFP_KERNEL);
> > -	if (!str)
> > -		return -ENOMEM;
> > +	if (copy) {
> > +		str = copy;
> > +	} else {
> > +		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
> > +		if (!str)
> > +			return -ENOMEM;
> > +	}
> > +	strcpy(str, s);
> >  	if (str[ret - 1] == '\n')
> >  		str[ret - 1] = '\0';
> > -	kfree(copy);
> >  	*s_copy = str;
> >  	return 0;
> >  }
> 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932D37F4C7
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390070AbfHBKKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:10:40 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:35710 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389243AbfHBKKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 06:10:40 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2019 06:10:40 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 842808007606
        for <stable@vger.kernel.org>; Fri,  2 Aug 2019 10:04:30 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id B157A837F24D;
        Fri,  2 Aug 2019 10:04:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:857:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1461:1515:1516:1518:1535:1543:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:5007:7576:7903:10004:10400:10848:11026:11232:11658:11914:12043:12291:12296:12297:12438:12555:12683:12740:12760:12895:13149:13161:13229:13230:13439:13972:14181:14659:14721:21080:21326:21451:21611:21627:21773:30012:30029:30054:30070:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: balls06_26e92d0181236
X-Filterd-Recvd-Size: 5010
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Fri,  2 Aug 2019 10:04:27 +0000 (UTC)
Message-ID: <9403fd1e250bb4dd8e1bcf0536e6d224be7c889c.camel@perches.com>
Subject: Re: [PATCH 5.2 10/20] media: radio-raremono: change devm_k*alloc to
 k*alloc
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        syzbot+a4387f5b6b799f6becbf@syzkaller.appspotmail.com
Date:   Fri, 02 Aug 2019 03:04:25 -0700
In-Reply-To: <20190802092100.285432717@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
         <20190802092100.285432717@linuxfoundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-08-02 at 11:40 +0200, Greg Kroah-Hartman wrote:
> From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
> 
> commit c666355e60ddb4748ead3bdd983e3f7f2224aaf0 upstream.
> 
> Change devm_k*alloc to k*alloc to manually allocate memory
> 
> The manual allocation and freeing of memory is necessary because when
> the USB radio is disconnected, the memory associated with devm_k*alloc
> is freed. Meaning if we still have unresolved references to the radio
> device, then we get use-after-free errors.
> 
> This patch fixes this by manually allocating memory, and freeing it in
> the v4l2.release callback that gets called when the last radio device
> exits.

This really should be commented in the code
and not just in the commit changelog as some
unsuspecting person will likely undo this in
the future without one.

> Reported-and-tested-by: syzbot+a4387f5b6b799f6becbf@syzkaller.appspotmail.com
> 
> Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> [hverkuil-cisco@xs4all.nl: cleaned up two small checkpatch.pl warnings]
> [hverkuil-cisco@xs4all.nl: prefix subject with driver name]
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/media/radio/radio-raremono.c |   30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> --- a/drivers/media/radio/radio-raremono.c
> +++ b/drivers/media/radio/radio-raremono.c
> @@ -271,6 +271,14 @@ static int vidioc_g_frequency(struct fil
>  	return 0;
>  }
>  
> +static void raremono_device_release(struct v4l2_device *v4l2_dev)
> +{
> +	struct raremono_device *radio = to_raremono_dev(v4l2_dev);
> +
> +	kfree(radio->buffer);
> +	kfree(radio);
> +}
> +
>  /* File system interface */
>  static const struct v4l2_file_operations usb_raremono_fops = {
>  	.owner		= THIS_MODULE,
> @@ -295,12 +303,14 @@ static int usb_raremono_probe(struct usb
>  	struct raremono_device *radio;
>  	int retval = 0;
>  
> -	radio = devm_kzalloc(&intf->dev, sizeof(struct raremono_device), GFP_KERNEL);
> -	if (radio)
> -		radio->buffer = devm_kmalloc(&intf->dev, BUFFER_LENGTH, GFP_KERNEL);
> -
> -	if (!radio || !radio->buffer)
> +	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
> +	if (!radio)
> +		return -ENOMEM;
> +	radio->buffer = kmalloc(BUFFER_LENGTH, GFP_KERNEL);
> +	if (!radio->buffer) {
> +		kfree(radio);
>  		return -ENOMEM;
> +	}
>  
>  	radio->usbdev = interface_to_usbdev(intf);
>  	radio->intf = intf;
> @@ -324,7 +334,8 @@ static int usb_raremono_probe(struct usb
>  	if (retval != 3 ||
>  	    (get_unaligned_be16(&radio->buffer[1]) & 0xfff) == 0x0242) {
>  		dev_info(&intf->dev, "this is not Thanko's Raremono.\n");
> -		return -ENODEV;
> +		retval = -ENODEV;
> +		goto free_mem;
>  	}
>  
>  	dev_info(&intf->dev, "Thanko's Raremono connected: (%04X:%04X)\n",
> @@ -333,7 +344,7 @@ static int usb_raremono_probe(struct usb
>  	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
>  	if (retval < 0) {
>  		dev_err(&intf->dev, "couldn't register v4l2_device\n");
> -		return retval;
> +		goto free_mem;
>  	}
>  
>  	mutex_init(&radio->lock);
> @@ -345,6 +356,7 @@ static int usb_raremono_probe(struct usb
>  	radio->vdev.ioctl_ops = &usb_raremono_ioctl_ops;
>  	radio->vdev.lock = &radio->lock;
>  	radio->vdev.release = video_device_release_empty;
> +	radio->v4l2_dev.release = raremono_device_release;
>  
>  	usb_set_intfdata(intf, &radio->v4l2_dev);
>  
> @@ -360,6 +372,10 @@ static int usb_raremono_probe(struct usb
>  	}
>  	dev_err(&intf->dev, "could not register video device\n");
>  	v4l2_device_unregister(&radio->v4l2_dev);
> +
> +free_mem:
> +	kfree(radio->buffer);
> +	kfree(radio);
>  	return retval;
>  }
>  
> 
> 


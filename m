Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242A81AF8C2
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 10:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgDSIaD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 19 Apr 2020 04:30:03 -0400
Received: from gwa7.newtekwebhosting.com ([63.134.207.35]:59988 "EHLO
        GWA7.newtekwebhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgDSIaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 04:30:02 -0400
Received: from maila14.newtekwebhosting.com (MAILA14.CRYSTALTECH.com [216.119.106.130]) by GWA7.newtekwebhosting.com with SMTP
        (version=TLS\Tls12
        cipher=Aes256 bits=256);
   Sun, 19 Apr 2020 01:29:53 -0700
Received: from [192.168.0.129] (static.55.32.0.81.ibercom.com [81.0.32.55]) by maila14.newtekwebhosting.com with SMTP
        (version=Tls12
        cipher=Aes256 bits=256);
   Sun, 19 Apr 2020 01:29:13 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: usb: dwc3: gadget: Don't clear flags before transfer ended
From:   Delio Brignoli <dbrignoli@audioscience.com>
In-Reply-To: <20200418163643.GC1809@sasha-vm>
Date:   Sun, 19 Apr 2020 10:29:31 +0200
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <28AEA449-C3A1-4272-86F6-0EA2829A2A75@audioscience.com>
References: <C9599B63-1C11-4EBC-AFCC-3A4F14830767@audioscience.com>
 <20200418105325.GA2875820@kroah.com> <20200418163643.GC1809@sasha-vm>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks to both of you for the help and quick response time!

Kind Regards
—
Delio Brignoli
AudioScience, Inc.
USA Sales Toll Free 1-855-AUDIOSC
<www.audioscience.com> - <http://www.facebook.com/AudioScienceInc>

> On 18 Apr 2020, at 18:36, Sasha Levin <sashal@kernel.org> wrote:
> 
> On Sat, Apr 18, 2020 at 12:53:25PM +0200, Greg KH wrote:
>> On Sat, Apr 18, 2020 at 12:25:16PM +0200, Delio Brignoli wrote:
>>> Please apply the following commit:
>>> 
>>> Commit subject: usb: dwc3: gadget: Don't clear flags before transfer ended
>>> Commit ID: a114c4ca64bd522aec1790c7e5c60c882f699d8f
>>> Apply to: at least 4.19 stable, and 5.4 stable if possible. Note that all kernels from v4.18-rc1 up to 5.7-rc1 are affected.
>>> 
>>> Why apply it:
>>> <https://github.com/torvalds/linux/commit/a114c4ca64bd522aec1790c7e5c60c882f699d8f> fixes <https://github.com/torvalds/linux/commit/6d8a019614f3a7630e0a2c1be4bf1cfc23acf56e>. Without this fix the built-in USB function source/sink test module fails to work with isochronous endpoints [1]. A side-effect of setting dep->flags = DWC3_EP_ENABLED; in dwc3_gadget_ep_cleanup_completed_requests() as part of disabling an ep is that a subsequent attempt to enable the endpoint will skip __dwc3_gadget_ep_enable() effectively leaving the ep disabled.
>>> 
>>> [1] Our gadget driver on TI AM5729 fails to work exactly like the built-in USB function source/sink test module when switching to alternate interface 1 because of the issue described above.
>>> 
>>> TI is currently using 4.19 and 5.4 stable kernels as the basis for their processor SDK kernels for their AM57x SoC and may switch to 5.4 stable at a later time. Thank you.
>> 
>> It does not apply to the 4.19.y kernel tree, can you provide a working
>> backport of it please so that I can apply it?
> 
> I took this as a dependency:
> 
> 	c5353b225df9 ("usb: dwc3: gadget: don't enable interrupt when disabling endpoint")
> 
> And worked around context conflicts caused by:
> 
> 	25abad6a0584 ("usb: dwc3: gadget: return errors from __dwc3_gadget_start_isoc()")
> 	d92021f66063 ("usb: dwc3: Add workaround for isoc start transfer failure")
> 
> And queued a114c4ca64bd for 4.19.
> 
> -- 
> Thanks,
> Sasha




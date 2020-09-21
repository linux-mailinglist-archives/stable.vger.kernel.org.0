Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BFE271E94
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgIUJKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 05:10:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:51542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgIUJKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 05:10:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600679428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k4aBzKLf83FphbFoSfruU9Nn+4qpdItMXvRpp/xUVks=;
        b=OxosJFYRwr9WxHZcW6cdnc1Zi99hmASZEtnYYVPZeAXQJ0xRBd1CaL0ZVk7Fopzs+9VYFa
        66Gfu2UN52ymIVr9BDTk24tGFfWLkHUJrNDJq2o33Tb5tTGDWSmViGrBE2e5bAcFJY9EbD
        V5WddnBt+zTW/qL607TltTN7KLHd/lU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9AC44AC2B;
        Mon, 21 Sep 2020 09:11:04 +0000 (UTC)
Message-ID: <1600679414.2424.62.camel@suse.com>
Subject: Re: [PATCH] [Patch v2] usbtv: Fix refcounting mixup
From:   Oliver Neukum <oneukum@suse.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>, ben.hutchings@codethink.co.uk,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Mon, 21 Sep 2020 11:10:14 +0200
In-Reply-To: <4550f8e2-38a9-b1f4-0277-25e79fed2e14@xs4all.nl>
References: <20180515130744.19342-1-oneukum@suse.com>
         <85dd974b-c251-47a5-600d-77b009e2dfcd@xs4all.nl>
         <1526399190.31771.2.camel@suse.com>
         <1ee4b00d-9a55-92cf-e708-1e0c60ca4bfd@xs4all.nl>
         <1526462623.25281.5.camel@suse.com>
         <4550f8e2-38a9-b1f4-0277-25e79fed2e14@xs4all.nl>
Content-Type: multipart/mixed; boundary="=-kk7jchXK1/63f2PKt/n3"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-kk7jchXK1/63f2PKt/n3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Am Mittwoch, den 16.05.2018, 12:27 +0200 schrieb Hans Verkuil:
> On 05/16/18 11:23, Oliver Neukum wrote:
> > Am Dienstag, den 15.05.2018, 18:01 +0200 schrieb Hans Verkuil:
> > > On 05/15/2018 05:46 PM, Oliver Neukum wrote:
> > > > Am Dienstag, den 15.05.2018, 16:28 +0200 schrieb Hans Verkuil:
> > > > > On 05/15/18 15:07, Oliver Neukum wrote:
> > Eh, but we cannot create a V4L device before the first device
> > is connected and we must certainly create multiple V4L devices if
> > multiple physical devices are connected.
> 
> v4l2_device_register is a terrible name. It does not create devices
> or register with anything, it just initializes a root data structure. I have
> proposed renaming this to v4l2_root_init() in the past, but people didn't
> want a big rename action.
> 
> BTW, with 'global data structure' I meant a data structure in struct usbtv.
> All I meant to say is that v4l2_device_register should be called in probe(),
> not in usbtv_video_init().

Hi,

Sorry for thread necromancy I am cleaning up electronically.
This patch has fallen through the cracks. As far as I can see the issue
is still open. I screwed this up. So do you want me to do a major
redesign? If not, what is to be done?

	Regards
		Oliver



--=-kk7jchXK1/63f2PKt/n3
Content-Disposition: attachment; filename="0001-Patch-v2-usbtv-Fix-refcounting-mixup.patch"
Content-Type: text/x-patch; name="0001-Patch-v2-usbtv-Fix-refcounting-mixup.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBjNjA0MDYxODY1MWQ2NzBiODk1MTk4MDk2ZTNmYTQ0MmI2Y2Y4YTI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBUdWUsIDE1IE1heSAyMDE4IDEyOjE2OjI2ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gW1BhdGNo
IHYyXSB1c2J0djogRml4IHJlZmNvdW50aW5nIG1peHVwCgpUaGUgcHJlbWF0dXJlIGZyZWUgaW4g
dGhlIGVycm9yIHBhdGggaXMgYmxvY2tlZCBieSBWNEwKcmVmY291bnRpbmcsIG5vdCBVU0IgcmVm
Y291bnRpbmcuIFRoYW5rcyB0bwpCZW4gSHV0Y2hpbmdzIGZvciByZXZpZXcuCgpbdjJdIGNvcnJl
Y3RlZCBhdHRyaWJ1dGlvbnMKClNpZ25lZC1vZmYtYnk6IE9saXZlciBOZXVrdW0gPG9uZXVrdW1A
c3VzZS5jb20+CkZpeGVzOiA1MGU3MDQ0NTM1NTMgKCJtZWRpYTogdXNidHY6IHByZXZlbnQgZG91
YmxlIGZyZWUgaW4gZXJyb3IgY2FzZSIpCkNDOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClJlcG9y
dGVkLWJ5OiBCZW4gSHV0Y2hpbmdzIDxiZW4uaHV0Y2hpbmdzQGNvZGV0aGluay5jby51az4KLS0t
CiBkcml2ZXJzL21lZGlhL3VzYi91c2J0di91c2J0di1jb3JlLmMgfCAzICsrLQogMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbWVkaWEvdXNiL3VzYnR2L3VzYnR2LWNvcmUuYyBiL2RyaXZlcnMvbWVkaWEvdXNiL3VzYnR2
L3VzYnR2LWNvcmUuYwppbmRleCBlZTljNjU2ZDEyMWYuLjIzMDhjMGI0ZjVlNyAxMDA2NDQKLS0t
IGEvZHJpdmVycy9tZWRpYS91c2IvdXNidHYvdXNidHYtY29yZS5jCisrKyBiL2RyaXZlcnMvbWVk
aWEvdXNiL3VzYnR2L3VzYnR2LWNvcmUuYwpAQCAtMTEzLDcgKzExMyw4IEBAIHN0YXRpYyBpbnQg
dXNidHZfcHJvYmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYsCiAKIHVzYnR2X2F1ZGlvX2Zh
aWw6CiAJLyogd2UgbXVzdCBub3QgZnJlZSBhdCB0aGlzIHBvaW50ICovCi0JdXNiX2dldF9kZXYo
dXNidHYtPnVkZXYpOworCXY0bDJfZGV2aWNlX2dldCgmdXNidHYtPnY0bDJfZGV2KTsKKwkvKiB0
aGlzIHdpbGwgdW5kbyB0aGUgdjRsMl9kZXZpY2VfZ2V0KCkgKi8KIAl1c2J0dl92aWRlb19mcmVl
KHVzYnR2KTsKIAogdXNidHZfdmlkZW9fZmFpbDoKLS0gCjIuMTYuNAoK


--=-kk7jchXK1/63f2PKt/n3--


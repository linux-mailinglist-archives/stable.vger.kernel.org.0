Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C6C3B75F0
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 17:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhF2P5Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 29 Jun 2021 11:57:24 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:28051 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233073AbhF2P5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 11:57:22 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-220-mzX9PE73Nm-qclt7qrCrOA-1; Tue, 29 Jun 2021 16:54:52 +0100
X-MC-Unique: mzX9PE73Nm-qclt7qrCrOA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 16:54:51 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Tue, 29 Jun 2021 16:54:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bjorn Andersson' <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
CC:     "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thara.gopinath@linaro.org" <thara.gopinath@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] soc: qcom: aoss: Fix the out of bound usage of
 cooling_devs
Thread-Topic: [PATCH] soc: qcom: aoss: Fix the out of bound usage of
 cooling_devs
Thread-Index: AQHXbP2JqXYxU5tlYEOLPsfLv/20yqsrIr2A
Date:   Tue, 29 Jun 2021 15:54:51 +0000
Message-ID: <4a0f56e3cb02435b911e8d35f6a83529@AcuMS.aculab.com>
References: <20210628172741.16894-1-manivannan.sadhasivam@linaro.org>
 <YNs/o7VVh+JnbxK9@yoga>
In-Reply-To: <YNs/o7VVh+JnbxK9@yoga>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson
> Sent: 29 June 2021 16:44
> 
> On Mon 28 Jun 12:27 CDT 2021, Manivannan Sadhasivam wrote:
> 
> > In "qmp_cooling_devices_register", the count value is initially
> > QMP_NUM_COOLING_RESOURCES, which is 2. Based on the initial count value,
> > the memory for cooling_devs is allocated. Then while calling the
> > "qmp_cooling_device_add" function, count value is post-incremented for
> > each child node.
> >
> > This makes the out of bound access to the cooling_dev array. Fix it by
> > resetting the count value to zero before adding cooling devices.
> >
> > While at it, let's also free the memory allocated to cooling_dev if no
> > cooling device is found in DT and during unroll phase.
> >
> > Cc: stable@vger.kernel.org # 5.4
> > Fixes: 05589b30b21a ("soc: qcom: Extend AOSS QMP driver to support resources that are used to wake
> up the SoC.")
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >
> > Bjorn: I've just compile tested this patch.
> >
> >  drivers/soc/qcom/qcom_aoss.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
> > index 934fcc4d2b05..98c665411768 100644
> > --- a/drivers/soc/qcom/qcom_aoss.c
> > +++ b/drivers/soc/qcom/qcom_aoss.c
> > @@ -488,6 +488,7 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
> >  	if (!qmp->cooling_devs)
> >  		return -ENOMEM;
> >
> > +	count = 0;
> 
> This will address the immediate problem, which is that we assign
> cooling_devs[2..] in this loop. But, like Matthias I don't think we
> should use "count" as a constant in the first hunk and then reset it
> and use it as a counter in the second hunk.
> 
> Frankly, I don't see why cooling_devs is dynamically allocated (without
> being conditional on there being any children).

Not to mention what happens if there are 3 matching nodes.
Given that qmp_cooling_device is only 4 pointers why bother
allocating a pointer to it at all.
Just instantiate 2 of them in the outer structure.
No is going to notice 56 bytes - it is probably hidden in the
padding when the outer structure is allocated.


> So, could you please make the cooling_devs an array of size
> QMP_NUM_COOLING_RESOURCES, remove the dynamic allocation here, just
> initialize count to 0 and add a check in the loop to generate an error
> if count == QMP_NUM_COOLING_RESOURCES?
> 

You should set count to 0 just before this loop - not at the top
of the function.

> >  	for_each_available_child_of_node(np, child) {
> >  		if (!of_find_property(child, "#cooling-cells", NULL))
> >  			continue;
> > @@ -497,12 +498,16 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
> >  			goto unroll;
> >  	}
> >
> > +	if (!count)
> > +		devm_kfree(qmp->dev, qmp->cooling_devs);
> 
> I presume this is just an optimization, to get some memory back when
> there's no cooling devices specified in DT.  I don't think this is
> necessary and this made me want the static sizing of the array..
> 
> > +
> >  	return 0;
> >
> >  unroll:
> >  	while (--count >= 0)
> >  		thermal_cooling_device_unregister
> >  			(qmp->cooling_devs[count].cdev);
> > +	devm_kfree(qmp->dev, qmp->cooling_devs);
> 
> I don't remember why we don't fail probe() when this happens, seems like
> the DT properties should be optional but the errors adding them should
> be fatal. But that's a separate issue.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6107D5BB023
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 17:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIPPZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 11:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIPPZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 11:25:40 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267B089CCA;
        Fri, 16 Sep 2022 08:25:39 -0700 (PDT)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MTd7l0hdYz67FSP;
        Fri, 16 Sep 2022 23:21:07 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 17:25:37 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 16:25:36 +0100
Date:   Fri, 16 Sep 2022 16:25:35 +0100
From:   Jonathan Cameron <Jonathan.Cameron@huawei.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Eddie James <eajames@linux.ibm.com>, <jic23@kernel.org>,
        <lars@metafoo.de>, <linux-iio@vger.kernel.org>, <joel@jms.id.au>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v8 2/2] iio: pressure: dps310: Reset chip after timeout
Message-ID: <20220916162535.00000cf6@huawei.com>
In-Reply-To: <CAHp75VfEktq10YcQMF9D9cQWtVsR+gx+3_PAq1YNoKUWEZaC1Q@mail.gmail.com>
References: <20220915195719.136812-1-eajames@linux.ibm.com>
        <20220915195719.136812-3-eajames@linux.ibm.com>
        <CAHp75VfEktq10YcQMF9D9cQWtVsR+gx+3_PAq1YNoKUWEZaC1Q@mail.gmail.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Sep 2022 08:51:13 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Thu, Sep 15, 2022 at 10:57 PM Eddie James <eajames@linux.ibm.com> wrote:
> >
> > The DPS310 chip has been observed to get "stuck" such that pressure
> > and temperature measurements are never indicated as "ready" in the
> > MEAS_CFG register. The only solution is to reset the device and try
> > again. In order to avoid continual failures, use a boolean flag to
> > only try the reset after timeout once if errors persist.  
> 
> ...
> 
> > +static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
> > +{
> > +       int rc;
> > +
> > +       rc = dps310_ready_status(data, ready_bit, timeout);
> > +       if (rc) {  
> 
> > +               if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {  
> 
> Here you compare rc with a certain error code...
> 
> > +                       /* Reset and reinitialize the chip. */
> > +                       if (dps310_reset_reinit(data)) {
> > +                               data->timeout_recovery_failed = true;
> > +                       } else {
> > +                               /* Try again to get sensor ready status. */  
> 
> > +                               if (dps310_ready_status(data, ready_bit, timeout))  
> 
> ...but here you assume that the only error code is -ETIMEDOUT. It's
> kinda inconsistent (if you rely on internals of ready_status, then why
> to check the certain error code, or otherwise why not to return a real
> second error code). That's why I asked about re-using rc here.

Hmm.

1st time around, any other error code would result in us just returning directly
which is fine.
2nd time around I'm not sure we care about what the error code is.  Even if
something else went wrong we failed to recover and the first error
that lead to that was -ETIMEDOUT.

So I think this is correct as is, be it a little unusual!

Jonathan

> 
> In any case I don't think this justifies a v9, let's wait for your
> answer and Jonathan's opinion.
> 
> > +                                       data->timeout_recovery_failed = true;
> > +                               else
> > +                                       return 0;
> > +                       }
> > +               }
> > +
> > +               return rc;
> > +       }
> > +
> > +       data->timeout_recovery_failed = false;
> > +       return 0;
> > +}  
> 


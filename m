Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CEA18E380
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCUR5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 13:57:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44240 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgCUR5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Mar 2020 13:57:35 -0400
Received: by mail-pf1-f194.google.com with SMTP id b72so5082957pfb.11
        for <stable@vger.kernel.org>; Sat, 21 Mar 2020 10:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Pv8727CqHKjdOJFWE3IBXc7KMjqe5Xxt4DnAwegUtcY=;
        b=aRu6Eu/6rjgASSbGgbWnx4cbAGbM8zBbTfdLAp1HbvBIztE22la/AaGt0U/57+qPjO
         3HWGiE2vLPobRK1QsIIYzQnKaKzjlkUh+QBKSpQTfkEQSyG3azHj+mufy5xmMX7A70s6
         8oInrQm5VqKFng0TgcjTWztj00aVQN7rm8WXVUn7GcLoiTYc9IkljbpYsdd30hDt3DAO
         iiCB7amVODyhQ3yqyzIOzeMb2qipzHto/eAdq8CBtAHnDCgTPHQZdEEUNqow30O+OzsH
         BkHvBB4ICQYqxLFN3FA+iuEvnHFuCCV69RvIuETn13ePpzmslMa3lKLSZvkW8usVjeVi
         cNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Pv8727CqHKjdOJFWE3IBXc7KMjqe5Xxt4DnAwegUtcY=;
        b=JO55l9U9Iqoijg6+l/Rdfpuzom1+AJmwTejZwhAesNPWibfrcgqKPEFgeS4sBKMR12
         2GKmDik8zDkHK3cfHVK+SpBNJnpM3Ff+K8mhLVnE2dAST8/+kPDHyeF0sc1n3I9EO8vM
         /VSGxdlJyEWxSci/R97OC2PBmd9afNYf2Pj3S9ojlHOFgmM/4/rwGReAC7j7ZkT936ql
         f8SP8bLazBfVbe+qAwxKatgPxexoNnntvk86AoVFI5zkeeMAQ+ZOOvJtnlsVK7ygslYM
         dl1BN6+/MLABmo9MIhgxupM15rnEhMU3MJexQ7M2vxYj58ooA2rgZMJoGopqYe2bit2U
         v0ug==
X-Gm-Message-State: ANhLgQ0NQW4g21z7EfGuBnSkewDV0M53h0hVoKURH3pFqcgbBY+nyY0t
        IQ2gArnpxmoEkoYJ2fmJpZMMVQ==
X-Google-Smtp-Source: ADFU+vtoMqFogpr70liujX2Va7RgU86lU2euOPLSIQjX6AxnAWP43a2hDIKlexf9gA1tx13wvlAxOQ==
X-Received: by 2002:a63:257:: with SMTP id 84mr14127515pgc.304.1584813453119;
        Sat, 21 Mar 2020 10:57:33 -0700 (PDT)
Received: from builder (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id c7sm4007767pgg.11.2020.03.21.10.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 10:57:32 -0700 (PDT)
Date:   Sat, 21 Mar 2020 10:57:29 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Cc:     Nikita Shubin <nshubin@topcon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v5] remoteproc: Fix NULL pointer dereference in
 rproc_virtio_notify
Message-ID: <20200321175729.GA52762@builder>
References: <20200306070325.15232-1-NShubin@topcon.com>
 <20200306072452.24743-1-NShubin@topcon.com>
 <6c7ef4f2-6f71-c2fb-b2e9-ad7cbeb7cfbc@st.com>
 <20200310120846.GA19430@topcon.com>
 <507197c5412e4b438aeb5c527be74b3a@SFHDAG3NODE1.st.com>
 <20200311200107.GZ1214176@minitux>
 <f6de2571-3541-7004-bc57-92cb3fef2c71@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6de2571-3541-7004-bc57-92cb3fef2c71@st.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 17 Mar 07:24 PDT 2020, Arnaud POULIQUEN wrote:
> On 3/11/20 9:01 PM, Bjorn Andersson wrote:
> > On Tue 10 Mar 06:19 PDT 2020, Arnaud POULIQUEN wrote:
> >>> On Mon, Mar 09, 2020 at 03:22:24PM +0100, Arnaud POULIQUEN wrote:
> >>>> On 3/6/20 8:24 AM, Nikita Shubin wrote:
[..]
> >>>>> diff --git a/drivers/remoteproc/remoteproc_virtio.c
> >>>>> b/drivers/remoteproc/remoteproc_virtio.c
> >>>>> index 8c07cb2ca8ba..31a62a0b470e 100644
> >>>>> --- a/drivers/remoteproc/remoteproc_virtio.c
> >>>>> +++ b/drivers/remoteproc/remoteproc_virtio.c
> >>>>> @@ -334,6 +334,13 @@ int rproc_add_virtio_dev(struct rproc_vdev
> >>> *rvdev, int id)
> >>>>>  	struct rproc_mem_entry *mem;
> >>>>>  	int ret;
> >>>>>
> >>>>> +	if (rproc->ops->kick == NULL) {
> >>>>> +		ret = -EINVAL;
> >>>>> +		dev_err(dev, ".kick method not defined for %s",
> >>>>> +				rproc->name);
> >>>>> +		goto out;
> >>>>> +	}
> >>>>> +
> >>>> Should the kick ops be mandatory for all the platforms? How about making
> >>> it optional instead?
> >>>
> >>> Hi, Arnaud.
> >>>
> >>> It is not mandatory, currently it must be provided if specified vdev entry is in
> >>> resourse table. Otherwise it looks like there is no point in creating vdev.
> >>
> >> Yes, my question was about having it optional for vdev also. A platform could implement the vdev
> >> without kick mechanism but by polling depending due to hardware capability...
> >> This could be an alternative avoiding to implement a dummy function in platform driver.
> >>
> > 
> > Is this a real thing or a theoretical suggestion?
> Only a theoretical suggestion, trigged by the IMX platform patchset which implement a "temporary" dummy kick.
> and based on OpenAMP lib implementation which does not request a doorbell.
> Anyway no issue to keep it mandatory here. 
> 

Thanks for confirming. I've applied the patch, with Mathieu's ack, and
we can loosen up this requirement when we need it in the future.

Regards,
Bjorn

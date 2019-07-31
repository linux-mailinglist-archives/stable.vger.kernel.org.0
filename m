Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1D67CCC2
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 21:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfGaTbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 15:31:19 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44246 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730916AbfGaTbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 15:31:18 -0400
Received: by mail-ot1-f66.google.com with SMTP id b7so21248562otl.11
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 12:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rS31TGE+Mlwy7Maxt5cv0TA4vXxyACTIm226Er7Yz18=;
        b=vOibndjhZQkynS4J/8fftBuH9T/2s/u1bVZrKWX86LTDWN++MLOqRy3Ep27/E6GVWU
         604TSX1CLsvH+6a7GFfdrcz0bOlElTQnUJyHPDHxB5BaxRZ+Or5Negww2J2ObAexe2fi
         3iM0qn+78IhWNMoJcDYY6HRxtIFDKeS2Zm1GUfXDIEf/Md7bDlfxseS5fZURC5fvAZs1
         ML/qgtz4s2tidgqbYLMFqk6qfgVncCuyp1caNzW8MQHd+Q6M2mu5/5l2d/s01juOsmmH
         VZa/fznlq7uCb+9a+N25RlWsrL6UJdyEv4JPpIrFWi327pk39aN4ehcBSWC1JFdArBUj
         T9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rS31TGE+Mlwy7Maxt5cv0TA4vXxyACTIm226Er7Yz18=;
        b=OPCZq3vyvivGZ8qH5knzvIeaYmrWIH5/AQ/uOfQHdfoNV7vPa04KLQVJpFb2bbTzu4
         TO1xIJYdSQYwNXgRKRlHQl+XQvAI5uw2hpgdpNFOFqavKMMecgJdkk4Xmnlnb956HLpq
         7Ll40ixh5VqTxy72SZd7dQzEDdNvjFGy3hqQo8nBkymna7QOmStPwJZU9bMsmt8ZCsLZ
         83jgiJKCs5I52DOGm6Ek7jmCKp3LwOtGvj/+sxPyUrZxB2havdqwKjlh/GmYgOxEVz44
         CKv3956Afa8I9DFfMuWbcq06Z5YVxtVtcnzobQ/I8mCFtokGn+WGZh5Skgt9vjAT1Hcx
         QXGw==
X-Gm-Message-State: APjAAAXhG2REf6uUyvfgP0nrAv1EMiaDaOTzPq1i7AojhWneZPgmn/6a
        EgJzIk1JcnFuSg3kU8m2l+9nbtp2DB7pUdD+ayhp3g==
X-Google-Smtp-Source: APXvYqxvLS6tHvfy6ibysI39PnAGiA0Vn1TCXbmDTTfULDYAWuHOLzupVb55cRBZPjvI9lxKLzSQW7IbxXyfUA8LS9c=
X-Received: by 2002:a9d:470d:: with SMTP id a13mr89782986otf.126.1564601478105;
 Wed, 31 Jul 2019 12:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190729190655.455345569@linuxfoundation.org> <20190729190721.610390670@linuxfoundation.org>
 <20190731181444.GA821@amd>
In-Reply-To: <20190731181444.GA821@amd>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 31 Jul 2019 12:31:07 -0700
Message-ID: <CAPcyv4iM3i3oBS3WRe8QHmD6zncAy0-CsgdbJ0WSt9RBiVgVqg@mail.gmail.com>
Subject: Re: [PATCH 4.19 112/113] libnvdimm/bus: Stop holding
 nvdimm_bus_list_mutex over __nd_ioctl()
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 11:15 AM Pavel Machek <pavel@denx.de> wrote:
>
> On Mon 2019-07-29 21:23:19, Greg Kroah-Hartman wrote:
> > From: Dan Williams <dan.j.williams@intel.com>
> >
> > commit b70d31d054ee3a6fc1034b9d7fc0ae1e481aa018 upstream.
> >
> > In preparation for fixing a deadlock between wait_for_bus_probe_idle()
> > and the nvdimm_bus_list_mutex arrange for __nd_ioctl() without
> > nvdimm_bus_list_mutex held. This also unifies the 'dimm' and 'bus' level
> > ioctls into a common nd_ioctl() preamble implementation.
>
> Ok, so this is a preparation patch, not a fix...
>
> > Marked for -stable as it is a pre-requisite for a follow-on fix.
>
> ...but follow-on fixes are going to be applied for 5.2 but not
> 4.19. So perhaps this one should not be in 4.19, either?

I plan to follow up with a backport of the series for 4.19. I have no
problem with v4.19 carrying this in the meantime, but if you want to
kick it out and wait for the backport, that's fine too.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3246C2AC9B6
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 01:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgKJAco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 19:32:44 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:44560 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729243AbgKJAco (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 19:32:44 -0500
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AA0SeA8027951;
        Tue, 10 Nov 2020 00:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : content-type : in-reply-to
 : mime-version; s=pps0720;
 bh=2zjEMjLOhNeoaS4wl1OzUD+rrN6El5yihwd2og3gOZw=;
 b=npjhWvz9qKuD5XdFgETcKMcXetr+XWRxD+d8hK3Le1xAm0DqVJ/zgE8yunCYYAEvSIwO
 js+V/T49t/tYod72paGJDWuXtbpwNaXQqT0oQS/D8RzRU7UOT43jstA0DoUzpAGsStb0
 jARw+nqHneCltGtHk+KL+V5ii4azSVSTGdOl/CCaU5hbnRvYNpdEUxp7qgeVZE2NsVV4
 sJC93E9zJ9JzmGy1Mt131CT+CrzYS7rNyz627vG3Pec0LJgzFmuZuPyOZABythy5F0VB
 rYc/fzGarO876a3bNxK04brIXk2aB70oMmruGqRAG1B+VTNo5OPTVpZju8qCX2bt085J cQ== 
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0a-002e3701.pphosted.com with ESMTP id 34p4ywdygd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 00:32:34 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id C390F66;
        Tue, 10 Nov 2020 00:32:33 +0000 (UTC)
Received: from rfwz62 (rfwz62.americas.hpqcorp.net [10.33.237.8])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 3D59475;
        Tue, 10 Nov 2020 00:32:33 +0000 (UTC)
Date:   Mon, 9 Nov 2020 17:32:32 -0700
From:   rwright@hpe.com
To:     chris@chris-wilson.co.uk
Cc:     mika.kuoppala@linux.intel.com, prathap.kumar.valsan@intel.com,
        akeem.g.abodunrin@intel.com, francesco.balestrieri@intel.com,
        jon.bloomfield@intel.com, stable@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Limit VFE threads based on GT
Message-ID: <20201110003121.GA17715@rfwz62>
Reply-To: rwright@hpe.com
References: <20201016175411.30406-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016175411.30406-1-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_15:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100002
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 06:54:11PM +0100, Chris Wilson wrote:

> MEDIA_STATE_VFE only accepts the 'maximum number of threads' in the
> range [0, n-1] where n is #EU * (#threads/EU) with the number of threads
> based on plaform and the number of EU based on the number of slices and
> subslices. This is a fixed number per platform/gt, so appropriately
> limit the number of threads we spawn to match the device.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2024
> Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
> Signed-off-by: Chris Wilson <chris at chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala at linux.intel.com>
> Cc: Prathap Kumar Valsan <prathap.kumar.valsan at intel.com>
> Cc: Akeem G Abodunrin <akeem.g.abodunrin at intel.com>
> Cc: Balestrieri Francesco <francesco.balestrieri at intel.com>
> Cc: Bloomfield Jon <jon.bloomfield at intel.com>
> Cc: <stable at vger.kernel.org> # v5.7+
> ---
> ...

I tested this patch and found that it prevents the GPU hang I had
reported on the HP Pavilion Mini 300-020 in
https://gitlab.freedesktop.org/drm/intel/-/issues/2413.

In more detail: I built linux-next at tag next-20201106 without
the patch, and booted the result on an Ubuntu 20.04 base system.  As
expected, I observed the hang that I had previously reported as soon as
Cinnnamon started when I entered graphical.target.

I then applied this patch - that being the only change to my kernel -
and I was able to boot to graphical.target 5 times consecutively without
any GPU hang.

You may add my endorsements:

Tested-by: Randy Wright <rwright@hpe.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2413
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2106

-- 
Randy Wright            Hewlett Packard Enterprise
Phone: (970) 898-0998   Mail: rwright@hpe.com

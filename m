Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F4149DBA0
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 08:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiA0HbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 02:31:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:36655 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233852AbiA0HbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 02:31:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643268673; x=1674804673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WpZCIaQ7itXdEHKPHwyl50Sh+SYGiZNsmk7z77SYSFU=;
  b=SqFZaHwJ2RHCsPEcBprIekNJeS0VQWWvB8thqkDmzS3aS+/PnHfmiuhC
   DfUIKWzaCAPm7hPiPy85QQwNCC+KfkRNK5jyDRkRU0v+JN1f7vcq3avvr
   HxfjKPuey42K6FMQTD7WPa61Vn+pNwOQWzCVCvBXa9lsCZI4XL2o2yPlQ
   eBgZBXwuF7Yr3gSTN4Pz2UpqZw6Je4yEmhzgfEziIOvJ3x7loPJeRbpPp
   ayXhn0WIvDwTqP0eKR0PSBLMM7A9QUmjXmG2JvTSs9MaTN34sFmpw718v
   Sej+/f8avqXwK55ifrjH6cpn7LuKGEyyVTYRMogrlF6GE/1cRCjXzM9VD
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="333129883"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="333129883"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 23:31:13 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="625125127"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 23:31:11 -0800
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id D0DD6202F2;
        Thu, 27 Jan 2022 09:31:08 +0200 (EET)
Date:   Thu, 27 Jan 2022 09:31:08 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND] media: omap3isp: Use struct_group() for memcpy()
 region
Message-ID: <YfJKPCXr4RjPL6lc@paasikivi.fi.intel.com>
References: <20220124172952.2411764-1-keescook@chromium.org>
 <20220125092426.7bdfba8f@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125092426.7bdfba8f@coco.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

On Tue, Jan 25, 2022 at 09:24:26AM +0100, Mauro Carvalho Chehab wrote:
> Em Mon, 24 Jan 2022 09:29:52 -0800
> Kees Cook <keescook@chromium.org> escreveu:
> 
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > intentionally writing across neighboring fields. Wrap the target region
> > in struct_group(). This additionally fixes a theoretical misalignment
> > of the copy (since the size of "buf" changes between 64-bit and 32-bit,
> > but this is likely never built for 64-bit).
> 
> 
> > FWIW, I think this code is totally broken on 64-bit (which appears to
> > not be a "real" build configuration): it would either always fail (with
> > an uninitialized data->buf_size) or would cause corruption in userspace
> > due to the copy_to_user() in the call path against an uninitialized
> > data->buf value:
> 
> It doesn't matter. This driver is specific for TI OMAP3 SoC, which
> is Cortex-A8 (32-bits). It only builds on 64 bit due to COMPILE_TEST.

I agree that "it doesn't matter" in any real configuration. But if it's
this easy to address omap3isp driver behaving nicely with compile test,
then this is definitely worth merging.

I'll pick the patch to my tree.

-- 
Kind regards,

Sakari Ailus

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2E7610E0D
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJ1KEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJ1KEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:04:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8621E56BAA;
        Fri, 28 Oct 2022 03:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666951458; x=1698487458;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=hhsMbbxGYStohAh15fvX1DMTKWlhhSTK1Gfncm9ni3g=;
  b=RIUM0epUNODLl2tp2Gdxg3lv6p3JpUQloT5b1a2M3MseV1MBgq1kJvWj
   M75FM2UhwHUvnTYZuRXFgPg2eYrtD3wprnaVKZ761Od+jXT671T1KqY8B
   hUI8VO9eSkAZh+OiPiC/+PGvF4p/U+b/VHeML4QyZAgICsxnMQ1U3Mq5w
   g3fuGlp6eJR2WfhffCr/wAZ3LuQM1zXeM6snHgneHLxBOheYXSp+O/P7w
   jMyLLNvXrsk6TVgWJfSMPyTVMwY7DxLFKHSqQoT9KO7b8dTecDGvTHTLx
   nODA7Annn8L2yqUXcoa7S6kiF5F8ui5iiNhWxDzllftEeFa6wMa9Bagtl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="288852935"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="288852935"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:04:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="627478453"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="627478453"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga007.jf.intel.com with SMTP; 28 Oct 2022 03:04:13 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 28 Oct 2022 13:04:11 +0300
Date:   Fri, 28 Oct 2022 13:04:11 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Hector Martin <marcan@marcan.st>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        asahi@lists.linux.dev, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
Message-ID: <Y1upGwtjWgtLUZ1k@intel.com>
References: <20221027101327.16678-1-marcan@marcan.st>
 <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 01:08:24PM +0200, Thomas Zimmermann wrote:
> I trust you when you say that <native>->XRGB8888 is not enough. But 
> although I've read your replies, I still don't understand why this 
> switch is necessary.
> 
> Why don't we call drm_fb_build_fourcc_list() with the native 
> format/formats and let it append a number of formats, such as adding 
> XRGB888, adding ARGB8888 if necessary, adding ARGB2101010 if necessary. 
> Each with a elaborate comment why and which userspace needs the format. (?)

Are you saying there is some real userspace that breaks without
the alpha formats? That would already be broken on many devices.

-- 
Ville Syrjälä
Intel

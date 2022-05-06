Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3264951D4C0
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbiEFJmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiEFJmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:42:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC545DA15;
        Fri,  6 May 2022 02:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651829918; x=1683365918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EfVh0TwU1na43d7YSTQ8W7xUhA6BV7DvuhVeaDzvcVY=;
  b=jp4MbhvBMyxRyk4E7AspkLYvNlumIeMyY/HV1ImcPDoIJwzp0a/4KCrA
   9kCNNPeHiQresLbbmPqN6YU8hqgd82pjZ/bh05wRu3B23B8DL8b2mDVDF
   ssbRtggfWPLXONHZQmdGizPkRL44Qx8Muq1BSmt10FoS5776ofzSt6IPH
   GgUEHupw+M9dpJ5Qczog4l+l/qS0JeROmSuV/BIFAPuwKqoJ3ZJMDecgx
   7Q1l37REj3SYYXkgskQIakU4t5+KsdbrLryQNyFOwTCgls6UyEUZK/dIA
   sdSo300DL5Ff0tWp8oCs1u/wj1REPgQ8txAsf1B3cdmtIcn9ySLA1r9Kz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="293621862"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="293621862"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 02:38:37 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="585890538"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 02:38:35 -0700
Date:   Fri, 6 May 2022 10:38:18 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Greg KH <greg@kroah.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: Re: [PATCH 02/12] crypto: qat - refactor submission logic
Message-ID: <YnTsikYX23hfQDZt@silpixa00400314>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-3-giovanni.cabiddu@intel.com>
 <YnTpPoN9JZqjqvsG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTpPoN9JZqjqvsG@kroah.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 11:24:14AM +0200, Greg KH wrote:
> On Fri, May 06, 2022 at 09:23:17AM +0100, Giovanni Cabiddu wrote:
> > Move the submission loop to a new function, qat_alg_send_message(), and
> > share it between the symmetric and the asymmetric algorithms.
> > 
> > If the HW queues are full return -ENOSPC instead of -EBUSY.
> > 
> > For both symmetric and asymmetric services set the number of retries
> > before returning an error to a value that works for both, 20 (was 10 for
> > symmetric and 100 for asymmetric).
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
> 
> What does this "fix" to require it to be backported to stable trees?
For two reasons, (1) the error code returned if the HW queues are full is
incorrect and (2) to facilitate the backport of the next fix "crypto:
qat - add backlog mechanism".
I can be more explicit in the commit message if required.

Thanks,

-- 
Giovanni

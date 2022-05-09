Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6AF520044
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbiEIOvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237605AbiEIOvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:51:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E0D24BB0C;
        Mon,  9 May 2022 07:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652107640; x=1683643640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ctbr8pn64aox4+GvXSlTrmhBa7uObSu6+nPSkOf5bqQ=;
  b=F9nMofqZ8fLjG/wJryu+78hNbdFEcKCIz/MNeccSmfUvi79RoCaVEPaD
   z9ugDvUaAMhNjz6NoKEmgrvBHvMiD2q8oF3Kcfqs4ejiekkcA+zpRGgx2
   46mGYU8QlPUMUHYuBRipbBhrUIB4dS6HsAdCGF+mCYlmgdz2fDIqUfo7X
   D0SZrZdGBU+CbkloLsbV1E0lbe3sG8wzaMX6TnX7uOHSifsgdESDjLxPf
   WZ98SH2OadGEGpnXizV2TfqP30WmOynhM0IN415fhPVQ9SFd4bWI7DSwT
   2ATIy278HdF9S3h7m8Rr6qYUOYNOQB8FAYfRDdoBrOqdyYXubz4p6OwuL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269002439"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="269002439"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 07:47:19 -0700
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="657093336"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 07:47:17 -0700
Date:   Mon, 9 May 2022 15:47:10 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, Vlad Dronov <vdronov@redhat.com>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH v3 10/10] crypto: qat - re-enable registration of
 algorithms
Message-ID: <YnkpbpEkvF8uwN4s@silpixa00400314>
References: <20220509133417.56043-1-giovanni.cabiddu@intel.com>
 <20220509133417.56043-11-giovanni.cabiddu@intel.com>
 <YnkhD5YY3thCMkgX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnkhD5YY3thCMkgX@kroah.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 04:11:27PM +0200, Greg KH wrote:
> On Mon, May 09, 2022 at 02:34:17PM +0100, Giovanni Cabiddu wrote:
> > Re-enable the registration of algorithms after fixes to (1) use
> > pre-allocated buffers in the datapath and (2) support the
> > CRYPTO_TFM_REQ_MAY_BACKLOG flag.
> > 
> > This reverts commit 8893d27ffcaf6ec6267038a177cb87bcde4dd3de.
> 
> Then why not just have this be a "normal" revert commit?
It can be a revert commit. I didn't send a revert commit since I never
saw one in the crypto mailing list.

> And why is this ok for stable kernels?  This feels like a new feature
> (i.e. the code finally works.)  Why not just have users who want to use
> this use a newer kernel?  What bugfix does this resolve in older kernels
> (and "the driver did not work" is not really a good reason.)
After the bug report in [1], the final decision was to disable the
algorithms until the issue was fixed.
This set is fixing the issues that cause [1] and a few other minor ones
before re-enabling the algos.

I think there is value in having these fixes in stable as they allow to
re-enable services that were available before the 5.17 time frame.

Regards,

-- 
Giovanni

[1] https://lore.kernel.org/linux-crypto/CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com/

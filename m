Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D946B08FE
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCHNaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjCHN3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:29:47 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9830C4ECD;
        Wed,  8 Mar 2023 05:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282130; x=1709818130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FWISPkpZxi7gnMkFyl3lbV49vi0QElTd+0JnxePQ0Lg=;
  b=LTPp8KWyafKQyiAZQqVtpQkg4ZwfQJF8sPOC9wWZg8gOGND7v4p3PiUs
   OjtmvqeY2IXz4JFWU1f1fue+RJTzCQFgP7AfWZe8uuNLaGKZbWvvsw7kY
   mWAzREVwRNPdDdXXTI00HdD3+I+C9c+8LSPFyDl7hXybCJgxw3rAT/gXY
   bBQd41q+GeAyx6pP3Mf854gBPjLMHMiCKgUELc7muel0FIePbDVBf9liN
   wuLZRgq49/mNnqoAMuOjpvVDlja4nuZBuJXkdNdFE8J5Z1CuOxsWVJS06
   3cwmQ2Lryf9RP00U1ZA7BU3c+kVqXmLCt4To0gGYPlNYjX0yVgzJv2/xT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338477944"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="338477944"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:28:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="820216253"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="820216253"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 08 Mar 2023 05:28:32 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 08 Mar 2023 15:28:32 +0200
Date:   Wed, 8 Mar 2023 15:28:32 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] usb: ucsi: Fix ucsi->connector race
Message-ID: <ZAiNgJnNtvPEdIVO@kuha.fi.intel.com>
References: <20230307103421.8686-1-hdegoede@redhat.com>
 <20230307103421.8686-3-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307103421.8686-3-hdegoede@redhat.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 11:34:20AM +0100, Hans de Goede wrote:
> ucsi_init() which runs from a workqueue sets ucsi->connector and
> on an error will clear it again.
> 
> ucsi->connector gets dereferenced by ucsi_resume(), this checks for
> ucsi->connector being NULL in case ucsi_init() has not finished yet;
> or in case ucsi_init() has failed.
> 
> ucsi_init() setting ucsi->connector and then clearing it again on
> an error creates a race where the check in ucsi_resume() may pass,
> only to have ucsi->connector free-ed underneath it when ucsi_init()
> hits an error.
> 
> Fix this race by making ucsi_init() store the connector array in
> a local variable and only assign it to ucsi->connector on success.
> 
> Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v3:
> - Assign connector[i].index before calling ucsi_register_port() instead of
>   passing i to ucsi_register_port()

You forgot to rebase this. It does not apply.

thanks,

-- 
heikki

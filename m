Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84066750FD
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 10:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjATJ0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 04:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjATJ0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 04:26:45 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0207C9085F;
        Fri, 20 Jan 2023 01:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674206778; x=1705742778;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pp6YsFHbNJbOjAi4UCj2hbYp1XbmMKUOQriB/Adxhw0=;
  b=b6pfOqgkZzV4oZlS8JczGMEcsinQrSlHbBCKNKEc3/tvd0ljl0cwmC/A
   5N/x2ESNCC72tskhZ2FA+ItvxsJSIFSZyL2jVX19e3A19cbigcGpNEIG8
   jIoPRC19uU+zIN6VW5RJ1Thm+6t455b9VVRG3vXZe65Zvwq1kwchAvA1H
   +X9OI8tsjN5yTrP3s4JiPz6hqDNG0PLHmgYB2eGP3RHfB13FbKTLm5W7I
   TD/WRmdUXQfdzQ0ONyqnpSAm3zJzijhhSm3UY4r5umtD4jHiXstx3Q13O
   28gtxhzY4a5TcO1SPhecVIeRsIMvAMwvjSqHSjzjAP6KggW3inFozaw//
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305216221"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="305216221"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 01:23:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="803016254"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="803016254"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 20 Jan 2023 01:23:17 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Fri, 20 Jan 2023 11:23:17 +0200
Date:   Fri, 20 Jan 2023 11:23:17 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Update active state
Message-ID: <Y8pdha65Co0DCihr@kuha.fi.intel.com>
References: <20230118031514.1278139-1-pmalani@chromium.org>
 <Y8e+YlKiC6FHdQ5s@kuha.fi.intel.com>
 <CACeCKafPzxYWh5a4xmeggc+4zRou73kHnwV-G5xMfQDheGgGdg@mail.gmail.com>
 <Y8kMsw/wT35KN7VK@kuha.fi.intel.com>
 <CACeCKaceu1KCPtpavBn23qyM29Eacxhm6L9SN78ZQxdzRCOk6Q@mail.gmail.com>
 <CACeCKaea_ZtzUZNAHMaDU9ff_BBs6sF_DqqMnkFcW_=_txVL4w@mail.gmail.com>
 <Y8pb+BTd7VJqwLzq@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8pb+BTd7VJqwLzq@kuha.fi.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 20, 2023 at 11:16:43AM +0200, Heikki Krogerus wrote:
> It's not be possible to enter a mode with tcpm.c unless there is
> a driver for the altmode currently. Something has to take care of the
> altmode, and if that something is not the altmode driver it would need
> to be the user space. Right now we don't have an interface for that.
> 
> In any case, if there's no driver for the altmode, then the partner
> altmode "active" file should not be visible.

I meant read-only :-).

thanks,

-- 
heikki
